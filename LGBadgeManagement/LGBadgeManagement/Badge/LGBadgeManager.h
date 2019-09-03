//
//  LGBadgeManager.h
//  BadgeManagement
//
//  Created by Alexgao on 2019/4/10.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGBadgeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LGKeyBadgeValueObserving <NSObject>

@optional
/** 当key的值发生改变时回调 */
- (void)badgeManagerObservedBadgeValueChangedForKey:(NSString *)key badgeValue:(LGBadgeValue)badgeValue;
/** 受影响的key的值发生改变时回调 */
- (void)badgeManagerObservedRecursiveBadgeValueChangedForKey:(NSString *)key recursiveBadgeValue:(LGBadgeValue)recursiveBadgeValue;

@end

@class LGBadgeNode;
@interface LGBadgeManager : NSObject

LG_SINGLETON(LGBadgeManager)

#pragma mark - Observer
/** 对指定key绑定观察者,当key值直接变化或者受影响变化时产生回调 */
- (void)addObserver:(NSObject<LGKeyBadgeValueObserving> *)observer forKey:(NSString *)key;
/** 移除指定key的观察者 */
- (void)removeObserver:(NSObject<LGKeyBadgeValueObserving> *)observer forKey:(NSString *)key;

#pragma mark - Bind/Unbind
/** 将key绑定到toKey上 */
- (BOOL)bindKey:(NSString *)key toKey:(NSString *)toKey;
/** 将key从toKey上解绑 */
- (void)unbindKey:(NSString *)key toKey:(NSString *)toKey;
/** 移除key以及key相关的绑定关系 */
- (void)removeKey:(NSString *)key;

#pragma mark - Value
/** 对指定key赋值 */
- (void)setBadgeValue:(LGBadgeValue)badgeValue forKey:(NSString *)key;
/** key本身的值 */
- (LGBadgeValue)badgeValueForKey:(NSString *)key;
/** 从key绑定的子key中递归取值,有数值优先数值,无数值判断是否红点 */
- (LGBadgeValue)recursiveBadgeValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
