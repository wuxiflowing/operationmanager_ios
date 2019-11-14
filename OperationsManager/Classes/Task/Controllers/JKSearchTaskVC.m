//
//  JKSearchTaskVC.m
//  OperationsManager
//
//  Created by    on 2018/11/19.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKSearchTaskVC.h"
#import "JKTaskModel.h"
#import "JKInstallationCell.h"
#import "JKInstallWaitInfoVC.h"
#import "JKInstallIngInfoVC.h"
#import "JKInstalledInfoVC.h"
#import "JKMaintainCell.h"
#import "JKMaintainWaitInfoVC.h"
#import "JKMaintainIngInfoVC.h"
#import "JKMaintainedInfoVC.h"
#import "JKRepairCell.h"
#import "JKRepaireWaitInfoVC.h"
#import "JKRepairingInfoVC.h"
#import "JKRepairedInfoVC.h"
#import "JKRecyceCell.h"
#import "JKRecyceWaitInfoVC.h"
#import "JKRecycingInfoVC.h"
#import "JKRecycedInfoVC.h"

@interface JKSearchTaskVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, JKInstallationCellDelegate, JKMaintainCellDelegate, JKRepairCellDelegate, JKRecyceCellDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKSearchTaskVC

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入任务关键字";
    }
    return _searchBar;
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    for (UIView *view in self.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")]&&view.subviews.count>0) {
            view.backgroundColor = kBgColor;
            if (@available(ios 13.0,*)) {
                [view.subviews objectAtIndex:0].hidden = YES;
            }else{
                [[view.subviews objectAtIndex:0] removeFromSuperview];
            }
            break;
        }
    }

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    if (self.dataSource.count == 0) {
        [self createEmptyImgV];
    } else {
        [self.imgV removeFromSuperview];
        [self.titleLb removeFromSuperview];
    }
    
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
        [self getTaskList:0];
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
        [self getTaskList:_page];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getTaskList:(NSInteger)page {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/queryTask/%@/list/%@/%@/%@?page=%ld",kUrl_Base, [JKUserDefaults objectForKey:@"loginid"], self.queryType, self.type, self.searchBar.text,(long)page];
    
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
                if ([self.queryType isEqualToString:@"install"]) {
                    model.farmerName = dict[@"farmerName"];
                    model.farmerPhone = dict[@"farmerPhone"];
                    model.fishPondCount = dict[@"fishPondCount"];
                    model.matnerMembName = dict[@"matnerMembName"];
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
                } else if ([self.queryType isEqualToString:@"maintain"]) {
                    model.eqpNo = dict[@"eqpNo"];
                    model.matnerMembName = dict[@"matnerMembName"];
                    model.pondsName = dict[@"pondsName"];
                    model.farmerPhone = dict[@"farmerPhone"];
                    model.farmerName = dict[@"farmerName"];
                    model.pondAddr = dict[@"pondAddr"];
                    model.repairEqpKind = dict[@"repairEqpKind"];
                    model.tskID = dict[@"tskID"];
                    model.tskType = dict[@"tskType"];
                    model.calOT = dict[@"calOT"];
                    model.calDT = dict[@"calDT"];
                    model.calCT = dict[@"calCT"];
                    [self.dataSource addObject:model];
                } else if ([self.queryType isEqualToString:@"repair"]) {
                    model.farmerName = dict[@"farmerName"];
                    model.farmerPhone = dict[@"farmerPhone"];
                    model.formNo = dict[@"formNo"];
                    model.maintenDetail = dict[@"maintenDetail"];
                    model.matnerMembName = dict[@"matnerMembName"];
                    model.pondAddr = dict[@"pondAddr"];
                    model.pondPhone = dict[@"pondPhone"];
                    model.pondsName = dict[@"pondsName"];
                    model.repairEqpKind = dict[@"repairEqpKind"];
                    model.resOth = dict[@"resOth"];
                    model.tskID = dict[@"tskID"];
                    model.tskType = dict[@"tskType"];
                    model.calOT = dict[@"calOT"];
                    model.calDT = dict[@"calDT"];
                    model.calCT = dict[@"calCT"];
                    [self.dataSource addObject:model];
                } else if ([self.queryType isEqualToString:@"subRecycling"]) {
                    model.farmerName = dict[@"farmerName"];
                    model.farmerPhone = dict[@"farmerPhone"];
                    model.matnerMembName = dict[@"matnerMembName"];
                    model.pondAddr = dict[@"pondAddr"];
                    model.pondsName = dict[@"pondsName"];
                    model.tskID = dict[@"tskID"];
                    model.tskType = dict[@"tskType"];
                    model.deviceID = dict[@"deviceID"];
                    model.calOT = dict[@"calOT"];
                    model.calDT = dict[@"calDT"];
                    model.calCT = dict[@"calCT"];
                    [self.dataSource addObject:model];
                }
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

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self dropDownRefresh];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.dataSource removeAllObjects];
        if (self.dataSource.count == 0) {
            [self createEmptyImgV];
        } else {
            [self.imgV removeFromSuperview];
            [self.titleLb removeFromSuperview];
        }
        [self.tableView reloadData];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.queryType isEqualToString:@"repair"]) {
        return 280;
    } else {
        return 255;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.queryType isEqualToString:@"install"]) {
        static NSString *ID = @"JKInstallationCell";
        JKInstallationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKInstallationCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([self.type isEqualToString:@"prepare"]) {
            cell.installType = JKInstallationWait;
        } else if ([self.type isEqualToString:@"ing"]) {
            cell.installType = JKInstallationIng;
        } else {
            cell.installType = JKInstallationEd;
        }
        JKTaskModel *model = self.dataSource[indexPath.row];
        [cell createUI:model];
        cell.delegate = self;
        return cell;
    } else if ([self.queryType isEqualToString:@"maintain"]) {
        static NSString *ID = @"JKMaintainCell";
        JKMaintainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKMaintainCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([self.type isEqualToString:@"prepare"]) {
            cell.maintainType = JKMaintainWait;
        } else if ([self.type isEqualToString:@"ing"]) {
            cell.maintainType = JKMaintainIng;
        } else {
            cell.maintainType = JKMaintainEd;
        }
        JKTaskModel *model = self.dataSource[indexPath.row];
        cell.delegate = self;
        [cell createUI:model];
        return cell;
    } else if ([self.queryType isEqualToString:@"repair"]) {
        static NSString *ID = @"JKRepairCell";
        JKRepairCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRepairCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([self.type isEqualToString:@"prepare"]) {
            cell.repaireType = JKRepaireWait;
        } else if ([self.type isEqualToString:@"ing"]) {
            cell.repaireType = JKRepaireIng;
        } else {
            cell.repaireType = JKRepaireEd;
        }
        JKTaskModel *model = self.dataSource[indexPath.row];
        [cell createUI:model];
        cell.delegate = self;
        return cell;
    } else {
        static NSString *ID = @"JKRecyceCell";
        JKRecyceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([self.type isEqualToString:@"prepare"]) {
            cell.recyceType = JKRecyceWait;
        } else if ([self.type isEqualToString:@"ing"]) {
            cell.recyceType = JKRecyceIng;
        } else {
            cell.recyceType = JKRecyceEd;
        }
        JKTaskModel *model = self.dataSource[indexPath.row];
        [cell createUI:model];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.queryType isEqualToString:@"install"]) {
        JKTaskModel *model = self.dataSource[indexPath.row];
        if ([self.type isEqualToString:@"prepare"]) {
            JKInstallWaitInfoVC *iiVC = [[JKInstallWaitInfoVC alloc] init];
            iiVC.installType = JKInstallationWait;
            iiVC.tskID = model.tskID;
            [self.navigationController pushViewController:iiVC animated:YES];
        } else if ([self.type isEqualToString:@"ing"]) {
            JKTaskModel *model = self.dataSource[indexPath.row];
            JKInstallIngInfoVC *iiVC = [[JKInstallIngInfoVC alloc] init];
            iiVC.installType = JKInstallationIng;
            iiVC.tskID = model.tskID;
            [self.navigationController pushViewController:iiVC animated:YES];
        } else {
            JKTaskModel *model = self.dataSource[indexPath.row];
            JKInstalledInfoVC *iiVC = [[JKInstalledInfoVC alloc] init];
            iiVC.installType = JKInstallationEd;
            iiVC.tskID = model.tskID;
            [self.navigationController pushViewController:iiVC animated:YES];
        }
    } else if ([self.queryType isEqualToString:@"maintain"]) {
        JKTaskModel *model = self.dataSource[indexPath.row];
        if ([self.type isEqualToString:@"prepare"]) {
            JKMaintainWaitInfoVC *mwiVC = [[JKMaintainWaitInfoVC alloc] init];
            mwiVC.maintainType = JKMaintainWait;
            mwiVC.tskID = model.tskID;
            [self.navigationController pushViewController:mwiVC animated:YES];
        } else if ([self.type isEqualToString:@"ing"]) {
            JKMaintainIngInfoVC *miiVC = [[JKMaintainIngInfoVC alloc] init];
            miiVC.maintainType = JKMaintainIng;
            miiVC.tskID = model.tskID;
            [self.navigationController pushViewController:miiVC animated:YES];
        } else {
            JKMaintainedInfoVC *miiVC = [[JKMaintainedInfoVC alloc] init];
            miiVC.maintainType = JKMaintainEd;
            miiVC.tskID = model.tskID;
            [self.navigationController pushViewController:miiVC animated:YES];
        }
    } else if ([self.queryType isEqualToString:@"repair"]) {
        JKTaskModel *model = self.dataSource[indexPath.row];
        if ([self.type isEqualToString:@"prepare"]) {
            JKRepaireWaitInfoVC *riVC = [[JKRepaireWaitInfoVC alloc] init];
            riVC.repaireType = JKRepaireWait;
            riVC.tskID = model.tskID;
            [self.navigationController pushViewController:riVC animated:YES];
        } else if ([self.type isEqualToString:@"ing"]) {
            JKRepairingInfoVC *riVC = [[JKRepairingInfoVC alloc] init];
            riVC.repaireType = JKRepaireIng;
            riVC.tskID = model.tskID;
            [self.navigationController pushViewController:riVC animated:YES];
        } else {
            JKRepairedInfoVC *riVC = [[JKRepairedInfoVC alloc] init];
            riVC.repaireType = JKRepaireEd;
            riVC.tskID = model.tskID;
            [self.navigationController pushViewController:riVC animated:YES];
        }
    } else {
        JKTaskModel *model = self.dataSource[indexPath.row];
        if ([self.type isEqualToString:@"prepare"]) {
            JKRecyceWaitInfoVC *rwiVC = [[JKRecyceWaitInfoVC alloc] init];
            rwiVC.recyceType = JKRecyceWait;
            rwiVC.tskID = model.tskID;
            [self.navigationController pushViewController:rwiVC animated:YES];
        } else if ([self.type isEqualToString:@"ing"]) {
            JKRecycingInfoVC *riVC = [[JKRecycingInfoVC alloc] init];
            riVC.recyceType = JKRecyceIng;
            riVC.tskID = model.tskID;
            [self.navigationController pushViewController:riVC animated:YES];
        } else {
            JKRecycedInfoVC *riVC = [[JKRecycedInfoVC alloc] init];
            riVC.recyceType = JKRecyceEd;
            riVC.tskID = model.tskID;
            [self.navigationController pushViewController:riVC animated:YES];
        }
    }
}


@end
