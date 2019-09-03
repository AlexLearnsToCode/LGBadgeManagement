//
//  LGBadgeDefines.h
//  BadgeManagement
//
//  Created by Alexgao on 2019/4/11.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 (-∞, 0) 红点
 [0] 不显示
 (0, 9] big
 (9, 99] large
 (99, +∞) huge
 */
typedef NS_ENUM(SInt32, LGBadgeValue) {
    LGBadgeValueReddot = -1,
    LGBadgeValueNone,
    
    // 大于0的可以自由设值
};

// singleton
#undef    LG_SINGLETON
#define LG_SINGLETON( __class ) \
+ (__class * __nonnull)sharedInstance; \
+(instancetype) alloc __attribute__((unavailable("call sharedInstance instead")));\
+(instancetype) new __attribute__((unavailable("call sharedInstance instead")));\
-(instancetype) copy __attribute__((unavailable("call sharedInstance instead")));\
-(instancetype) mutableCopy __attribute__((unavailable("call sharedInstance instead")));\

#undef    IMP_SINGLETON
#define IMP_SINGLETON( __class ) \
+ (__class * __nonnull)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [[super alloc] init]; } ); \
return __singleton__; \
}

