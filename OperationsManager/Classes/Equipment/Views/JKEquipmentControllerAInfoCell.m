//
//  JKEquipmentControllerAInfoCell.m
//  OperationsManager
//
//  Created by    on 2018/9/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentControllerAInfoCell.h"
#import "JKEquipmentModel.h"

@implementation JKEquipmentControllerAInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)createUI:(JKEquipmentModel *)model {
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
    NSString *open = [NSString stringWithFormat:@"%@",model.aeratorControlOne];
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
    
    UILabel *deviceTypeLb = [[UILabel alloc] init];
    deviceTypeLb.text = @"设备类型";
    deviceTypeLb.textColor = RGBHex(0x666666);
    deviceTypeLb.textAlignment = NSTextAlignmentLeft;
    deviceTypeLb.font = JKFont(14);
    [self addSubview:deviceTypeLb];
    [deviceTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *deviceTypeValueLb = [[UILabel alloc] init];
    deviceTypeValueLb.text = model.ammeterTypeA;
    deviceTypeValueLb.textColor = RGBHex(0x999999);
    deviceTypeValueLb.textAlignment = NSTextAlignmentRight;
    deviceTypeValueLb.font = JKFont(14);
    [self addSubview:deviceTypeValueLb];
    [deviceTypeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(controllerStateLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.text = @"名称";
    nameLb.textColor = RGBHex(0x666666);
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = JKFont(14);
    [self addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceTypeLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *nameValueLb = [[UILabel alloc] init];
    nameValueLb.text = model.channelA;
    nameValueLb.textColor = RGBHex(0x999999);
    nameValueLb.textAlignment = NSTextAlignmentRight;
    nameValueLb.font = JKFont(14);
    [self addSubview:nameValueLb];
    [nameValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceTypeValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *ammeterLb = [[UILabel alloc] init];
    ammeterLb.text = @"是否有电流表";
    ammeterLb.textColor = RGBHex(0x666666);
    ammeterLb.textAlignment = NSTextAlignmentLeft;
    ammeterLb.font = JKFont(14);
    [self addSubview:ammeterLb];
    [ammeterLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLb.mas_bottom).offset(5);
        make.left.equalTo(controllerLb);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *ammeterValueLb = [[UILabel alloc] init];
    if ([[NSString stringWithFormat:@"%@",model.hasAmmeterA] isEqualToString:@"true"]) {
        ammeterValueLb.text = @"有";
    } else {
        ammeterValueLb.text = @"无";
    }
    ammeterValueLb.textColor = RGBHex(0x999999);
    ammeterValueLb.textAlignment = NSTextAlignmentRight;
    ammeterValueLb.font = JKFont(14);
    [self addSubview:ammeterValueLb];
    [ammeterValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameValueLb.mas_bottom).offset(5);
        make.right.equalTo(controllerStateLb);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    if ([ammeterValueLb.text isEqualToString:@"有"]) {
        UILabel *ammeterNoLb = [[UILabel alloc] init];
        ammeterNoLb.text = @"电流表编号";
        ammeterNoLb.textColor = RGBHex(0x666666);
        ammeterNoLb.textAlignment = NSTextAlignmentLeft;
        ammeterNoLb.font = JKFont(14);
        [self addSubview:ammeterNoLb];
        [ammeterNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ammeterLb.mas_bottom).offset(5);
            make.left.equalTo(controllerLb);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        UILabel *ammeterNoValueLb = [[UILabel alloc] init];
        ammeterNoValueLb.text = model.ammeterIdA;
        ammeterNoValueLb.textColor = RGBHex(0x999999);
        ammeterNoValueLb.textAlignment = NSTextAlignmentRight;
        ammeterNoValueLb.font = JKFont(14);
        [self addSubview:ammeterNoValueLb];
        [ammeterNoValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ammeterValueLb.mas_bottom).offset(5);
            make.right.equalTo(controllerStateLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *powerLb = [[UILabel alloc] init];
        powerLb.text = @"功率";
        powerLb.textColor = RGBHex(0x666666);
        powerLb.textAlignment = NSTextAlignmentLeft;
        powerLb.font = JKFont(14);
        [self addSubview:powerLb];
        [powerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ammeterNoLb.mas_bottom).offset(5);
            make.left.equalTo(controllerLb);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
        
        UILabel *powerValueLb = [[UILabel alloc] init];
        powerValueLb.text = [NSString stringWithFormat:@"%@",model.powerA];
        powerValueLb.textColor = RGBHex(0x999999);
        powerValueLb.textAlignment = NSTextAlignmentRight;
        powerValueLb.font = JKFont(14);
        [self addSubview:powerValueLb];
        [powerValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ammeterNoValueLb.mas_bottom).offset(5);
            make.right.equalTo(controllerStateLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *voltageUpLimitLb = [[UILabel alloc] init];
        voltageUpLimitLb.text = @"电压上限";
        voltageUpLimitLb.textColor = RGBHex(0x666666);
        voltageUpLimitLb.textAlignment = NSTextAlignmentLeft;
        voltageUpLimitLb.font = JKFont(14);
        [self addSubview:voltageUpLimitLb];
        [voltageUpLimitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(powerLb.mas_bottom).offset(5);
            make.left.equalTo(controllerLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *voltageUpLimitValueLb = [[UILabel alloc] init];
        voltageUpLimitValueLb.text = [NSString stringWithFormat:@"%@ V",model.voltageUpA];
        voltageUpLimitValueLb.textColor = RGBHex(0x999999);
        voltageUpLimitValueLb.textAlignment = NSTextAlignmentRight;
        voltageUpLimitValueLb.font = JKFont(14);
        [self addSubview:voltageUpLimitValueLb];
        [voltageUpLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(powerValueLb.mas_bottom).offset(5);
            make.right.equalTo(controllerStateLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *voltageDownLimitLb = [[UILabel alloc] init];
        voltageDownLimitLb.text = @"电压下限";
        voltageDownLimitLb.textColor = RGBHex(0x666666);
        voltageDownLimitLb.textAlignment = NSTextAlignmentLeft;
        voltageDownLimitLb.font = JKFont(14);
        [self addSubview:voltageDownLimitLb];
        [voltageDownLimitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(voltageUpLimitLb.mas_bottom).offset(5);
            make.left.equalTo(controllerLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *voltageDownLimitValueLb = [[UILabel alloc] init];
        voltageDownLimitValueLb.text = [NSString stringWithFormat:@"%@ V",model.voltageDownA];
        voltageDownLimitValueLb.textColor = RGBHex(0x999999);
        voltageDownLimitValueLb.textAlignment = NSTextAlignmentRight;
        voltageDownLimitValueLb.font = JKFont(14);
        [self addSubview:voltageDownLimitValueLb];
        [voltageDownLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(voltageUpLimitValueLb.mas_bottom).offset(5);
            make.right.equalTo(controllerStateLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *ammeterUpLimitLb = [[UILabel alloc] init];
        ammeterUpLimitLb.text = @"电流上限";
        ammeterUpLimitLb.textColor = RGBHex(0x666666);
        ammeterUpLimitLb.textAlignment = NSTextAlignmentLeft;
        ammeterUpLimitLb.font = JKFont(14);
        [self addSubview:ammeterUpLimitLb];
        [ammeterUpLimitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(voltageDownLimitLb.mas_bottom).offset(5);
            make.left.equalTo(controllerLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *ammeterUpLimitValueLb = [[UILabel alloc] init];
        ammeterUpLimitValueLb.text = [NSString stringWithFormat:@"%@ A",model.electricCurrentUpA];
        ammeterUpLimitValueLb.textColor = RGBHex(0x999999);
        ammeterUpLimitValueLb.textAlignment = NSTextAlignmentRight;
        ammeterUpLimitValueLb.font = JKFont(14);
        [self addSubview:ammeterUpLimitValueLb];
        [ammeterUpLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(voltageDownLimitValueLb.mas_bottom).offset(5);
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
        ammeterDownLimitValueLb.text = [NSString stringWithFormat:@"%@ A",model.electricCurrentDownA];
        ammeterDownLimitValueLb.textColor = RGBHex(0x999999);
        ammeterDownLimitValueLb.textAlignment = NSTextAlignmentRight;
        ammeterDownLimitValueLb.font = JKFont(14);
        [self addSubview:ammeterDownLimitValueLb];
        [ammeterDownLimitValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ammeterUpLimitValueLb.mas_bottom).offset(5);
            make.right.equalTo(controllerStateLb);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
    }
}
@end
