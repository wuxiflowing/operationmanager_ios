//
//  JKRepairDeviceCell.m
//  OperationsManager
//
//  Created by    on 2018/7/5.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRepairDeviceCell.h"

@interface JKRepairDeviceCell ()
@property (nonatomic, strong) NSArray *btnArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *tskID;
@end

@implementation JKRepairDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        self.btnArr = @[@"设备详情", @"参数配置", @"校准"];
    }
    return self;
}

#pragma mark -- 更换设备/删除
- (void)operationBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(addNewDevice:)]) {
        [_delegate addNewDevice:btn.tag];
    }
}

#pragma mark -- 按钮
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        if ([_delegate respondsToSelector:@selector(showDeviceInfo:)]) {
            [_delegate showDeviceInfo:self.tskID];
        }
    } else if (btn.tag == 1) {
        if ([_delegate respondsToSelector:@selector(configurationDeviceInfo:)]) {
            [_delegate configurationDeviceInfo:self.tskID];
        }
    } else {
        [self resetInstall];
    }
 }

#pragma mark -- 设备校准
- (void)resetInstall {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/%@/reset/install",kUrl_Base,[self.tskID trimmingCharacters]];

    [YJProgressHUD showProgressCircleNoValue:@"校准中..." inView:self];
    [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            [YJProgressHUD showMessage:@"校准成功" inView:self];
        } else {
            [YJProgressHUD showMessage:@"校准失败" inView:self];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)createUI:(NSString *)tskID withNewDevice:(BOOL)isNewDevice {
    
    self.tskID = tskID;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *deviceLb = [[UILabel alloc] init];
    if (isNewDevice) {
        deviceLb.text = @"新报修";
    } else {
        deviceLb.text = @"报修设备";
    }
    deviceLb.textColor = RGBHex(0x333333);
    deviceLb.textAlignment = NSTextAlignmentLeft;
    deviceLb.font = JKFont(16);
    [bgView addSubview:deviceLb];
    [deviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(100, 48));
    }];
    
    if (self.repaireType == JKRepaireIng) {
        UIButton *operationQYBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [operationQYBtn setTitle:@"更改为QY601" forState:UIControlStateNormal];
        [operationQYBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        operationQYBtn.tag = 601;
        [operationQYBtn addTarget:self action:@selector(operationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        operationQYBtn.titleLabel.font = JKFont(16);
        operationQYBtn.layer.cornerRadius = 4;
        operationQYBtn.layer.masksToBounds = YES;
        [operationQYBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [operationQYBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [operationQYBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        [bgView addSubview:operationQYBtn];
        [operationQYBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(deviceLb.mas_centerY);
            make.right.equalTo(bgView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(110, 30));
        }];
        
        UIButton *operationKDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [operationKDBtn setTitle:@"更改为KD326" forState:UIControlStateNormal];
        [operationKDBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        operationKDBtn.tag = 326;
        [operationKDBtn addTarget:self action:@selector(operationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        operationKDBtn.titleLabel.font = JKFont(16);
        operationKDBtn.layer.cornerRadius = 4;
        operationKDBtn.layer.masksToBounds = YES;
        [operationKDBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [operationKDBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [operationKDBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        [bgView addSubview:operationKDBtn];
        [operationKDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(deviceLb.mas_centerY);
            make.right.equalTo(operationQYBtn.mas_left).offset(-15);
            make.size.mas_equalTo(CGSizeMake(110, 30));
        }];
    }

    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *deviceIDLb = [[UILabel alloc] init];
    deviceIDLb.text = @"报修ID";
    deviceIDLb.textColor = RGBHex(0x333333);
    deviceIDLb.textAlignment = NSTextAlignmentLeft;
    deviceIDLb.font = JKFont(14);
    [bgView addSubview:deviceIDLb];
    [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLb.mas_bottom);
        make.left.equalTo(bgView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(100, 48));
    }];
    
    if (self.repaireType == JKRepaireIng) {
            UILabel *deviceValueIDLb = [[UILabel alloc] init];
            deviceValueIDLb.text = [NSString stringWithFormat:@"%@",tskID];
            deviceValueIDLb.textColor = RGBHex(0x333333);
            deviceValueIDLb.textAlignment = NSTextAlignmentRight;
            deviceValueIDLb.font = JKFont(14);
            [bgView addSubview:deviceValueIDLb];
            [deviceValueIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(deviceIDLb.mas_centerY);
                make.right.equalTo(bgView.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
        
        CGFloat width = (SCREEN_WIDTH - SCALE_SIZE(15)) / 4;
        for (NSInteger i = 0; i < self.btnArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.btnArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:RGBHex(0x666666) forState:UIControlStateNormal];
            btn.titleLabel.font = JKFont(14);
            btn.tag = i;
            btn.backgroundColor = [UIColor clearColor];
            btn.layer.borderColor = RGBHex(0xdddddd).CGColor;
            btn.layer.borderWidth = 1.0f;
            btn.layer.cornerRadius = 2;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(deviceIDLb.mas_bottom);
                make.bottom.equalTo(bgView).offset(-10);
                make.left.equalTo(bgView).offset(SCALE_SIZE(15) + (width + width / 2.5) * i );
                make.width.mas_equalTo(width);
            }];
        }
    } else {
        UILabel *deviceIDLb = [[UILabel alloc] init];
        deviceIDLb.text = @"123456";
        deviceIDLb.textColor = RGBHex(0x666666);
        deviceIDLb.textAlignment = NSTextAlignmentRight;
        deviceIDLb.font = JKFont(14);
        [bgView addSubview:deviceIDLb];
        [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineLb.mas_bottom);
            make.right.equalTo(bgView).offset(-SCALE_SIZE(15));
            make.size.mas_equalTo(CGSizeMake(100, 48));
        }];
    }
}

@end
