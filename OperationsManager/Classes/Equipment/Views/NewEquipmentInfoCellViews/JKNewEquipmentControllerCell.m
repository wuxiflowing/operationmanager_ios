//
//  JKNewEquipmentControllerCell.m
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKNewEquipmentControllerCell.h"
#import "JKNewEquipmentModel.h"

@implementation JKNewEquipmentControllerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)createUI:(JKNewEquipmentModel *)model {
    UILabel *controllerLb = [[UILabel alloc] init];
    controllerLb.text = @"传感器配置";
    controllerLb.textColor = RGBHex(0x333333);
    controllerLb.textAlignment = NSTextAlignmentLeft;
    controllerLb.font = JKFont(17);
    [self addSubview:controllerLb];
    [controllerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *controllerStateLb = [[UILabel alloc] init];
    controllerStateLb.text = @"";
    controllerStateLb.textColor = RGBHex(0x333333);
    controllerStateLb.textAlignment = NSTextAlignmentRight;
    controllerStateLb.font = JKFont(17);
    [self addSubview:controllerStateLb];
    [controllerStateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerLb);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *connectionTypeLb = [[UILabel alloc] init];
    connectionTypeLb.text = @"选择连接方式";
    connectionTypeLb.textColor = RGBHex(0x666666);
    connectionTypeLb.textAlignment = NSTextAlignmentLeft;
    connectionTypeLb.font = JKFont(14);
    [self addSubview:connectionTypeLb];
    [connectionTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    UILabel *connectionTypeValueLb = [[UILabel alloc] init];
    connectionTypeValueLb.text = model.connectionType.integerValue ?@"无线":@"有线";
    connectionTypeValueLb.textColor = kThemeColor;
    connectionTypeValueLb.textAlignment = NSTextAlignmentRight;
    connectionTypeValueLb.font = JKFont(16);
    [self addSubview:connectionTypeValueLb];
    [connectionTypeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerStateLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
   
    UILabel *alarmOneLb = [[UILabel alloc] init];
    alarmOneLb.text = @"报警线1";
    alarmOneLb.textColor = RGBHex(0x666666);
    alarmOneLb.textAlignment = NSTextAlignmentLeft;
    alarmOneLb.font = JKFont(14);
    [self addSubview:alarmOneLb];
    [alarmOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(connectionTypeLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *alarmOneValueLb = [[UILabel alloc] init];
    alarmOneValueLb.text = [NSString stringWithFormat:@"%@mg/L",model.alertline1];
    alarmOneValueLb.textColor = RGBHex(0x999999);
    alarmOneValueLb.textAlignment = NSTextAlignmentRight;
    alarmOneValueLb.font = JKFont(14);
    [self addSubview:alarmOneValueLb];
    [alarmOneValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(connectionTypeValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *alarmTwoLb = [[UILabel alloc] init];
    alarmTwoLb.text = @"报警线2";
    alarmTwoLb.textColor = RGBHex(0x666666);
    alarmTwoLb.textAlignment = NSTextAlignmentLeft;
    alarmTwoLb.font = JKFont(14);
    [self addSubview:alarmTwoLb];
    [alarmTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmOneLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *alarmTwoValueLb = [[UILabel alloc] init];
    alarmTwoValueLb.text = [NSString stringWithFormat:@"%@mg/L",model.alertline2];
    alarmTwoValueLb.textColor = RGBHex(0x999999);
    alarmTwoValueLb.textAlignment = NSTextAlignmentRight;
    alarmTwoValueLb.font = JKFont(14);
    [self addSubview:alarmTwoValueLb];
    [alarmTwoValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmOneValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
}

@end

