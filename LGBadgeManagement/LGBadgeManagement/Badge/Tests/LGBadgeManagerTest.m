//
//  LGBadgeManagerTest.m
//  LGBadgeManagementTests
//
//  Created by Alexgao on 2019/4/12.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LGBadgeManager.h"

@interface LGBadgeManagerTest : XCTestCase

@end

@implementation LGBadgeManagerTest

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

- (void)testBind {
    
    XCTAssertTrue([[LGBadgeManager sharedInstance] bindKey:@"testBind2" toKey:@"testBind1"]);
    XCTAssertTrue([[LGBadgeManager sharedInstance] bindKey:@"testBind3" toKey:@"testBind2"]);
    XCTAssertFalse([[LGBadgeManager sharedInstance] bindKey:@"testBind1" toKey:@"testBind3"]);
}

- (void)testUnBind {
    
    [[LGBadgeManager sharedInstance] bindKey:@"testUnBind2" toKey:@"testUnBind1"];
    [[LGBadgeManager sharedInstance] bindKey:@"testUnBind3" toKey:@"testUnBind2"];
    [[LGBadgeManager sharedInstance] bindKey:@"testUnBind4" toKey:@"testUnBind2"];
    [[LGBadgeManager sharedInstance] bindKey:@"testUnBind5" toKey:@"testUnBind4"];
    [[LGBadgeManager sharedInstance] bindKey:@"testUnBind5" toKey:@"testUnBind3"];
    
    [[LGBadgeManager sharedInstance] setBadgeValue:2 forKey:@"testUnBind5"];
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testUnBind3"], 2);
    
    [[LGBadgeManager sharedInstance] unbindKey:@"testUnBind5" toKey:@"testUnBind3"];
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testUnBind3"], 0);
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testUnBind1"], 2);
}

- (void)testRemove {
    [[LGBadgeManager sharedInstance] bindKey:@"testRemove2" toKey:@"testRemove1"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRemove3" toKey:@"testRemove2"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRemove4" toKey:@"testRemove2"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRemove5" toKey:@"testRemove4"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRemove5" toKey:@"testRemove3"];
    
    [[LGBadgeManager sharedInstance] setBadgeValue:2 forKey:@"testRemove5"];
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRemove3"], 2);
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRemove1"], 2);
    
    [[LGBadgeManager sharedInstance] removeKey:@"testRemove2"];
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRemove1"], 0);
    
    [[LGBadgeManager sharedInstance] removeKey:@"testRemove5"];
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRemove3"], 0);
    
}

- (void)testBadgeValue {
    [[LGBadgeManager sharedInstance] setBadgeValue:2 forKey:@"grandGrandChildNodeSecond"];
    XCTAssertEqual([[LGBadgeManager sharedInstance] badgeValueForKey:@"grandGrandChildNodeSecond"], 2);
}

/** 测试节点递归取值 */
- (void)testRecursiveBadgeValue {
    
    [[LGBadgeManager sharedInstance] bindKey:@"testRecursiveBadgeValue2" toKey:@"testRecursiveBadgeValue1"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRecursiveBadgeValue3" toKey:@"testRecursiveBadgeValue2"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRecursiveBadgeValue4" toKey:@"testRecursiveBadgeValue2"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRecursiveBadgeValue5" toKey:@"testRecursiveBadgeValue4"];
    [[LGBadgeManager sharedInstance] bindKey:@"testRecursiveBadgeValue5" toKey:@"testRecursiveBadgeValue3"];
    
    [[LGBadgeManager sharedInstance] setBadgeValue:2 forKey:@"testRecursiveBadgeValue5"];
    [[LGBadgeManager sharedInstance] setBadgeValue:LGBadgeValueReddot forKey:@"testRecursiveBadgeValue3"];
    
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRecursiveBadgeValue5"], 2);
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRecursiveBadgeValue3"], 2);
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRecursiveBadgeValue4"], 2);
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRecursiveBadgeValue2"], 2);
    XCTAssertEqual([[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"testRecursiveBadgeValue1"], 2);
}

@end
