//
//  JKGuidePagesCell.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKGuidePagesCell.h"

@implementation JKGuidePagesCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:SCREEN_BOUNDS];
    [self.contentView addSubview:self.imageView];
    
    CGFloat width = SCREEN_WIDTH / 3;

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    loginBtn.layer.cornerRadius = SCALE_SIZE(22);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.hidden = YES;
    [self.contentView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-SCALE_SIZE(30));
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(width, SCALE_SIZE(48)));
    }];
    self.loginBtn = loginBtn;
}

@end
