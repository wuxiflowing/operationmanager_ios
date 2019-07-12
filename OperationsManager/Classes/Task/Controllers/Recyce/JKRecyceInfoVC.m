//
//  JKRecyceInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/7/5.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceInfoVC.h"
#import "JKRecyceOrderCell.h"
#import "JKTaskTopCell.h"
#import "JKRecyceOrderCell.h"
#import "JKRecyceDeviceCell.h"
#import "JKRecyceDeviceVC.h"
#import "JKRecyceResultCell.h"
#import "JKRecyceView.h"
#import "JKRecyceUntiedView.h"

@interface JKRecyceInfoVC () <UITableViewDelegate, UITableViewDataSource, JKRecyceDeviceCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JKRecyceInfoVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kClearColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"任务详情";
    
    [self.view addSubview:self.tableView];
    if (self.recyceType == JKRecyceWait) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-70);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"接 单" forState:UIControlStateNormal];
        [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        orderBtn.titleLabel.font = JKFont(16);
        orderBtn.layer.cornerRadius = 4;
        orderBtn.layer.masksToBounds = YES;
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-XTopHeight);
            make.left.equalTo(self.view.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(self.view.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(48);
        }];
        
        self.tableView.scrollEnabled = NO;
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
}

#pragma mark -- 确认回收/接单
- (void)orderBtnClick:(UIButton *)btn {
    if (self.recyceType == JKRecyceWait) {
        JKRecyceDeviceVC *rdVC = [[JKRecyceDeviceVC alloc] init];
        [self.navigationController pushViewController:rdVC animated:YES];
    } else if (self.recyceType == JKRecyceIng) {
        JKRecyceView *alertV = [[JKRecyceView alloc] initWithFrame:self.view.frame];
        [alertV alertViewInView:self.view WithTitle:@"确认回收" withContent:@"计划回收设备3套，实际回收设备2套，\n是否确认回收？"];
    }
}

#pragma mark -- 解绑设备
- (void)untiedDeviceWithTag:(NSInteger)tag withIsSelected:(NSInteger)isSelected {
    if (isSelected) {
        JKRecyceUntiedView *ruV = [[JKRecyceUntiedView alloc] initWithFrame:self.view.frame];
        [ruV alertViewInView:self.view];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.recyceType == JKRecyceWait) {
        return 3;
    } else if (self.recyceType == JKRecyceIng) {
        return 5;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row == 1) {
        return 165;
    } else if (indexPath.row == 2) {
        return 210;
    } else if (indexPath.row == 3) {
        return 551;
    } else {
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID = @"JKTaskTopCell";
        JKTaskTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKTaskTopCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKRecyceOrderCell";
        JKRecyceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.recyceType = self.recyceType;
//        [cell createUI];
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKRecyceDeviceCell";
        JKRecyceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceDeviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.recyceType = self.recyceType;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 3) {
        static NSString *ID = @"JKRecyceResultCell";
        JKRecyceResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.recyceType = self.recyceType;
        return cell;
    } else {
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = kBgColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kBgColor;
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(5);
            make.left.right.bottom.equalTo(cell);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"确认回收" forState:UIControlStateNormal];
        [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        orderBtn.titleLabel.font = JKFont(15);
        orderBtn.layer.cornerRadius = 4;
        orderBtn.layer.masksToBounds = YES;
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        return cell;
    }
}


@end
