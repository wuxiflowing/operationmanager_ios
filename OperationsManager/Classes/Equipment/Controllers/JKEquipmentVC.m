//
//  JKEquipmentVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentVC.h"
#import "JKEquipmentCell.h"
#import "JKEquipmentInfoVC.h"
#import "JKPondModel.h"

@interface JKEquipmentVC () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, JKEquipmentCellDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *rowNumberArr;
@property (nonatomic, strong) NSMutableArray *sectionTitileArr;
@property (nonatomic, strong) NSMutableArray *activelyArr;
@property (nonatomic, strong) NSMutableArray *boolArr;
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

- (NSMutableArray *)activelyArr {
    if (!_activelyArr) {
        _activelyArr = [[NSMutableArray alloc] init];
    }
    return _activelyArr;
}

- (NSMutableArray *)boolArr {
    if (!_boolArr) {
        _boolArr = [[NSMutableArray alloc] init];
    }
    return _boolArr;
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
        [self getFishRawData:_page];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- 设备状态列表
- (void)getFishRawData:(NSInteger)page {
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/maintainKeeperID/pondData/devDetail/true?page=%ld",kUrl_Base, loginId,page];

    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {

            if (page == 0) {
                [self.sectionTitileArr removeAllObjects];
                [self.rowNumberArr removeAllObjects];
                [self.boolArr removeAllObjects];
                [self.activelyArr removeAllObjects];
            }

            if ([responseObject[@"total"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }

            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.farmerId = dict[@"farmerId"];
                pModel.area = dict[@"area"];
                pModel.fishVariety = dict[@"fishVariety"];
                pModel.fryNumber = dict[@"fryNumber"];
                pModel.name = dict[@"name"];
                pModel.phoneNumber = dict[@"phoneNumber"];
                pModel.pondAddress = dict[@"pondAddress"];
                pModel.pondId = dict[@"pondId"];
                pModel.putInDate = dict[@"putInDate"];
                pModel.reckonSaleDate = dict[@"reckonSaleDate"];
                pModel.region = dict[@"region"];
                pModel.childDeviceList = dict[@"childDeviceList"];
                [self.sectionTitileArr addObject:pModel];

                NSMutableArray *arr = [[NSMutableArray alloc] init];
                NSMutableArray *activelyArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in dict[@"childDeviceList"]) {
                    JKPondChildDeviceModel *pcdModel = [[JKPondChildDeviceModel alloc] init];
                    pcdModel.alarmType = dic[@"alarmType"];
                    pcdModel.alertlineTwo = dic[@"alertlineTwo"];
                    pcdModel.automatic = dic[@"automatic"];
                    pcdModel.dissolvedOxygen = dic[@"dissolvedOxygen"];
                    pcdModel.enabled = dic[@"enabled"];
                    pcdModel.deviceIdentifier = dic[@"identifier"];
                    pcdModel.ident = dic[@"identifier"];
                    pcdModel.name = dic[@"name"];
                    pcdModel.oxyLimitDownOne = dic[@"oxyLimitDownOne"];
                    pcdModel.oxyLimitUp = dic[@"oxyLimitUp"];
                    pcdModel.ph = dic[@"ph"];
                    pcdModel.scheduled = dic[@"scheduled"];
                    pcdModel.temperature = dic[@"temperature"];
                    pcdModel.type = dic[@"type"];
                    pcdModel.workStatus = dic[@"workStatus"];
                    NSArray *aeratorControls = dic[@"aeratorControlList"];
                    if (aeratorControls != nil && ![aeratorControls isKindOfClass:[NSNull class]] && aeratorControls.count != 0) {
                        pcdModel.aeratorControlOne = aeratorControls[0][@"open"];
                        pcdModel.aeratorControlTwo = aeratorControls[1][@"open"];
                    }
                    [arr addObject:pcdModel];
                }
                [self.activelyArr addObject:activelyArr];
                [self.rowNumberArr addObject:arr];
                [self.boolArr addObject:@NO];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/maintainKeeperID/pondData/devDetail/true/%@?page=%ld",kUrl_Base, loginId, self.searchBar.text,page];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            if (page == 0) {
                [self.sectionTitileArr removeAllObjects];
                [self.rowNumberArr removeAllObjects];
                [self.boolArr removeAllObjects];
                [self.activelyArr removeAllObjects];
            }
            
            if ([responseObject[@"total"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.farmerId = dict[@"farmerId"];
                pModel.area = dict[@"area"];
                pModel.fishVariety = dict[@"fishVariety"];
                pModel.fryNumber = dict[@"fryNumber"];
                pModel.name = dict[@"name"];
                pModel.phoneNumber = dict[@"phoneNumber"];
                pModel.pondAddress = dict[@"pondAddress"];
                pModel.pondId = dict[@"pondId"];
                pModel.putInDate = dict[@"putInDate"];
                pModel.reckonSaleDate = dict[@"reckonSaleDate"];
                pModel.region = dict[@"region"];
                pModel.childDeviceList = dict[@"childDeviceList"];
                [self.sectionTitileArr addObject:pModel];
                
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                NSMutableArray *activelyArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in dict[@"childDeviceList"]) {
                    JKPondChildDeviceModel *pcdModel = [[JKPondChildDeviceModel alloc] init];
                    pcdModel.alarmType = dic[@"alarmType"];
                    pcdModel.alertlineTwo = dic[@"alertlineTwo"];
                    pcdModel.automatic = dic[@"automatic"];
                    pcdModel.dissolvedOxygen = dic[@"dissolvedOxygen"];
                    pcdModel.enabled = dic[@"enabled"];
                    pcdModel.deviceIdentifier = dic[@"identifier"];
                    pcdModel.ident = dic[@"identifier"];
                    pcdModel.name = dic[@"name"];
                    pcdModel.oxyLimitDownOne = dic[@"oxyLimitDownOne"];
                    pcdModel.oxyLimitUp = dic[@"oxyLimitUp"];
                    pcdModel.ph = dic[@"ph"];
                    pcdModel.scheduled = dic[@"scheduled"];
                    pcdModel.temperature = dic[@"temperature"];
                    pcdModel.type = dic[@"type"];
                    pcdModel.workStatus = dic[@"workStatus"];
                    NSArray *aeratorControls = dic[@"aeratorControlList"];
                    if (aeratorControls != nil && ![aeratorControls isKindOfClass:[NSNull class]] && aeratorControls.count != 0) {
                        pcdModel.aeratorControlOne = aeratorControls[0][@"open"];
                        pcdModel.aeratorControlTwo = aeratorControls[1][@"open"];
                    }
                    [arr addObject:pcdModel];
                }
                [self.activelyArr addObject:activelyArr];
                [self.rowNumberArr addObject:arr];
                [self.boolArr addObject:@NO];
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
    if ([self.boolArr[section] boolValue] == NO) {
        return 0;
    }else {
        return [self.rowNumberArr[section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ([self.rowNumberArr[indexPath.section] count] - 1) ) {
        return 266;
    } else {
        return 256;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //创建headerView
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 51);
    headerView.tag = 10 + section;
    headerView.backgroundColor = kWhiteColor;
    
    //分割线
    UILabel *horizontalLineLb = [[UILabel alloc] init];
    horizontalLineLb.backgroundColor = kBgColor;
    [headerView addSubview:horizontalLineLb];
    [horizontalLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.right.equalTo(headerView);
        make.height.mas_equalTo(1);
    }];
    
    // 默认组是没有删除组的
    JKPondModel *model = self.sectionTitileArr[section];
    //标题
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = model.name;
    titleLb.numberOfLines = 1;
    [headerView addSubview:titleLb];
    CGSize size = CGSizeMake(50,50); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: titleLb.font};
    CGSize labelsize = [titleLb.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.equalTo(headerView.mas_left).offset(15);
        if (labelsize.width > SCREEN_WIDTH / 2) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 50));
        } else {
            make.size.mas_equalTo(CGSizeMake(labelsize.width + 3, 50));
        }
    }];
    
    //箭头
    UIImageView *arrowImgV = [[UIImageView alloc] init];
    arrowImgV.image = [self.boolArr[section] boolValue] ? [UIImage imageNamed:@"ic_arrow_up"] : [UIImage imageNamed:@"ic_arrow_down"];
    [headerView addSubview:arrowImgV];
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 10));
    }];
    
    //添加轻扣手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [headerView addGestureRecognizer:tap];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier =@"JKEquipmentCell";
    JKEquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JKEquipmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.rowNumberArr.count != 0) {
        if (indexPath.row < [self.rowNumberArr[indexPath.section] count]) {
            JKPondChildDeviceModel *model = self.rowNumberArr[indexPath.section][indexPath.row];
            [cell configCellWithModel:model];
        }
    }
    cell.delegate = self;
    return cell;
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma mark -- UITapGestureRecognizer点击事件
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    //获取section
    NSInteger section = tap.view.tag - 10;
    //判断改变bool值
    if ([self.boolArr[section] boolValue] == YES) {
        [self.boolArr replaceObjectAtIndex:(section) withObject:@NO];
    }else {
        [self.boolArr replaceObjectAtIndex:(section) withObject:@YES];
    }
    //刷新某个section
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}


@end
