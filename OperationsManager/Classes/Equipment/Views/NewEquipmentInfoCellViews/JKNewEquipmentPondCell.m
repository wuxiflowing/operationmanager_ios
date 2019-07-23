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
    statusValueLb.text = [self getWorkStatusDescribeWithWorkStatus:model.workStatus];

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

- (NSString *)getWorkStatusDescribeWithWorkStatus:(NSString *)workStatus{
    NSArray *status = [workStatus componentsSeparatedByString:@","];
    NSMutableArray *strStatus = [[NSMutableArray alloc] initWithCapacity:0];
    [status enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"0"]) {
            [strStatus addObject:@"正常"];
        }else if ([obj isEqualToString:@"1"]){
            [strStatus addObject:@"数据告警1"];
        }else if ([obj isEqualToString:@"2"]){
            [strStatus addObject:@"数据告警2"];
        }else if ([obj isEqualToString:@"3"]){
            [strStatus addObject:@"不在线告警"];
        }else if ([obj isEqualToString:@"5"]){
            [strStatus addObject:@"设备告警"];
        }else if ([obj isEqualToString:@"9"]){
            [strStatus addObject:@"电流异常"];
        }else if ([obj isEqualToString:@"10"]){
            [strStatus addObject:@"断电告警"];
        }else{
            [strStatus addObject:@""];
        }
    }];
    return [strStatus componentsJoinedByString:@"、"];
}

@end

