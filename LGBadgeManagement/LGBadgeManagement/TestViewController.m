//
//  TestViewController.m
//  LGBadgeManagement
//
//  Created by Alexgao on 2019/4/12.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import "TestViewController.h"
#import "LGBadgeManager.h"

@interface TestViewController ()<LGKeyBadgeValueObserving>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[LGBadgeManager sharedInstance] addObserver:self forKey:@"3"];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[LGBadgeManager sharedInstance] setBadgeValue:LGBadgeValueReddot forKey:@"5"];
}

- (void)badgeManagerObservedBadgeValueChangedForKey:(NSString *)key badgeValue:(LGBadgeValue)badgeValue {
    NSLog(@"key------%@------value------%d", key, badgeValue);
}

- (void)dealloc{
    NSLog(@"test---dealloc.");
}

@end
