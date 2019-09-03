//
//  LGBadgeNode.m
//  BadgeManagement
//
//  Created by Alexgao on 2019/4/11.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import "LGBadgeNode.h"
#import <objc/runtime.h>

static const void *kRecursiveValueChangedKey = &kRecursiveValueChangedKey;

@interface LGBadgeNode ()

@end

@implementation LGBadgeNode

#pragma mark - API

- (BOOL)isSubNodeOf:(LGBadgeNode *)node {
    // 递归查找
    if ([node.subNodes containsObject:self]) {
        return YES;
    } else {
        for (LGBadgeNode *badgeNode in node.subNodes) {
            if ([self isSubNodeOf:badgeNode]) {
                return YES;
            }
        }
    }

    return NO;
}

#pragma mark - Super
/** 重写isEqual 使用节点的key来做比较 */
- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[LGBadgeNode class]]) {
        return NO;
    }
    
    LGBadgeNode *anotherNode = (LGBadgeNode *)object;
    return [anotherNode.key isEqualToString:self.key];
}

// !!!:Alexgao---还有一种做法是对关键属性进行位或运算, 但是此时只有一个关键属性
// 在hashTable中进行比较时,如果hash不等,则直接返回不等,如果hash相等,再进行isEqual判断     hash值相同是两个object equal的必要不充分条件
- (NSUInteger)hash {
    return self.key.hash;
}

/** 重写description,便于输出节点关系 */
- (NSString *)description {
    return @"";
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.subNodes = [NSMutableSet set];
        // 默认yes,先从递归取值
        self.recursiveValueChanged = YES;
    }
    return self;
}

@end


@implementation LGBadgeNode (recursiveValueChanged)

#pragma mark - Category
#pragma mark - *** Recursive Value Changed ***
- (void)setRecursiveValueChanged:(BOOL)recursiveValueChanged {
    objc_setAssociatedObject(self, kRecursiveValueChangedKey, @(recursiveValueChanged), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)recursiveValueChanged {
    return objc_getAssociatedObject(self, kRecursiveValueChangedKey);
}

@end
