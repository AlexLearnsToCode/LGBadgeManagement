//
//  LGBadgeManager.m
//  BadgeManagement
//
//  Created by Alexgao on 2019/4/10.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import "LGBadgeManager.h"
#import "LGBadgeNode.h"

@interface LGBadgeManager ()

/** 所有节点 */
@property (nonatomic) NSMutableSet<LGBadgeNode *> *allNodes;

/** key的监听者 */
@property (nonatomic) NSMapTable *keysObserversMapTable;

/** 递归过的节点 */
@property (nonatomic) NSMutableSet<LGBadgeNode *> *recursiveNodes;

/** key的递归值的缓存 */
@property (nonatomic) NSCache *keysRecursiveValuesCache;

@end

@implementation LGBadgeManager

#pragma mark - Observer
/** 对指定key绑定观察者,当key值直接变化或者受影响变化时产生回调 */
- (void)addObserver:(NSObject<LGKeyBadgeValueObserving> *)observer forKey:(NSString *)key {
    NSHashTable *observersTable = [self.keysObserversMapTable objectForKey:key];
    if (!observersTable) {
        observersTable = [NSHashTable weakObjectsHashTable];
        [self.keysObserversMapTable setObject:observersTable forKey:key];
    }
    [observersTable addObject:observer];
}

/** 移除指定key的观察者 */
- (void)removeObserver:(NSObject<LGKeyBadgeValueObserving> *)observer forKey:(NSString *)key {
    NSHashTable *observersTable = [self.keysObserversMapTable objectForKey:key];
    if (observersTable) {
        [observersTable removeObject:observer];
    }
}

#pragma mark - Bind/Unbind
/** 将key绑定到toKey上 */
- (BOOL)bindKey:(NSString *)key toKey:(NSString *)toKey {
    
    if (!key.length) {
        NSAssert(key.length, @"empty key is invalid.");
        return NO;
    }
    
    if (!toKey.length) {
        NSAssert(toKey.length, @"empty toKey is invalid.");
        return NO;
    }
    
    LGBadgeNode *subNode = [self badgeNodeWithKey:key];
    LGBadgeNode *node = [self badgeNodeWithKey:toKey];
    if ([node isSubNodeOf:subNode]) {    // 如果存在环,则绑定失败
        return NO;
    }
    
    // NSMutableSet 自动做判重
    [node.subNodes addObject:subNode];
    
    
    return YES;
}

/** 将key从toKey上解绑 */
- (void)unbindKey:(NSString *)key toKey:(NSString *)toKey {
    
    // 1 key是否存在
    if (!key.length) {
        NSAssert(key.length, @"empty key is invalid.");
        return;
    }
    if (!toKey.length) {
        NSAssert(toKey.length, @"empty toKey is invalid.");
        return;
    }
    
    // 2 key对应的节点是否存在
    if (![self existsBadgeNodeWithKey:key]) {
        NSAssert(![self existsBadgeNodeWithKey:key], @"badge node with key doesn't exist.");
        return;
    }
    if (![self existsBadgeNodeWithKey:toKey]) {
        NSAssert(![self existsBadgeNodeWithKey:toKey], @"badge node with toKey doesn't exist.");
        return;
    }
    
    // 3 是否是子节点
    LGBadgeNode *subNode = [self badgeNodeWithKey:key];
    LGBadgeNode *node = [self badgeNodeWithKey:toKey];
    if ([subNode isSubNodeOf:node]) {
        [node.subNodes removeObject:subNode];
    }
}

/** 移除key以及key相关的绑定关系 */
- (void)removeKey:(NSString *)key {
    
    // 1 key是否存在
    if (!key.length) {
        NSAssert(key.length, @"empty key is invalid.");
        return;
    }
    
    // 2 key对应的节点是否存在
    if (![self existsBadgeNodeWithKey:key]) {
        NSAssert(![self existsBadgeNodeWithKey:key], @"badge node with key doesn't exist.");
        return;
    }
    
    // 3 从别的节点中的子节点中删除
    LGBadgeNode *removeNode = [self badgeNodeWithKey:key];
    
    for (LGBadgeNode *badgeNode in self.allNodes) {
        if ([badgeNode.subNodes containsObject:removeNode]) {
            [badgeNode.subNodes removeObject:removeNode];
        }
    }
    
    // 4 从总的节点中移除
    [self.allNodes removeObject:removeNode];
    
    // 5 对应的observer移除
    [self.keysObserversMapTable removeObjectForKey:key];
}

