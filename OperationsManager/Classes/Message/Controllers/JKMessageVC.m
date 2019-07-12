//
//  JKMessageVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMessageVC.h"
#import "JKMessgaCell.h"
#import "JKMessageModel.h"
#import "JKTaskMessageVC.h"
#import "JKSystemMessageVC.h"
#import "JKWarningMessageVC.h"

@interface JKMessageVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKMessageVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kLineColor;
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
    
    self.view.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dropDownRefresh];
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- 刷新新数据
- (void)refreshNewData {
    [self.tableView.mj_header endRefreshing];
    [self getMyTaskMessageList];
}

#pragma mark -- 查询消息列表
- (void)getMyTaskMessageList {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/messageList",kUrl_Base, loginId];

    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if (responseObject[@"success"]) {
            [self.dataSource removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKMessageModel *model = [JKMessageModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:model];
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {

    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"JKMessgaCell";
    JKMessgaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JKMessgaCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKMessageModel *model = self.dataSource[indexPath.row];
    [cell messgeInfoWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKMessageModel *model = self.dataSource[indexPath.row];
    if ([model.messageType isEqualToString:@"install"]) {
        JKTaskMessageVC *tmVC = [[JKTaskMessageVC alloc] init];
        tmVC.title = @"设备安装";
        tmVC.messageType = @"install";
        [self.navigationController pushViewController:tmVC animated:YES];
    } else if ([model.messageType isEqualToString:@"repair"]) {
        JKTaskMessageVC *tmVC = [[JKTaskMessageVC alloc] init];
        tmVC.title = @"故障报修";
        tmVC.messageType = @"repair";
        [self.navigationController pushViewController:tmVC animated:YES];
    } else if ([model.messageType isEqualToString:@"maintain"]) {
        JKTaskMessageVC *tmVC = [[JKTaskMessageVC alloc] init];
        tmVC.title = @"定期维护";
        tmVC.messageType = @"maintain";
        [self.navigationController pushViewController:tmVC animated:YES];
    } else if ([model.messageType isEqualToString:@"recycling"]) {
        JKTaskMessageVC *tmVC = [[JKTaskMessageVC alloc] init];
        tmVC.title = @"设备回收";
        tmVC.messageType = @"recycling";
        [self.navigationController pushViewController:tmVC animated:YES];
    } else if ([model.messageType isEqualToString:@"sys"]) {
        JKSystemMessageVC *smVC = [[JKSystemMessageVC alloc] init];
        smVC.messageType = @"sys";
        smVC.title = @"系统消息";
        [self.navigationController pushViewController:smVC animated:YES];
    } else if ([model.messageType isEqualToString:@"warning"]) {
        JKWarningMessageVC *wmVC = [[JKWarningMessageVC alloc] init];
        wmVC.messageType = @"warning";
        wmVC.title = @"报警消息";
        [self.navigationController pushViewController:wmVC animated:YES];
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
