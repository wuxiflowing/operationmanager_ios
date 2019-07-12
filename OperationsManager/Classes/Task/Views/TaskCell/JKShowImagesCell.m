//
//  JKShowImagesCell.m
//  BusinessManager
//
//  Created by    on 2018/9/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKShowImagesCell.h"

@implementation JKShowImagesCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.layer.masksToBounds = YES;
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT * 0.15 - 20);
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    self.titleLb.textColor = kWhiteColor;
    [self.contentView addSubview:self.titleLb];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = CGRectMake(0, SCREEN_HEIGHT * 0.15, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7);
    self.imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageView];
    
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.contentView addSubview:self.imageBtn];
}

@end
