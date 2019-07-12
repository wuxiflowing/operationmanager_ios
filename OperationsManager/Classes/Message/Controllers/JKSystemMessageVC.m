//
//  JKSystemMessageVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKSystemMessageVC.h"
#import "JKSystemMessageCell.h"
#import "JKMessageInfoVC.h"
#import "JKTaskMessageModel.h"

@interface JKSystemMessageVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JKSystemMessageVC

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
    
    [self setSystemIsRead];
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

#pragma mark -- 系统消息去除小红点
- (void)setSystemIsRead {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/sys/isRead",kUrl_Base, loginId];
    
    [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
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
                [self.dataSource addObject:model];
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    JKSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[JKSystemMessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JKTaskMessageModel *model = self.dataSource[indexPath.row];
    [cell taskMessgeWithModel:model];
    return cell;
}

@end
