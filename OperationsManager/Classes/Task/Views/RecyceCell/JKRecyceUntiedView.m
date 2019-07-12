//
//  JKRecyceUntiedView.m
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceUntiedView.h"

#define Hight 812
#define Width 375

@interface JKRecyceUntiedView ()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UITextField *idTF;
@property (nonatomic, strong) NSString *ident;
@property (nonatomic, assign) NSInteger index;
@end

@implementation JKRecyceUntiedView

- (instancetype)initWithFrame:(CGRect)frame withIdent:(NSString *)ident withPondName:(NSString *)pondName withPondIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = index;
    
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
                [btn setTitle:@"确定" forState:UIControlStateNormal];
                [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
                btn.backgroundColor = kWhiteColor;
            }
            btn.titleLabel.font = JKFont(15);
            btn.layer.borderColor = RGBHex(0xdddddd).CGColor;
            btn.layer.borderWidth = 0.5;
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
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = @"是否解绑设备";
        titleLb.textColor = RGBHex(0x333333);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(18);
        [alertV addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(alertV);
            make.bottom.equalTo(lineLb.mas_top).offset(-10);
            make.height.mas_equalTo(60);
        }];
        
        UILabel *tipLb = [[UILabel alloc] init];
        tipLb.text = @"提示";
        tipLb.textColor = RGBHex(0x333333);
        tipLb.textAlignment = NSTextAlignmentCenter;
        tipLb.font = JKFont(15);
        [alertV addSubview:tipLb];
        [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(alertV);
            make.bottom.equalTo(titleLb.mas_top);
            make.height.mas_equalTo(20);
        }];
        
        self.ident = ident;
    }
    return self;
}

- (void)alertViewInView:(UIView *)view {
    [view addSubview:self];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 1) {
        if ([_delegate respondsToSelector:@selector(unitiedDevice:withDeviceIndex:)]) {
            [_delegate unitiedDevice:self.ident withDeviceIndex:self.index];
        }
        [self removeFromSuperview];
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark -- textField
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    self.ident = textField.text;
}

@end
