//
//  JKEquipmentControllerCell.m
//  OperationsManager
//
//  Created by    on 2018/7/20.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentControllerCell.h"
#import "JKEquipmentModel.h"

@implementation JKEquipmentControllerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)createUI:(JKEquipmentModel *)model {
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
    
    UILabel *upLimitOneLb = [[UILabel alloc] init];
    upLimitOneLb.text = @"上限1";
    upLimitOneLb.textColor = RGBHex(0x666666);
    upLimitOneLb.textAlignment = NSTextAlignmentLeft;
    upLimitOneLb.font = JKFont(14);
    [self addSubview:upLimitOneLb];
    [upLimitOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *upLimitOneValueLb = [[UILabel alloc] init];
    upLimitOneValueLb.text = [NSString stringWithFormat:@"%@mg/L",model.oxyLimitUp];
    upLimitOneValueLb.textColor = RGBHex(0x999999);
    upLimitOneValueLb.textAlignment = NSTextAlignmentRight;
    upLimitOneValueLb.font = JKFont(14);
    [self addSubview:upLimitOneValueLb];
    [upLimitOneValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerStateLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *downLimitOneLb = [[UILabel alloc] init];
    downLimitOneLb.text = @"下限1";
    downLimitOneLb.textColor = RGBHex(0x666666);
    downLimitOneLb.textAlignment = NSTextAlignmentLeft;
    downLimitOneLb.font = JKFont(14);
    [self addSubview:downLimitOneLb];
    [downLimitOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upLimitOneLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *downLimitOneValueLb = [[UILabel alloc] init];
    downLimitOneValueLb.text = [NSString stringWithFormat:@"%@mg/L",model.oxyLimitDownOne];
    downLimitOneValueLb.textColor = RGBHex(0x999999);
    downLimitOneValueLb.textAlignment = NSTextAlignmentRight;
    downLimitOneValueLb.font = JKFont(14);
    [self addSubview:downLimitOneValueLb];
    [downLimitOneValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upLimitOneValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *downLimitTwoLb = [[UILabel alloc] init];
    downLimitTwoLb.text = @"下限2";
    downLimitTwoLb.textColor = RGBHex(0x666666);
    downLimitTwoLb.textAlignment = NSTextAlignmentLeft;
    downLimitTwoLb.font = JKFont(14);
    [self addSubview:downLimitTwoLb];
    [downLimitTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downLimitOneLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *downLimitTwoValueLb = [[UILabel alloc] init];
    downLimitTwoValueLb.text = [NSString stringWithFormat:@"%@mg/L",model.oxyLimitDownTwo];
    downLimitTwoValueLb.textColor = RGBHex(0x999999);
    downLimitTwoValueLb.textAlignment = NSTextAlignmentRight;
    downLimitTwoValueLb.font = JKFont(14);
    [self addSubview:downLimitTwoValueLb];
    [downLimitTwoValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downLimitOneValueLb.mas_bottom).offset(5);
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
        make.top.equalTo(downLimitTwoLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *alarmOneValueLb = [[UILabel alloc] init];
    alarmOneValueLb.text = [NSString stringWithFormat:@"%@mg/L",model.alertlineOne];
    alarmOneValueLb.textColor = RGBHex(0x999999);
    alarmOneValueLb.textAlignment = NSTextAlignmentRight;
    alarmOneValueLb.font = JKFont(14);
    [self addSubview:alarmOneValueLb];
    [alarmOneValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downLimitTwoValueLb.mas_bottom).offset(5);
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
    alarmTwoValueLb.text = [NSString stringWithFormat:@"%@mg/L",model.alertlineTwo];
    alarmTwoValueLb.textColor = RGBHex(0x999999);
    alarmTwoValueLb.textAlignment = NSTextAlignmentRight;
    alarmTwoValueLb.font = JKFont(14);
    [self addSubview:alarmTwoValueLb];
    [alarmTwoValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmOneValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *controllerTypeLb = [[UILabel alloc] init];
    controllerTypeLb.text = @"控制器状态";
    controllerTypeLb.textColor = RGBHex(0x666666);
    controllerTypeLb.textAlignment = NSTextAlignmentLeft;
    controllerTypeLb.font = JKFont(14);
    [self addSubview:controllerTypeLb];
    [controllerTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmTwoLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];

    UILabel *controllerTypeValueLb = [[UILabel alloc] init];
    if ([[NSString stringWithFormat:@"%@",model.automatic] isEqualToString:@"0"]) {
        controllerTypeValueLb.text = @"手动";
    } else {
        controllerTypeValueLb.text = @"自动";
    }
    controllerTypeValueLb.textColor = RGBHex(0x999999);
    controllerTypeValueLb.textAlignment = NSTextAlignmentRight;
    controllerTypeValueLb.font = JKFont(14);
    [self addSubview:controllerTypeValueLb];
    [controllerTypeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alarmTwoValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];

}

@end
