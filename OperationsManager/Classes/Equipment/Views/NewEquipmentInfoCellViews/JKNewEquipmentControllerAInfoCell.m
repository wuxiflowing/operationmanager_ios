//
//  JKNewEquipmentControllerAInfoCell.m
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKNewEquipmentControllerAInfoCell.h"
#import "JKNewEquipmentModel.h"

@implementation JKNewEquipmentControllerAInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)createUI:(JKNewEquipmentModel *)model {
    UILabel *controllerLb = [[UILabel alloc] init];
    controllerLb.text = @"控制器1配置";
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
    NSString *open = [NSString stringWithFormat:@"%@",model.open1];
    if ([open isEqualToString:@"1"]) {
        controllerStateLb.text = @"开";
        controllerStateLb.textColor = kGreenColor;
    } else {
        controllerStateLb.text = @"关";
        controllerStateLb.textColor = kRedColor;
    }
    controllerStateLb.textAlignment = NSTextAlignmentRight;
    controllerStateLb.font = JKFont(17);
    [self addSubview:controllerStateLb];
    [controllerStateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerLb);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *oUpLimitLb = [[UILabel alloc] init];
    oUpLimitLb.text = @"溶氧上限";
    oUpLimitLb.textColor = RGBHex(0x666666);
    oUpLimitLb.textAlignment = NSTextAlignmentLeft;
    oUpLimitLb.font = JKFont(14);
    [self addSubview:oUpLimitLb];
    [oUpLimitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *oUpLimitValueLb = [[UILabel alloc] init];
    oUpLimitValueLb.text = [NSString stringWithFormat:@"%@mg/L",JKSafeNull(model.oxyLimitUp1)];
    oUpLimitValueLb.textColor = RGBHex(0x999999);
    oUpLimitValueLb.textAlignment = NSTextAlignmentRight;
    oUpLimitValueLb.font = JKFont(14);
    [self addSubview:oUpLimitValueLb];
    [oUpLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerStateLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *oDownLimitLb = [[UILabel alloc] init];
    oDownLimitLb.text = @"溶氧下限";
    oDownLimitLb.textColor = RGBHex(0x666666);
    oDownLimitLb.textAlignment = NSTextAlignmentLeft;
    oDownLimitLb.font = JKFont(14);
    [self addSubview:oDownLimitLb];
    [oDownLimitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oUpLimitLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *oDownLimitValueLb = [[UILabel alloc] init];
    oDownLimitValueLb.text = [NSString stringWithFormat:@"%@mg/L",JKSafeNull(model.oxyLimitDown1)];
    oDownLimitValueLb.textColor = RGBHex(0x999999);
    oDownLimitValueLb.textAlignment = NSTextAlignmentRight;
    oDownLimitValueLb.font = JKFont(14);
    [self addSubview:oDownLimitValueLb];
    [oDownLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oUpLimitValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *ammeterUpLimitLb = [[UILabel alloc] init];
    ammeterUpLimitLb.text = @"电流上限";
    ammeterUpLimitLb.textColor = RGBHex(0x666666);
    ammeterUpLimitLb.textAlignment = NSTextAlignmentLeft;
    ammeterUpLimitLb.font = JKFont(14);
    [self addSubview:ammeterUpLimitLb];
    [ammeterUpLimitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oDownLimitLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *ammeterUpLimitValueLb = [[UILabel alloc] init];
    if ([JKSafeNull(model.electricityUp1) isEqualToString:@""]) {
        ammeterUpLimitValueLb.text = @"--A";
    }else{
        ammeterUpLimitValueLb.text = [NSString stringWithFormat:@"%@ A",JKSafeNull(model.electricityUp1)];
    }
    ammeterUpLimitValueLb.textColor = RGBHex(0x999999);
    ammeterUpLimitValueLb.textAlignment = NSTextAlignmentRight;
    ammeterUpLimitValueLb.font = JKFont(14);
    [self addSubview:ammeterUpLimitValueLb];
    [ammeterUpLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oDownLimitValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *ammeterDownLimitLb = [[UILabel alloc] init];
    ammeterDownLimitLb.text = @"电流下限";
    ammeterDownLimitLb.textColor = RGBHex(0x666666);
    ammeterDownLimitLb.textAlignment = NSTextAlignmentLeft;
    ammeterDownLimitLb.font = JKFont(14);
    [self addSubview:ammeterDownLimitLb];
    [ammeterDownLimitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ammeterUpLimitLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *ammeterDownLimitValueLb = [[UILabel alloc] init];
    if ([JKSafeNull(model.electricityDown1) isEqualToString:@""]) {
        ammeterDownLimitValueLb.text = @"--A";
    }else{
        ammeterDownLimitValueLb.text = [NSString stringWithFormat:@"%@ A",JKSafeNull(model.electricityDown1)];
    }
    ammeterDownLimitValueLb.textColor = RGBHex(0x999999);
    ammeterDownLimitValueLb.textAlignment = NSTextAlignmentRight;
    ammeterDownLimitValueLb.font = JKFont(14);
    [self addSubview:ammeterDownLimitValueLb];
    [ammeterDownLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ammeterUpLimitValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];

    
    UILabel *equipmentStatusLb = [[UILabel alloc] init];
    equipmentStatusLb.text = @"设备状态";
    equipmentStatusLb.textColor = RGBHex(0x666666);
    equipmentStatusLb.textAlignment = NSTextAlignmentLeft;
    equipmentStatusLb.font = JKFont(14);
    [self addSubview:equipmentStatusLb];
    [equipmentStatusLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ammeterDownLimitLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *equipmentStatusValueLb = [[UILabel alloc] init];
    if ([[NSString stringWithFormat:@"%@",model.controlStatusAuto1] isEqualToString:@"1"]) {
        equipmentStatusValueLb.text = @"自动";
    }else{
        equipmentStatusValueLb.text = @"手动";
    }
    equipmentStatusValueLb.textColor = RGBHex(0x999999);
    equipmentStatusValueLb.textAlignment = NSTextAlignmentRight;
    equipmentStatusValueLb.font = JKFont(14);
    [self addSubview:equipmentStatusValueLb];
    [equipmentStatusValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ammeterDownLimitValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
}
@end

