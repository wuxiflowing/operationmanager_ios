//
//  JKEquipmentInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/7/20.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentInfoVC.h"
#import "JKEquipmentInfoCell.h"
#import "JKEquipmentModel.h"
#import "JKEquipmentChartCell.h"

@interface JKEquipmentInfoVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKEquipmentInfoVC

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
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@",kUrl_Base, self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKEquipmentModel *model = [[JKEquipmentModel alloc] init];
            model.identifier = responseObject[@"data"][@"identifier"];
            model.name = responseObject[@"data"][@"name"];
            model.type = responseObject[@"data"][@"type"];
            model.dissolvedOxygen = responseObject[@"data"][@"dissolvedOxygen"];
            model.temperature = responseObject[@"data"][@"temperature"];
            model.ph = responseObject[@"data"][@"ph"];
            model.automatic = responseObject[@"data"][@"automatic"];
            model.workStatus = responseObject[@"data"][@"workStatus"];
            model.oxyLimitUp = responseObject[@"data"][@"oxyLimitUp"];
            model.oxyLimitDownOne = responseObject[@"data"][@"oxyLimitDownOne"];
            model.oxyLimitDownTwo = responseObject[@"data"][@"oxyLimitDownTwo"];
            model.alertlineOne = responseObject[@"data"][@"alertlineOne"];
            model.alertlineTwo = responseObject[@"data"][@"alertlineTwo"];
            NSArray *aeratorControls = responseObject[@"data"][@"aeratorControlList"];
            if (aeratorControls.count != 0) {
                model.aeratorControlOne = aeratorControls[0][@"open"];
                model.channelA = aeratorControls[0][@"name"];
                model.hasAmmeterA = aeratorControls[0][@"hasAmmeter"];
                model.ammeterTypeA = aeratorControls[0][@"ammeterType"];
                model.ammeterIdA = aeratorControls[0][@"ammeterId"];
                model.powerA = aeratorControls[0][@"power"];
                model.voltageUpA = aeratorControls[0][@"voltageUp"];
                model.voltageDownA = aeratorControls[0][@"voltageDown"];
                model.electricCurrentUpA = aeratorControls[0][@"electricCurrentUp"];
                model.electricCurrentDownA = aeratorControls[0][@"electricCurrentDown"];
                
                model.aeratorControlTwo = aeratorControls[1][@"open"];
                model.channelB = aeratorControls[1][@"name"];
                model.hasAmmeterB = aeratorControls[1][@"hasAmmeter"];
                model.ammeterTypeB = aeratorControls[1][@"ammeterType"];
                model.ammeterIdB = aeratorControls[1][@"ammeterId"];
                model.powerB = aeratorControls[1][@"power"];
                model.voltageUpB = aeratorControls[1][@"voltageUp"];
                model.voltageDownB = aeratorControls[1][@"voltageDown"];
                model.electricCurrentUpB = aeratorControls[1][@"electricCurrentUp"];
                model.electricCurrentDownB = aeratorControls[1][@"electricCurrentDown"];
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
        CGFloat Aheight;
        CGFloat Bheight;
        JKEquipmentModel *model = self.dataSource[0];
        if ([[NSString stringWithFormat:@"%@",model.hasAmmeterA] isEqualToString:@"true"]) {
            Aheight = 270;
        } else {
            Aheight = 120;
        }
        if ([[NSString stringWithFormat:@"%@",model.hasAmmeterB] isEqualToString:@"true"]) {
            Bheight = 270;
        } else {
            Bheight = 120;
        }
        return Aheight + Bheight + 270;
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
        NSString *cellIdentifier =@"JKEquipmentInfoCell";
        JKEquipmentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKEquipmentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
