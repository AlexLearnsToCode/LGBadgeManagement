//
//  LGBadgeNodeTest.m
//  LGBadgeManagementTests
//
//  Created by Alexgao on 2019/4/12.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LGBadgeNode.h"

@interface LGBadgeNodeTest : XCTestCase

@end

@implementation LGBadgeNodeTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

/** 测试节点hash值 */
- (void)testHash {
    
    NSMutableSet *set = [NSMutableSet set];
    
    LGBadgeNode *badgeNodeFirst = [[LGBadgeNode alloc] init];
    badgeNodeFirst.key = @"badgeNodeFirst";
    [set addObject:badgeNodeFirst];
    
    LGBadgeNode *badgeNodeSecond = [[LGBadgeNode alloc] init];
    badgeNodeSecond.key = @"badgeNodeFirst";
    [set addObject:badgeNodeSecond];
    
    XCTAssertEqual(badgeNodeFirst.hash, badgeNodeSecond.hash);
    XCTAssertEqual(set.count, 1);
}

/** 测试节点相等 */
- (void)testEqual {
    
    NSMutableSet *set = [NSMutableSet set];
    
    LGBadgeNode *badgeNodeFirst = [[LGBadgeNode alloc] init];
    badgeNodeFirst.key = @"badgeNodeFirst";
    [set addObject:badgeNodeFirst];
    
    LGBadgeNode *badgeNodeSecond = [[LGBadgeNode alloc] init];
    badgeNodeSecond.key = @"badgeNodeFirst";
    
    XCTAssertTrue([badgeNodeFirst isEqual:badgeNodeSecond]);
    XCTAssertEqual(badgeNodeFirst, [set member:badgeNodeSecond]);
}

/** 测试节点本身的值 */
- (void)testValue {
    LGBadgeNode *badgeNode = [[LGBadgeNode alloc] init];
    badgeNode.badgeValue = LGBadgeValueNone;
    
    XCTAssertEqual(badgeNode.badgeValue, LGBadgeValueNone);
}

/** 测试是否是子节点 */
- (void)testSubNode{
    LGBadgeNode *parentNode = [[LGBadgeNode alloc] init];
    parentNode.key = @"parentNode";
    
    LGBadgeNode *childNodeFirst = [[LGBadgeNode alloc] init];
    childNodeFirst.key = @"childNodeFirst";
    [parentNode.subNodes addObject:childNodeFirst];
    
    LGBadgeNode *childNodeSecond = [[LGBadgeNode alloc] init];
    childNodeSecond.key = @"childNodeSecond";
    [childNodeFirst.subNodes addObject:childNodeSecond];
    
    LGBadgeNode *grandChildNodeFirst = [[LGBadgeNode alloc] init];
    grandChildNodeFirst.key = @"grandChildNodeFirst";
    [childNodeFirst.subNodes addObject:grandChildNodeFirst];
    
    LGBadgeNode *grandGrandChildNodeSecond = [[LGBadgeNode alloc] init];
    grandGrandChildNodeSecond.key = @"grandGrandChildNodeSecond";
    [childNodeSecond.subNodes addObject:grandGrandChildNodeSecond];
    
    [grandChildNodeFirst.subNodes addObject:grandGrandChildNodeSecond];
    
    XCTAssertTrue([childNodeFirst isSubNodeOf:parentNode]);
    XCTAssertTrue([grandChildNodeFirst isSubNodeOf:parentNode]);
    XCTAssertTrue([grandGrandChildNodeSecond isSubNodeOf:grandChildNodeFirst]);
    XCTAssertTrue([grandGrandChildNodeSecond isSubNodeOf:childNodeFirst]);
    XCTAssertTrue([grandGrandChildNodeSecond isSubNodeOf:parentNode]);
    XCTAssertFalse([grandChildNodeFirst isSubNodeOf:childNodeSecond]);
}

@end
