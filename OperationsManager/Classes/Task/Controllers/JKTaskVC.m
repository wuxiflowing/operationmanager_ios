//
//  JKTaskVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKTaskVC.h"
#import "SDCycleScrollView.h"
#import "JKCommonTaskCell.h"
#import "JKScanVC.h"
#import "JKEquipmentInfoVC.h"
#import "JKInstallationVC.h"
#import "JKMaintainVC.h"
#import "JKRepairVC.h"
#import "JKRecyceVC.h"

@interface JKTaskVC () <UITableViewDelegate, UITableViewDataSource, JKCommonTaskCellDelegate, JKScanVCDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKTaskVC
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[SDCycleScrollView alloc] init];
        _bannerView.autoScrollTimeInterval = 3;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    }
    return _bannerView;
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
    
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT / 4);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBanner];
    [self dropDownRefresh];
}

#pragma mark -- 获取Banner图
- (void)getBanner {
    NSString *urlStr = [NSString stringWithFormat:@"%@",kUrl_Banner];
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            self.bannerView.localizationImageNamesGroup = responseObject[@"data"];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
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
    [self getTaskList];
}

#pragma mark -- 获取任务数量
- (void)getTaskList {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/taskList",kUrl_Base,loginId];

    NSArray *arr = @[@"", @"", @"", @"", @""];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:arr];

    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if (responseObject[@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                if ([dict[@"queryType"] isEqualToString:@"install"]) {
                    [self.dataSource removeObjectAtIndex:0];
                    [self.dataSource insertObject:dict[@"total"] atIndex:0];
                } else if ([dict[@"queryType"] isEqualToString:@"maintain"]) {
                    [self.dataSource removeObjectAtIndex:1];
                    [self.dataSource insertObject:dict[@"total"] atIndex:1];
                } else if ([dict[@"queryType"] isEqualToString:@"repair"]) {
                    [self.dataSource removeObjectAtIndex:2];
                    [self.dataSource insertObject:dict[@"total"] atIndex:2];
                } else if ([dict[@"queryType"] isEqualToString:@"subRecycling"]) {
                    [self.dataSource removeObjectAtIndex:3];
                    [self.dataSource insertObject:dict[@"total"] atIndex:3];
                }
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)commonTaskBtnsClick:(UIButton *)btn {
    if (btn.tag == 0) {
        JKInstallationVC *iVC = [[JKInstallationVC alloc] init];
        [self.navigationController pushViewController:iVC animated:YES];
    } else if (btn.tag == 1) {
        JKMaintainVC *mVC = [[JKMaintainVC alloc] init];
        [self.navigationController pushViewController:mVC animated:YES];
    } else if (btn.tag == 2) {
        JKRepairVC *rVC = [[JKRepairVC alloc] init];
        [self.navigationController pushViewController:rVC animated:YES];
    } else if (btn.tag == 3) {
        JKRecyceVC *reVC = [[JKRecyceVC alloc] init];
        [self.navigationController pushViewController:reVC animated:YES];
    } else if (btn.tag == 4) {
        JKScanVC *sVC = [[JKScanVC alloc] init];
        sVC.delegate = self;
        [self.navigationController pushViewController:sVC animated:YES];
    }
}

#pragma mark -- 扫描进入设备详情页面
- (void)showDeviceId:(NSString *)deviceId {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
        eiVC.tskID = deviceId;
        [self.navigationController pushViewController:eiVC animated:YES];
    });
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALE_SIZE(30 + SCREEN_WIDTH / 4 * 3) + 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"JKCommonTaskCell";
    JKCommonTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[JKCommonTaskCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [cell createUI:self.dataSource];
    cell.delegate = self;
    return cell;
}

@end
