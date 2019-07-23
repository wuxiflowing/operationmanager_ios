//
//  JKEquipmentCell.m
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentCell.h"
#import "JKPondModel.h"

@interface JKEquipmentCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *valueArr;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *modelType;
@property (nonatomic, strong) NSString *alarmType;
@property (nonatomic, strong) UILabel *deviceIDLb;
@property (nonatomic, strong) UILabel *modelLb;
@property (nonatomic, strong) UILabel *alarmLb;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation JKEquipmentCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
        _tableView.separatorColor = kClearColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kBgColor;
        
        self.titleArr = @[@"溶氧值", @"控制1状态", @"温度", @"控制2状态", @"PH值", @"控制方式"];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
    }
    return self;
}

- (void)configCellWithModel:(JKPondChildDeviceModel *)model{
    NSString *controlOne;
    NSString *controlTwo;
    NSString *automatic;
    if ([[NSString stringWithFormat:@"%@",model.aeratorControlOne] isEqualToString:@"0"]) {
        controlOne = @"关";
    } else {
        controlOne = @"开";
    }
    
    if ([[NSString stringWithFormat:@"%@",model.aeratorControlTwo] isEqualToString:@"0"]) {
        controlTwo = @"关";
    } else {
        controlTwo = @"开";
    }
    
    if ([[NSString stringWithFormat:@"%@",model.automatic] isEqualToString:@"0"]) {
        automatic = @"手动";
    } else {
        automatic = @"自动";
    }
    
    NSString *ph = model.ph != -1?[NSString stringWithFormat:@"%f",model.ph]:@"--";
    
    self.valueArr = @[[NSString stringWithFormat:@"%.2fml/L",model.dissolvedOxygen], controlOne, [NSString stringWithFormat:@"%f ℃",model.temperature], controlTwo, ph, automatic];
    self.deviceID = model.deviceIdentifier;
    self.modelType = model.type;
    
    self.alarmType = [self getWorkStatusDescribeWithWorkStatus:model.workStatus];
    [self.tableView reloadData];
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

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = JKFont(15);
    cell.textLabel.textColor = RGBHex(0x333333);
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"查看设备详情";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        [self.deviceIDLb removeFromSuperview];
        UILabel *deviceIDLb = [[UILabel alloc] init];
        deviceIDLb.text = [NSString stringWithFormat:@"设备ID:%@",self.deviceID];
        deviceIDLb.textColor = RGBHex(0x333333);
        deviceIDLb.textAlignment = NSTextAlignmentLeft;
        deviceIDLb.font =  JKFont(14);
        [cell addSubview:deviceIDLb];
        [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(10);
            make.left.equalTo(cell).offset(SCALE_SIZE(15));
            make.size.mas_equalTo(CGSizeMake(110, 20));
        }];
        self.deviceIDLb = deviceIDLb;
        
        [self.modelLb removeFromSuperview];
        UILabel *modelLb = [[UILabel alloc] init];
        modelLb.text = [NSString stringWithFormat:@"设备型号:%@",self.modelType];
        modelLb.textColor = RGBHex(0x333333);
        modelLb.textAlignment = NSTextAlignmentLeft;
        modelLb.font =  JKFont(14);
        [cell addSubview:modelLb];
        [modelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deviceIDLb);
            make.left.equalTo(deviceIDLb.mas_right);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        self.modelLb = modelLb;
        
        [self.alarmLb removeFromSuperview];
        UILabel *alarmLb = [[UILabel alloc] init];
        alarmLb.text = [NSString stringWithFormat:@"%@",self.alarmType];
        if ([self.alarmType isEqualToString:@"正常"]) {
            alarmLb.textColor = kGreenColor;
        } else {
            alarmLb.textColor = kRedColor;
        }
        alarmLb.textAlignment = NSTextAlignmentRight;
        alarmLb.font =  JKFont(14);
        [cell addSubview:alarmLb];
        [alarmLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(10);
            make.right.equalTo(cell).offset(-SCALE_SIZE(15));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 20));
        }];
        self.alarmLb = alarmLb;
        
        UILabel *lineTopLb = [[UILabel alloc] init];
        lineTopLb.backgroundColor = RGBHex(0xdddddd);
        [cell addSubview:lineTopLb];
        [lineTopLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deviceIDLb.mas_bottom).offset(10);
            make.left.right.equalTo(cell);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.bgView removeFromSuperview];
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kWhiteColor;
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(deviceIDLb.mas_bottom).offset(12);
            make.left.right.bottom.equalTo(cell);
        }];
        self.bgView = bgView;
        
        CGFloat width = (SCREEN_WIDTH - SCALE_SIZE(30)) / 3;
        CGFloat height = (180 - 30) / 2;
        for (NSInteger i = 0; i < self.titleArr.count; i++) {
            NSInteger col = i / 2;
            NSInteger row = i % 2;

            UIView *bgV = [[UIView alloc] init];
            bgV.backgroundColor = kWhiteColor;
            [bgView addSubview:bgV];
            [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(height * row);
                make.left.equalTo(bgView).offset(width * col + SCALE_SIZE(10));
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];

            UIView *roundV = [[UIView alloc] init];
            roundV.layer.cornerRadius = (height * 0.8) / 2;
            roundV.layer.masksToBounds = YES;
//            roundV.layer.borderColor = kThemeColor.CGColor;
//            roundV.layer.borderWidth = 1;
            [bgV addSubview:roundV];
            [roundV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bgV.mas_centerX);
                make.centerY.equalTo(bgV.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(height, height));
            }];

            UILabel *titleLb = [[UILabel alloc] init];
            titleLb.text = self.titleArr[i];
            titleLb.textColor = RGBHex(0x888888);
            titleLb.textAlignment = NSTextAlignmentCenter;
            titleLb.font = JKFont(14);
            [roundV addSubview:titleLb];
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(roundV.mas_centerY);
                make.left.right.equalTo(roundV);
                make.height.mas_equalTo(25);
            }];

            UILabel *valueLb = [[UILabel alloc] init];
            valueLb.text = [NSString stringWithFormat:@"%@",self.valueArr[i]];
            valueLb.textColor = RGBHex(0x333333);
            valueLb.textAlignment = NSTextAlignmentCenter;
            valueLb.font = JKFont(16);
            [roundV addSubview:valueLb];
            [valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(roundV.mas_centerY);
                make.left.right.equalTo(roundV);
                make.height.mas_equalTo(25);
            }];
        }
        
        UILabel *lineLb = [[UILabel alloc] init];
        lineLb.backgroundColor = RGBHex(0xdddddd);
        [cell addSubview:lineLb];
        [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell);
            make.left.right.equalTo(cell);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([_delegate respondsToSelector:@selector(equipmentInfoClick:)]) {
            [_delegate equipmentInfoClick:self.deviceID];
        }
    } 
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
