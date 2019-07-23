//
//  JKEquipmentVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentVC.h"
#import "JKEquipmentInfoVC.h"
#import "JKNewEquipmentInfoVC.h"
#import "JKPondModel.h"
#import "JKFarmerEquipmentMainCell.h"
@interface JKEquipmentVC () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, JKFarmerEquipmentMainCellDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *rowNumberArr;
@property (nonatomic, strong) NSMutableArray *sectionTitileArr;
@end

@implementation JKEquipmentVC

- (NSMutableArray *)rowNumberArr {
    if (!_rowNumberArr) {
        _rowNumberArr = [[NSMutableArray alloc] init];
    }
    return _rowNumberArr;
}

- (NSMutableArray *)sectionTitileArr {
    if (!_sectionTitileArr) {
        _sectionTitileArr = [[NSMutableArray alloc] init];
    }
    return _sectionTitileArr;
}



- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"按照养殖户、鱼塘、设备ID搜索";
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
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

    [self createSearchBarUI];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight+10);
    }];
    
    [self dropDownRefresh];
    [self dropUpRefresh];
}

#pragma mark -- 下拉刷新
- (void)dropDownRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self getFishRawData:0];
        [self.tableView.mj_header endRefreshing];
        self->_page = 0;
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark -- 上拉刷新
- (void)dropUpRefresh {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->_page += 1;
        [self getFishRawData:self->_page];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- 设备状态列表
- (void)getFishRawData:(NSInteger)page {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/maintainKeeperID/pondData/newDevDetail?page=%ld",kUrl_Base, loginId,page];

    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {

            if (page == 0) {
                [self.sectionTitileArr removeAllObjects];
                [self.rowNumberArr removeAllObjects];
            }

            if ([responseObject[@"total"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }

            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.area = dict[@"area"];//
                pModel.fishVariety = dict[@"fishVariety"];//
                pModel.name = dict[@"name"];//
                pModel.pondAddress = dict[@"pondAddress"];//
                pModel.pondId = dict[@"pondId"];//
                pModel.putInDate = dict[@"putInDate"];//
                if ([[NSString stringWithFormat:@"%@",dict[@"reckonSaleDate"]] isEqualToString:@"<null>"]) {
                    pModel.reckonSaleDate = @"";
                } else {
                    pModel.reckonSaleDate = dict[@"reckonSaleDate"];//
                }
                pModel.region = dict[@"region"];//
                pModel.childDeviceList = dict[@"childDeviceList"];
                
                
                
                if ([dict[@"childDeviceList"] count] != 0) {
                    [self.sectionTitileArr addObject:pModel];
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dic in dict[@"childDeviceList"]) {
                        JKPondChildDeviceModel *pcdModel = [[JKPondChildDeviceModel alloc] init];
                        pcdModel.alarmType = dic[@"alarmType"];
                        pcdModel.alertlineTwo = dic[@"alertlineTwo"];
                        pcdModel.automatic = dic[@"automatic"];
                        pcdModel.dissolvedOxygen = [JKSafeNull(dic[@"oxy"]) floatValue];
                        pcdModel.temperature = [JKSafeNull(dic[@"temp"]) floatValue];
                        pcdModel.ph = [JKSafeNull(dic[@"ph"]) floatValue];
                        pcdModel.enabled = dic[@"enabled"];
                        pcdModel.deviceId = dic[@"id"];
                        pcdModel.ident = dic[@"identifier"];
                        pcdModel.name = dic[@"name"];
                        pcdModel.oxyLimitDownOne = dic[@"oxyLimitDownOne"];
                        pcdModel.oxyLimitUp = dic[@"oxyLimitUp"];
                        pcdModel.scheduled = dic[@"scheduled"];
                        pcdModel.type = JKSafeNull(dic[@"type"]);
                        pcdModel.workStatus = JKSafeNull(dic[@"workStatus"]);
                        NSArray *aeratorControls = dic[@"deviceControlInfoBeanList"];
                        if (aeratorControls != nil && ![aeratorControls isKindOfClass:[NSNull class]] && aeratorControls.count != 0) {
                            pcdModel.aeratorControlOne = aeratorControls[0][@"open"];
                            pcdModel.aeratorControlTwo = aeratorControls[1][@"open"];
                            pcdModel.aeratorControlTree = aeratorControls[2][@"open"];
                            pcdModel.aeratorControlFour = aeratorControls[3][@"open"];
                            pcdModel.statusControlOne = aeratorControls[0][@"auto"];
                            pcdModel.statusControlTwo = aeratorControls[1][@"auto"];
                            pcdModel.statusControlTree = aeratorControls[2][@"auto"];
                            pcdModel.statusControlFour = aeratorControls[3][@"auto"];
                        }
                        [arr addObject:pcdModel];
                    }
                    [self.rowNumberArr addObject:arr];
                }
                
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 搜索设备
- (void)searchDevtailInfo:(NSInteger)page {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/maintainKeeperID/pondData/newDevDetail/%@?page=%ld",kUrl_Base, loginId, self.searchBar.text,page];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            if (page == 0) {
                [self.sectionTitileArr removeAllObjects];
                [self.rowNumberArr removeAllObjects];
            }
            
            if ([responseObject[@"total"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.area = dict[@"area"];//
                pModel.fishVariety = dict[@"fishVariety"];//
                pModel.name = dict[@"name"];//
                pModel.pondAddress = dict[@"pondAddress"];//
                pModel.pondId = dict[@"pondId"];//
                pModel.putInDate = dict[@"putInDate"];//
                if ([[NSString stringWithFormat:@"%@",dict[@"reckonSaleDate"]] isEqualToString:@"<null>"]) {
                    pModel.reckonSaleDate = @"";
                } else {
                    pModel.reckonSaleDate = dict[@"reckonSaleDate"];//
                }
                pModel.region = dict[@"region"];//
                pModel.childDeviceList = dict[@"childDeviceList"];
                
                
                if ([dict[@"childDeviceList"] count] != 0) {
                    [self.sectionTitileArr addObject:pModel];
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dic in dict[@"childDeviceList"]) {
                        JKPondChildDeviceModel *pcdModel = [[JKPondChildDeviceModel alloc] init];
                        pcdModel.alarmType = dic[@"alarmType"];
                        pcdModel.alertlineTwo = dic[@"alertlineTwo"];
                        pcdModel.automatic = dic[@"automatic"];
                        pcdModel.enabled = dic[@"enabled"];
                        pcdModel.deviceId = dic[@"id"];
                        pcdModel.ident = dic[@"identifier"];
                        pcdModel.name = dic[@"name"];
                        pcdModel.oxyLimitDownOne = dic[@"oxyLimitDownOne"];
                        pcdModel.oxyLimitUp = dic[@"oxyLimitUp"];
                        pcdModel.scheduled = dic[@"scheduled"];
                        pcdModel.dissolvedOxygen = [JKSafeNull(dic[@"oxy"]) floatValue];
                        pcdModel.temperature = [JKSafeNull(dic[@"temp"]) floatValue];
                        pcdModel.ph = [JKSafeNull(dic[@"ph"]) floatValue];
                        pcdModel.type = JKSafeNull(dic[@"type"]);
                        pcdModel.workStatus = JKSafeNull(dic[@"workStatus"]);
                        NSArray *aeratorControls = dic[@"deviceControlInfoBeanList"];
                        if (aeratorControls != nil && ![aeratorControls isKindOfClass:[NSNull class]] && aeratorControls.count != 0) {
                            pcdModel.aeratorControlOne = aeratorControls[0][@"open"];
                            pcdModel.aeratorControlTwo = aeratorControls[1][@"open"];
                            pcdModel.aeratorControlTree = aeratorControls[2][@"open"];
                            pcdModel.aeratorControlFour = aeratorControls[3][@"open"];
                            pcdModel.statusControlOne = aeratorControls[0][@"auto"];
                            pcdModel.statusControlTwo = aeratorControls[1][@"auto"];
                            pcdModel.statusControlTree = aeratorControls[2][@"auto"];
                            pcdModel.statusControlFour = aeratorControls[3][@"auto"];
                        }
                        [arr addObject:pcdModel];
                    }
                    [self.rowNumberArr addObject:arr];
                }
                
            }
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 搜索栏UI
- (void)createSearchBarUI {
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    for (UIView *view in self.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")]&&view.subviews.count>0) {
            view.backgroundColor = kBgColor;
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

#pragma mark -- JKEquipmentCellDelegate
- (void)equipmentInfoClick:(NSString *)deviceId {
    JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
    eiVC.tskID = deviceId;
    [self.navigationController pushViewController:eiVC animated:YES];
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self searchDevtailInfo:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self getFishRawData:0];
        [self.tableView reloadData];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitileArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rowNumberArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ([self.rowNumberArr[indexPath.section] count] - 1) ) {
        return 195;
    } else {
        return 185;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"JKFarmerEquipmentMainCell";
    JKFarmerEquipmentMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JKFarmerEquipmentMainCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBgColor;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (self.rowNumberArr.count != 0) {
        if (indexPath.row <= [self.rowNumberArr[indexPath.section] count]) {
            JKPondModel *pModel = self.sectionTitileArr[indexPath.section];
            JKPondChildDeviceModel *model = self.rowNumberArr[indexPath.section][indexPath.row];
            [cell configCellWithModel:model withPondModel:pModel];
        }
    }
    cell.delegate = self;
    return cell;
}

#pragma mark -- 设备详情
- (void)pushDeviceInfoVC:(JKPondChildDeviceModel *)dModel {
    if ([dModel.type isEqualToString:@"KD326"]) {
        JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
        eiVC.tskID = dModel.ident;
        [self.navigationController pushViewController:eiVC animated:YES];
    }
    
    if ([dModel.type isEqualToString:@"QY601"]) {
        JKNewEquipmentInfoVC *eiVC = [[JKNewEquipmentInfoVC alloc] init];
        eiVC.tskID = dModel.ident;
        [self.navigationController pushViewController:eiVC animated:YES];
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}



@end
