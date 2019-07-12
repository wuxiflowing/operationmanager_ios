//
//  JKGeoCodeSearchVC.m
//  BusinessManager
//
//  Created by  on 2018/9/12.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKGeoCodeSearchVC.h"
#import "JKInstallationAddrModel.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface JKGeoCodeSearchVC () < UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKDistrictSearchDelegate, UISearchBarDelegate>
@property(nonatomic, strong) BMKLocationService *locService;
@property(nonatomic, strong) BMKUserLocation *userLocation;
@property(nonatomic, strong) BMKMapView *mapView;
@property(nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@property(nonatomic, strong) UIImageView *loactionView;
@property(nonatomic, strong) UIButton *poiBackBtn;
@property(nonatomic, assign) CLLocationCoordinate2D selectedCoordinate;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *chooseAddrInfo;
@end

@implementation JKGeoCodeSearchVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH *0.8, 30);
        _searchBar.placeholder = @"输入地址";
        _searchBar.backgroundColor = kWhiteColor;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 300)];
        _mapView.zoomLevel = 18; //地图等级，数字越大越清晰
        _mapView.mapType = BMKMapTypeSatellite;
        _mapView.minZoomLevel = 9;
        _mapView.maxZoomLevel = 20;
    }
    return _mapView;
}

-(UIImageView *)loactionView{
    if (!_loactionView) {
        _loactionView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_center_point"]];
        _loactionView.center = CGPointMake(self.mapView.width/2, self.mapView.height/2);
    }
    return _loactionView;
}

-(UIButton *)poiBackBtn{
    if (!_poiBackBtn) {
        _poiBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_poiBackBtn setImage:[UIImage imageNamed:@"ic_dingwei"] forState:UIControlStateNormal];
        [_poiBackBtn addTarget:self action:@selector(poiBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _poiBackBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"安装地址";

    [self createMapView];
    [self createNavigationUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.mapView viewWillAppear];
    
    self.mapView.delegate = self;
    self.locService.delegate = self;
    self.geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = NO;//显示定位图层
    
    [self.locService startUserLocationService];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    [self.locService stopUserLocationService];
    self.geocodesearch.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
}

- (void)createMapView {
    self.locService = [[BMKLocationService alloc] init];
    self.geocodesearch = [[BMKGeoCodeSearch alloc] init];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.mapView addSubview:self.loactionView];
    [self.mapView addSubview:self.poiBackBtn];
    [self.poiBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mapView).offset(-15);
        make.left.equalTo(self.mapView).offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.frame = CGRectMake(SCREEN_WIDTH *0.1, 20, SCREEN_WIDTH *0.8, 30);
    searchView.backgroundColor = kWhiteColor;
    searchView.layer.cornerRadius = 4;
    searchView.layer.masksToBounds = YES;
    [searchView addSubview:self.searchBar];
    //去掉自带的背景边框
    for (UIView *view in self.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [self.mapView addSubview:searchView];
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchAddressInfo:searchBar.text];
    [self.searchBar resignFirstResponder];
}

#pragma mark -- 检索行政区边界数据
- (void)searchAddressInfo:(NSString *)text {
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.address = text;
    BOOL flag = [self.geocodesearch geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.mapView setCenterCoordinate:result.location];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark -- 导航栏
- (void)createNavigationUI {    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    submitBtn.titleLabel.font = JKFont(16);
    [submitBtn sizeToFit];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtomItem;
}

- (void)poiBackBtnClick:(UIButton *)btn {
    [self.mapView setCenterCoordinate:self.userLocation.location.coordinate];
}

#pragma mark -- 返回安装地址
- (void)submitBtnClick:(UIButton *)btn {
    if (self.chooseAddrInfo == nil) {
        [YJProgressHUD showMessage:@"请选择安装地址" inView:self.view];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(chooseAdddrInfo:)]) {
        [_delegate chooseAdddrInfo:self.chooseAddrInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView updateLocationData:userLocation];
    
    self.userLocation = userLocation;
    
    [self.mapView setCenterCoordinate:userLocation.location.coordinate];
    
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [self.geocodesearch reverseGeoCode:option];
    if (flag) {
        
    }
    //更新位置之后必须停止定位，
    [self.locService stopUserLocationService];
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"地图拖动");
    [UIView animateWithDuration:0.30 animations:^{
        self.loactionView.centerY -=8;
    } completion:^(BOOL finished) {
        self.loactionView.centerY +=8;
    }];
    
    CGPoint touchPoint = self.mapView.center;
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    self.mapView.showsUserLocation = NO;//显示定位图层
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    
    //选择的上传地址
    self.selectedCoordinate = touchMapCoordinate;
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = touchMapCoordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:option];
    if (flag) {
        
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    [self.dataSource removeAllObjects];
    for (BMKPoiInfo *model in result.poiList) {
        JKInstallationAddrModel *iaModel = [[JKInstallationAddrModel alloc] init];
        iaModel.addrStr = model.address;
        iaModel.ptLat = model.pt.latitude;
        iaModel.ptLng = model.pt.longitude;
        iaModel.isSelected = NO;
        [self.dataSource addObject:iaModel];
    }
    [self.tableView reloadData];
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    JKInstallationAddrModel *model = self.dataSource[indexPath.row];
    UIImageView *imgV = [[UIImageView alloc] init];
    if (model.isSelected) {
        imgV.image = [UIImage imageNamed:@"ic_work_choose_on"];
    } else {
        imgV.image = [UIImage imageNamed:@"ic_work_choose_off"];
    }
    [cell.contentView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    self.imgV = imgV;

    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = model.addrStr;
    titleLb.textColor = RGBHex(0x333333);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(16);
    [cell.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cell);
        make.right.equalTo(cell).offset(-15);
        make.left.equalTo(imgV.mas_right).offset(10);
    }];
    self.titleLb = titleLb;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        JKInstallationAddrModel *model = self.dataSource[i];
        if (i == indexPath.row) {
            model.isSelected = YES;
            self.chooseAddrInfo = [NSString stringWithFormat:@"%@,%f,%f",model.addrStr,model.ptLat,model.ptLng];
//            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.ptLat, model.ptLng);
//            [self.mapView setCenterCoordinate:coordinate];
        } else {
            model.isSelected = NO;
        }
    }
    
    [self.tableView reloadData];
}

@end
