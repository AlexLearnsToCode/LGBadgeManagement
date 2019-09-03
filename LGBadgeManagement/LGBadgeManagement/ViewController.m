//
//  ViewController.m
//  LGBadgeManagement
//
//  Created by Alexgao on 2019/4/12.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import "ViewController.h"
#import "LGBadgeManager.h"
#import "TestViewController.h"

@interface ViewController ()<LGKeyBadgeValueObserving>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[LGBadgeManager sharedInstance] addObserver:self forKey:@"1"];
    [[LGBadgeManager sharedInstance] addObserver:self forKey:@"3"];
    
    [[LGBadgeManager sharedInstance] bindKey:@"2" toKey:@"1"];
    [[LGBadgeManager sharedInstance] bindKey:@"3" toKey:@"2"];
    [[LGBadgeManager sharedInstance] bindKey:@"4" toKey:@"2"];
    [[LGBadgeManager sharedInstance] bindKey:@"5" toKey:@"4"];
    [[LGBadgeManager sharedInstance] bindKey:@"5" toKey:@"3"];
    
    [[LGBadgeManager sharedInstance] setBadgeValue:3 forKey:@"3"];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[LGBadgeManager sharedInstance] setBadgeValue:2 forKey:@"4"];
    
//    [[LGBadgeManager sharedInstance] setBadgeValue:2 forKey:@"5"];
    NSLog(@"key---%@------value---%d", @"1", [[LGBadgeManager sharedInstance] recursiveBadgeValueForKey:@"1"]);
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
}

- (void)badgeManagerObservedBadgeValueChangedForKey:(NSString *)key badgeValue:(LGBadgeValue)badgeValue {
   NSLog(@"key---%@------value---%d", key, badgeValue);
}

@end
