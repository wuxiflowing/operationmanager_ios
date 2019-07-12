//
//  JKInstallingVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKInstallingVC.h"
#import "JKInstallationCell.h"
#import "JKInstallIngInfoVC.h"
#import "JKTaskModel.h"

@interface JKInstallingVC () <UITableViewDelegate, UITableViewDataSource, JKInstallationCellDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JKInstallingVC

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self dropDownRefresh];
    [self dropUpRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- 拨打电话
- (void)callFarmerPhone:(NSString *)phoneNumber {
    NSString *dialSring=[NSString stringWithFormat:@"tel://%@",phoneNumber];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialSring]];
    }
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self getInstallTaskList:0];
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
        [self getInstallTaskList:_page];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)getInstallTaskList:(NSInteger)page {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/list/%@/%@?page=%ld",kUrl_Base,[JKUserDefaults objectForKey:@"loginid"],@"install",@"ing",(long)page];
    
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
                JKTaskModel *model = [[JKTaskModel alloc] init];
                model.farmerName = dict[@"farmerName"];
                model.farmerPhone = dict[@"farmerPhone"];
                model.fishPondCount = dict[@"fishPondCount"];
                model.matnerMembName = dict[@"txtFarmerManager"];
                model.planFinishTime = dict[@"planFinishTime"];
                model.pondAddr = dict[@"pondAddr"];
                model.pondPhone = dict[@"pondPhone"];
                model.tskID = dict[@"tskID"];
                model.tskType = dict[@"tskType"];
                model.calOT = dict[@"calOT"];
                model.calDT = dict[@"calDT"];
                model.calCT = dict[@"calCT"];
                NSArray *arr = dict[@"contractDeviceList"];
                for (NSDictionary *dic in arr) {
                    model.contractDeviceNum = dic[@"contractDeviceNum"];
                }
                [self.dataSource addObject:model];
            }
        }
        if (self.dataSource.count == 0) {
            [self createEmptyImgV];
        } else {
            [self.imgV removeFromSuperview];
            [self.titleLb removeFromSuperview];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 255;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    JKInstallationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[JKInstallationCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.installType = JKInstallationIng;
    JKTaskModel *model = self.dataSource[indexPath.row];
    [cell createUI:model];
    cell.delegate = self;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JKTaskModel *model = self.dataSource[indexPath.row];
    JKInstallIngInfoVC *iiVC = [[JKInstallIngInfoVC alloc] init];
    iiVC.installType = JKInstallationIng;
    iiVC.tskID = model.tskID;
    [self.navigationController pushViewController:iiVC animated:YES];
}

@end
