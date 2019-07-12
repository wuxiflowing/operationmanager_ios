//
//  JKRepairedDeviceCell.m
//  OperationsManager
//
//  Created by    on 2018/8/27.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRepairedDeviceCell.h"

@interface JKRepairedDeviceCell ()
@property (nonatomic, strong) NSString *tskID;
@end

@implementation JKRepairedDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(NSString *)tskID {
    
    self.tskID = tskID;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *deviceLb = [[UILabel alloc] init];
    deviceLb.text = @"报修设备";
    deviceLb.textColor = RGBHex(0x333333);
    deviceLb.textAlignment = NSTextAlignmentLeft;
    deviceLb.font = JKFont(16);
    [bgView addSubview:deviceLb];
    [deviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(100, 48));
    }];
    
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
    
}


@end
