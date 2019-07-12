//
//  JKTaskMessageVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKTaskMessageVC.h"
#import "JKTaskMessageCell.h"
#import "JKTaskMessageModel.h"

#import "JKInstallWaitInfoVC.h"
#import "JKInstallIngInfoVC.h"
#import "JKInstalledInfoVC.h"
#import "JKRepaireWaitInfoVC.h"
#import "JKRepairingInfoVC.h"
#import "JKRepairedInfoVC.h"
#import "JKMaintainWaitInfoVC.h"
#import "JKMaintainIngInfoVC.h"
#import "JKMaintainedInfoVC.h"
#import "JKRecyceWaitInfoVC.h"
#import "JKRecycingInfoVC.h"
#import "JKRecycedInfoVC.h"

@interface JKTaskMessageVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JKTaskMessageVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kClearColor;
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
    
    _page = 0;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dropDownRefresh];
    [self dropUpRefresh];
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self getMyTaskMessageInfoList:0];
        [self.tableView.mj_header endRefreshing];
        _page = 0;
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- 上拉刷新
- (void)dropUpRefresh {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getMyTaskMessageInfoList:_page];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- 查询任务消息
- (void)getMyTaskMessageInfoList:(NSInteger)page{
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/taskMessageList?messageType=%@&page=%ld",kUrl_Base, loginId,self.messageType,(long)page];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            if (page == 0) {
                [self.dataSource removeAllObjects];
            }
            
            if ([responseObject[@"total"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKTaskMessageModel *model = [[JKTaskMessageModel alloc] init];
                model.createDate = dict[@"createDate"];
                model.isRead = dict[@"isRead"];
                model.keyword = dict[@"keyword"];
                model.memId = dict[@"memId"];
                model.messageType = dict[@"messageType"];
                model.msgContent = dict[@"msgContent"];
                model.msgId = dict[@"msgId"];
                model.receiverName = dict[@"receiverName"];
                model.taskId = dict[@"taskId"];
                model.taskStatus = dict[@"taskStatus"];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
//        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)isRead:(NSString *)msgId {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/isRead",kUrl_Base, msgId];
    
    [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)getTaskInfoList:(NSString *)tskID withMessageType:(NSString *)type {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,tskID];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if (responseObject[@"success"]) {
            NSString *taskState = responseObject[@"data"][@"taskState"];
            if ([type isEqualToString:@"install"]) {
                if ([taskState isEqualToString:@"ready"]) {
                    JKInstallWaitInfoVC *iwiVC = [[JKInstallWaitInfoVC alloc] init];
                    iwiVC.installType = JKInstallationWait;
                    iwiVC.tskID = tskID;
                    [self.navigationController pushViewController:iwiVC animated:YES];
                } else if ([taskState isEqualToString:@"suspended"]) {
                    JKInstallIngInfoVC *iiiVC = [[JKInstallIngInfoVC alloc] init];
                    iiiVC.installType = JKInstallationIng;
                    iiiVC.tskID = tskID;
                    [self.navigationController pushViewController:iiiVC animated:YES];
                } else if ([taskState isEqualToString:@"complete"]) {
                    JKInstalledInfoVC *iiVC = [[JKInstalledInfoVC alloc] init];
                    iiVC.installType = JKInstallationEd;
                    iiVC.tskID = tskID;
                    [self.navigationController pushViewController:iiVC animated:YES];
                }
            } else if ([type isEqualToString:@"repair"]) {
                if ([taskState isEqualToString:@"ready"]) {
                    JKRepaireWaitInfoVC *rwiVC = [[JKRepaireWaitInfoVC alloc] init];
                    rwiVC.repaireType = JKRepaireWait;
                    rwiVC.tskID = tskID;
                    [self.navigationController pushViewController:rwiVC animated:YES];
                } else if ([taskState isEqualToString:@"suspended"]) {
                    JKRepairingInfoVC *riVC = [[JKRepairingInfoVC alloc] init];
                    riVC.repaireType = JKRepaireIng;
                    riVC.tskID = tskID;
                    [self.navigationController pushViewController:riVC animated:YES];
                } else if ([taskState isEqualToString:@"complete"]) {
                    JKRepairedInfoVC *riVC = [[JKRepairedInfoVC alloc] init];
                    riVC.repaireType = JKRepaireEd;
                    riVC.tskID = tskID;
                    [self.navigationController pushViewController:riVC animated:YES];
                }
            } else if ([type isEqualToString:@"maintain"]) {
                if ([taskState isEqualToString:@"ready"]) {
                    JKMaintainWaitInfoVC *miVC = [[JKMaintainWaitInfoVC alloc] init];
                    miVC.maintainType = JKMaintainWait;
                    miVC.tskID = tskID;
                    [self.navigationController pushViewController:miVC animated:YES];
                } else if ([taskState isEqualToString:@"suspended"]) {
                    JKMaintainIngInfoVC *miVC = [[JKMaintainIngInfoVC alloc] init];
                    miVC.maintainType = JKMaintainIng;
                    miVC.tskID = tskID;
                    [self.navigationController pushViewController:miVC animated:YES];
                } else if ([taskState isEqualToString:@"complete"]) {
                    JKMaintainedInfoVC *miVC = [[JKMaintainedInfoVC alloc] init];
                    miVC.maintainType = JKMaintainEd;
                    miVC.tskID = tskID;
                    [self.navigationController pushViewController:miVC animated:YES];
                }
            } else if ([type isEqualToString:@"recycling"]) {
                if ([taskState isEqualToString:@"ready"]) {
                    JKRecyceWaitInfoVC *rwiVC = [[JKRecyceWaitInfoVC alloc] init];
                    rwiVC.recyceType = JKRecyceWait;
                    rwiVC.tskID = tskID;
                    [self.navigationController pushViewController:rwiVC animated:YES];
                } else if ([taskState isEqualToString:@"suspended"]) {
                    JKRecycingInfoVC *riVC = [[JKRecycingInfoVC alloc] init];
                    riVC.recyceType = JKRecyceIng;
                    riVC.tskID = tskID;
                    [self.navigationController pushViewController:riVC animated:YES];
                } else if ([taskState isEqualToString:@"complete"]) {
                    JKRecycedInfoVC *riVC = [[JKRecycedInfoVC alloc] init];
                    riVC.recyceType = JKRecyceEd;
                    riVC.tskID = tskID;
                    [self.navigationController pushViewController:riVC animated:YES];
                }
            }
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    JKTaskMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[JKTaskMessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKTaskMessageModel *model = self.dataSource[indexPath.row];
    [cell taskMessgeWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKTaskMessageModel *model = self.dataSource[indexPath.row];
    [self isRead:model.msgId];
    [self getTaskInfoList:model.taskId withMessageType:model.messageType];
}

@end
