//
//  JKNewEquipmentInfoVC.m
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/12.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKNewEquipmentInfoVC.h"
#import "JKNewEquipmentModel.h"
#import "JKEquipmentChartCell.h"
#import "JKNewEquipmentInfoCell.h"

@interface JKNewEquipmentInfoVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKNewEquipmentInfoVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备详情";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self getDeviceInfo];
}

- (void)getDeviceInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/new/%@",kUrl_Base, self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKNewEquipmentModel *model = [[JKNewEquipmentModel alloc] init];
            model.identifier = responseObject[@"data"][@"identifier"];
            model.name = responseObject[@"data"][@"name"];
            model.type = responseObject[@"data"][@"type"];
            model.dissolvedOxygen = responseObject[@"data"][@"dissolvedOxygen"];
            model.temperature = responseObject[@"data"][@"temperature"];
            model.ph = responseObject[@"data"][@"ph"];
            model.workStatus = responseObject[@"data"][@"workStatus"];
            model.connectionType = responseObject[@"data"][@"connectionType"];
            model.alertline1 = responseObject[@"data"][@"alertline1"];
            model.alertline2 = responseObject[@"data"][@"alertline2"];
            
            NSArray *aeratorControls = responseObject[@"data"][@"deviceControlInfoBeanList"];
            if (aeratorControls.count != 0) {
                model.controlId1 = aeratorControls[0][@"controlId"];
                model.oxyLimitUp1 = aeratorControls[0][@"oxyLimitUp"];
                model.oxyLimitDown1 = aeratorControls[0][@"oxyLimitDown"];
                model.electricityUp1 = aeratorControls[0][@"electricityUp"];
                model.electricityDown1 = aeratorControls[0][@"electricityDown"];
                model.open1 = aeratorControls[0][@"open"];
                model.controlStatusAuto1 = aeratorControls[0][@"auto"];
                
                model.controlId2 = aeratorControls[1][@"controlId"];
                model.oxyLimitUp2 = aeratorControls[1][@"oxyLimitUp"];
                model.oxyLimitDown2 = aeratorControls[1][@"oxyLimitDown"];
                model.electricityUp2 = aeratorControls[1][@"electricityUp"];
                model.electricityDown2 = aeratorControls[1][@"electricityDown"];
                model.open2 = aeratorControls[1][@"open"];
                model.controlStatusAuto2 = aeratorControls[1][@"auto"];
                
                model.controlId3 = aeratorControls[2][@"controlId"];
                model.oxyLimitUp3 = aeratorControls[2][@"oxyLimitUp"];
                model.oxyLimitDown3 = aeratorControls[2][@"oxyLimitDown"];
                model.electricityUp3 = aeratorControls[2][@"electricityUp"];
                model.electricityDown3 = aeratorControls[2][@"electricityDown"];
                model.open3 = aeratorControls[2][@"open"];
                model.controlStatusAuto3 = aeratorControls[2][@"auto"];
                
                model.controlId4 = aeratorControls[3][@"controlId"];
                model.oxyLimitUp4 = aeratorControls[3][@"oxyLimitUp"];
                model.oxyLimitDown4 = aeratorControls[3][@"oxyLimitDown"];
                model.electricityUp4 = aeratorControls[3][@"electricityUp"];
                model.electricityDown4 = aeratorControls[3][@"electricityDown"];
                model.open4 = aeratorControls[3][@"open"];
                model.controlStatusAuto4 = aeratorControls[3][@"auto"];
                
            }
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}


#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 280;
    } else {
        if (self.dataSource.count == 0) {
            return 960;
        }
        return 850;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *cellIdentifier =@"JKEquipmentChartCell";
        JKEquipmentChartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKEquipmentChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withTskID:self.tskID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        NSString *cellIdentifier =@"JKNewEquipmentInfoCell";
        JKNewEquipmentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKNewEquipmentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataSource = self.dataSource;
        return cell;
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
