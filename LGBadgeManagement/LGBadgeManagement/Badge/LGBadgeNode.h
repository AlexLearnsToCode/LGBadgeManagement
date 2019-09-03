//
//  LGBadgeNode.h
//  BadgeManagement
//
//  Created by Alexgao on 2019/4/11.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGBadgeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGBadgeNode : NSObject

/** 节点的key, 每个节点唯一 */
@property (nonatomic, copy) NSString *key;
/** 节点本身的值 */
@property (nonatomic) LGBadgeValue badgeValue;


/** 当前节点的子节点 */
@property (nonatomic) NSMutableSet<LGBadgeNode *> *subNodes;

/** 判断是否是某个节点的子节点, 用来避免环 */
- (BOOL)isSubNodeOf:(LGBadgeNode *)node;

@end

@interface LGBadgeNode (recursiveValueChanged)

/** 该节点的递归值是否改变, 创建时候默认yes */
@property (nonatomic) BOOL recursiveValueChanged;

@end

NS_ASSUME_NONNULL_END
