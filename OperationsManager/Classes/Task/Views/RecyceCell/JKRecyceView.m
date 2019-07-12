//
//  JKRecyceView.m
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceView.h"

#define Hight 812
#define Width 375

@interface JKRecyceView ()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *contentLb;
@end

@implementation JKRecyceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *coverView = [[UIView alloc] initWithFrame:frame];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.5;
        [self addSubview:coverView];
        
        UIView *alertV = [[UIView alloc] init];
        alertV.backgroundColor = kWhiteColor;
        alertV.alpha = 1;
        alertV.layer.cornerRadius = 10;
        alertV.layer.masksToBounds = YES;
        [self addSubview:alertV];
        [alertV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(coverView.mas_centerX);
            make.centerY.equalTo(coverView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(Width * 0.8, Hight * 0.2));
        }];
        
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
                btn.backgroundColor = kWhiteColor;
            } else {
                [btn setTitle:@"确认回收" forState:UIControlStateNormal];
                [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
            }
            btn.titleLabel.font = JKFont(15);
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertV addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(alertV.mas_bottom);
                make.left.equalTo(alertV.mas_left).offset(Width * 0.4 * i);
                make.size.mas_equalTo(CGSizeMake(Width * 0.4, Hight * 0.2 * 0.3));
            }];
            self.btn = btn;
        }
        
        UILabel *lineLb = [[UILabel alloc] init];
        lineLb.backgroundColor = RGBHex(0xdddddd);
        [alertV addSubview:lineLb];
        [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.btn.mas_top);
            make.left.right.equalTo(alertV);
            make.height.mas_equalTo(1);
        }];
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.textColor = RGBHex(0x333333);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(17);
        [alertV addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertV.mas_top).offset(Hight * 0.2 * 0.3 * 0.6);
            make.left.right.equalTo(alertV);
            make.height.mas_equalTo(Hight * 0.2 * 0.4 * 0.2);
        }];
        self.titleLb = titleLb;
        
        UILabel *contentLb = [[UILabel alloc] init];
        contentLb.textColor = RGBHex(0x333333);
        contentLb.textAlignment = NSTextAlignmentCenter;
        contentLb.font = JKFont(15);
        contentLb.numberOfLines = 0;
        [alertV addSubview:contentLb];
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(10);
            make.left.right.equalTo(alertV);
            make.height.mas_equalTo(Hight * 0.2 * 0.3);
        }];
        self.contentLb = contentLb;
        
    }
    return self;
}

- (void)alertViewInView:(UIView *)view WithTitle:(NSString *)title withContent:(NSString *)content {
    [view addSubview:self];
    
    self.titleLb.text = title;
    self.contentLb.text = content;
}


- (void)btnClick:(UIButton *)btn {
    [self removeFromSuperview];
}

@end
