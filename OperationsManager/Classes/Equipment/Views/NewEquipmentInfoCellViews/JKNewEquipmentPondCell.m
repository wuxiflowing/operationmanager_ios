//
//  JKNewEquipmentPondCell.m
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKNewEquipmentPondCell.h"
#import "JKNewEquipmentModel.h"

@implementation JKNewEquipmentPondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)createUI:(JKNewEquipmentModel *)model {
    UILabel *deviceLb = [[UILabel alloc] init];
    deviceLb.text = @"设备ID";
    deviceLb.textColor = RGBHex(0x666666);
    deviceLb.textAlignment = NSTextAlignmentLeft;
    deviceLb.font = JKFont(14);
    [self addSubview:deviceLb];
    [deviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *deviceIDLb = [[UILabel alloc] init];
    deviceIDLb.text = model.identifier;
    deviceIDLb.textColor = RGBHex(0x999999);
    deviceIDLb.textAlignment = NSTextAlignmentRight;
    deviceIDLb.font = JKFont(14);
    [self addSubview:deviceIDLb];
    [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceLb);
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(deviceLb.mas_right).offset(10);
        make.height.equalTo(deviceLb.mas_height);
    }];
    
    UILabel *statusLb = [[UILabel alloc] init];
    statusLb.text = @"设备状态";
    statusLb.textColor = RGBHex(0x666666);
    statusLb.textAlignment = NSTextAlignmentLeft;
    statusLb.font = JKFont(14);
    [self addSubview:statusLb];
    [statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceLb.mas_bottom).offset(5);
        make.left.equalTo(deviceLb.mas_left);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *statusValueLb = [[UILabel alloc] init];
    if ([[NSString stringWithFormat:@"%@",model.workStatus] isEqualToString:@"0"]) {
        statusValueLb.text = @"正常";
    } else if ([[NSString stringWithFormat:@"%@",model.workStatus] isEqualToString:@"1"]) {
        statusValueLb.text = @"告警限1";
    } else if ([[NSString stringWithFormat:@"%@",model.workStatus] isEqualToString:@"2"]) {
        statusValueLb.text = @"告警限2";
    } else if ([[NSString stringWithFormat:@"%@",model.workStatus] isEqualToString:@"3"]) {
        statusValueLb.text = @"不在线告警";
    } else if ([[NSString stringWithFormat:@"%@",model.workStatus] isEqualToString:@"4"]) {
        statusValueLb.text = @"超过上下限报警";
    } else if ([[NSString stringWithFormat:@"%@",model.workStatus] isEqualToString:@"-1"]) {
        statusValueLb.text = @"数据解析异常";
    }
    if ([statusValueLb.text isEqualToString:@"正常"]) {
        statusValueLb.textColor = kGreenColor;
    } else {
        statusValueLb.textColor = kRedColor;
    }
    statusValueLb.textAlignment = NSTextAlignmentRight;
    statusValueLb.font = JKFont(14);
    [self addSubview:statusValueLb];
    [statusValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceIDLb.mas_bottom).offset(5);
        make.right.equalTo(deviceIDLb.mas_right);
        make.left.equalTo(statusLb.mas_right).offset(10);
        make.height.equalTo(deviceIDLb.mas_height);
    }];
}

@end

