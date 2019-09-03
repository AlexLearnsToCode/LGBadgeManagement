//
//  LGBadgeView.m
//  BadgeManagement
//
//  Created by Alexgao on 2019/4/11.
//  Copyright © 2019 Alexgao. All rights reserved.
//

#import "LGBadgeView.h"

@interface LGBadgeView ()

@property (nonatomic) UILabel *numberLabel;
@property (nonatomic) UIImageView *reddotView;

@end

@implementation LGBadgeView

#pragma mark - API
- (void)setBadgeValue:(LGBadgeValue)badgeValue {
    _badgeValue = badgeValue;
    
    self.numberLabel.text = [self badgeStringFromBadgeNumber:badgeValue];
    self.reddotView.image = [UIImage imageNamed:[self reddotViewImageFromBadgeNumber:badgeValue]];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Priavate Methods
- (NSString *)badgeStringFromBadgeNumber:(SInt32)number{
    if (number >= 1 && number <= 99) {
        return [NSString stringWithFormat:@"%d", number];
    }
    return @"";
}

- (NSString *)reddotViewImageFromBadgeNumber:(SInt32)number{
    if (number > 99) {
        return @"msg_flag_huge";
    } else if (number > 9) {
        return @"msg_flag_large";
    } else if (number >= 1) {
        return @"msg_flag_big";
    } else if (number < 0) {
        return @"msg_flag_small";
    }
    return @"";
}

#pragma mark - Layout
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.numberLabel sizeToFit];
    self.numberLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    self.reddotView.frame = self.bounds;
}

#pragma mark - Subviews
- (void)setUpSubview{
    
    self.reddotView = [[UIImageView alloc] init];
    self.reddotView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.reddotView];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.numberLabel];
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubview];
    }
    return self;
}


@end