#pragma mark - Value
/** 对指定key赋值 */
- (void)setBadgeValue:(LGBadgeValue)badgeValue forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(key.length, @"empty key is invalid.");
        return;
    }
    // 即赋值给key本身
    LGBadgeNode *badgeNode = [self badgeNodeWithKey:key];
    
    if (badgeNode.badgeValue == badgeValue) {    // 如果和旧值相等,则不处理
        return;
    }
    
    // 设置新的badgeValue
    badgeNode.badgeValue = badgeValue;
    // 值改变时 需要通知所有绑定此key的监听者
    NSHashTable *observersTable = [self.keysObserversMapTable objectForKey:key];
    for (id observer in observersTable) {
        if ([observer respondsToSelector:@selector(badgeManagerObservedBadgeValueChangedForKey:badgeValue:)]) {
            [observer badgeManagerObservedBadgeValueChangedForKey:key badgeValue:badgeValue];
        }
    }
    
    // 受影响的node
    NSSet *parentNodes = [self parentNodesWithNode:badgeNode];
    for (LGBadgeNode *parentBadgeNode in parentNodes) {
        parentBadgeNode.recursiveValueChanged = YES;
        NSHashTable *observersTable = [self.keysObserversMapTable objectForKey:parentBadgeNode.key];
        if (!observersTable.count) {
            continue;
        }
        LGBadgeValue recursiveBadgeValue = [self recursiveBadgeValueForKey:parentBadgeNode.key];
        for (id observer in observersTable) {
            if ([observer respondsToSelector:@selector(badgeManagerObservedRecursiveBadgeValueChangedForKey:recursiveBadgeValue:)]) {
                [observer badgeManagerObservedRecursiveBadgeValueChangedForKey:parentBadgeNode.key recursiveBadgeValue:recursiveBadgeValue];
            }
        }
    }
}

/** key本身的值 */
- (LGBadgeValue)badgeValueForKey:(NSString *)key {
    LGBadgeNode *badgeNode = [self badgeNodeWithKey:key];
    return badgeNode.badgeValue;
}

/** 从key绑定的子key中递归取值,有数值优先数值,无数值判断是否红点 */
- (LGBadgeValue)recursiveBadgeValueForKey:(NSString *)key {
    
    LGBadgeNode *badgeNode = [self badgeNodeWithKey:key];
    
    // 1. 判断对应key的节点 递归值是否改变
    if (badgeNode.recursiveValueChanged) {    // 2. 如果改变, 则调用内部的递归取值方法,然后缓存,最后返回, 将recursive置为未改变
        
        self.recursiveNodes = [NSMutableSet set];
        LGBadgeValue recursiveBadgeValue = [self internal_recursiveBadgeValueForKey:key];
        
        [self.keysRecursiveValuesCache setObject:@(recursiveBadgeValue) forKey:key];
        
        badgeNode.recursiveValueChanged = NO;
        
        return recursiveBadgeValue;
    } else {    // 3. 如果未改变,则 从递归值的缓存中取值返回
        return [[self.keysRecursiveValuesCache objectForKey:key] intValue];
    }
}

- (LGBadgeValue)internal_recursiveBadgeValueForKey:(NSString *)key {
    
    LGBadgeNode *badgeNode = [self badgeNodeWithKey:key];
    
    // 递归取值时,避免对某些key重复取值(使用NSSet避免重复取值)
    // 对正值和负值处理
    LGBadgeValue reddotValue = LGBadgeValueNone;
    LGBadgeValue countValue = LGBadgeValueNone;
    
    if (!badgeNode.subNodes.count) {
        
        if ([self.recursiveNodes containsObject:badgeNode]) {    // 避免重复取值
            return LGBadgeValueNone;
        }
        
        [self.recursiveNodes addObject:badgeNode];
        
        if (badgeNode.badgeValue >= 0) {
            countValue += badgeNode.badgeValue;
        } else {
            reddotValue = LGBadgeValueReddot;
        }
    } else {
        for (LGBadgeNode *subBadgeNode in badgeNode.subNodes) {
            if ([self.recursiveNodes containsObject:subBadgeNode]) {    // 避免重复取值
                continue;
            }
            LGBadgeValue recursiveValue = [self internal_recursiveBadgeValueForKey:subBadgeNode.key];
            [self.recursiveNodes addObject:subBadgeNode]; 
            if (recursiveValue >= 0) {
                countValue += recursiveValue;
            } else {
                reddotValue = LGBadgeValueReddot;
            }
        }
    }
    
    if (countValue != LGBadgeValueNone) {
        return countValue;
    }
    if (reddotValue != LGBadgeValueNone) {
        return reddotValue;
    }
    
    return LGBadgeValueNone;
}

#pragma mark - Private Methods
/** 指定key的节点是否存在 */
- (BOOL)existsBadgeNodeWithKey:(NSString *)key {
    LGBadgeNode *tempNode = [[LGBadgeNode alloc] init];
    tempNode.key = key;
    return [self.allNodes containsObject:tempNode];
}

/** 根据指定key查找节点, 不存在则创建 */
- (LGBadgeNode *)badgeNodeWithKey:(NSString *)key {
    LGBadgeNode *tempNode = [[LGBadgeNode alloc] init];
    tempNode.key = key;
    LGBadgeNode *badgeNode = [self.allNodes member:tempNode];
    if (badgeNode == nil) {
        [self.allNodes addObject:tempNode];
        return tempNode;
    }
    return badgeNode;
}

// 找到某个节点所有的父节点
- (NSSet<LGBadgeNode *> *)parentNodesWithNode:(LGBadgeNode *)node {
    // 递归获取所有受影响的父节点
    NSMutableSet *parentNodes = [NSMutableSet set];
    for (LGBadgeNode *badgeNode in self.allNodes) {
        if ([node isSubNodeOf:badgeNode]) {
            [parentNodes addObject:badgeNode];
        }
    }
    return parentNodes;
}

#pragma mark - Init

- (instancetype)init{
    self = [super init];
    if (self) {
        self.allNodes = [NSMutableSet set];
        self.keysObserversMapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsStrongMemory];
        self.recursiveNodes = [NSMutableSet set];
    }
    return self;
}


IMP_SINGLETON(LGBadgeManager)

@end
