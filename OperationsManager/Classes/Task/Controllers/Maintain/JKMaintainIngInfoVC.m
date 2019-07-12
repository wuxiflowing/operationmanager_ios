//
//  JKMaintainIngInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/10/18.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMaintainIngInfoVC.h"
#import "JKTaskTopCell.h"
#import "JKMaintainOrderCell.h"
#import "JKMaintainInfoModel.h"
#import "JKMaintainResultCell.h"
#import "CoreLocation/CoreLocation.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "JKMaintainVC.h"

@interface JKMaintainIngInfoVC () <UITableViewDelegate, UITableViewDataSource, JKTaskTopCellDelegate, JKMaintainResultCellDeleagte, CLLocationManagerDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, JKMaintainOrderCellDelegate>
{
    NSInteger _forCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *txtClockTime;
@property (nonatomic, strong) NSString *txtClockLatitude;
@property (nonatomic, strong) NSString *txtClockLongitude;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) JKMaintainResultCell *mrCell;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *contentBtnTitleArr;
@property (nonatomic, strong) BMKLocationService * locService;//定位
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;//地理编码类
@end

@implementation JKMaintainIngInfoVC

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

- (NSMutableArray *)contentBtnTitleArr {
    if (!_contentBtnTitleArr) {
        _contentBtnTitleArr = [[NSMutableArray alloc] init];
    }
    return _contentBtnTitleArr;
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"任务详情";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getMaintainTaskInfoList];
    [self getMaintainResultList];
    
//    _locService = [[BMKLocationService alloc] init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.locationManager = nil;
    _geoCodeSearch.delegate = nil;
    _locService.delegate = nil;
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

#pragma mark -- 任务详情
- (void)getMaintainTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKMaintainInfoModel *model = [[JKMaintainInfoModel alloc] init];
            model.txtFarmerName = responseObject[@"data"][@"txtFarmerName"];
            model.txtPondAddr = responseObject[@"data"][@"txtPondAddr"];
            model.txtFarmerAddr = responseObject[@"data"][@"txtFarmerAddr"];
            model.txtIMMembID = responseObject[@"data"][@"txtIMMembID"];
            model.txtHKID = responseObject[@"data"][@"txtHKID"];
            model.txtFormNo = responseObject[@"data"][@"txtFormNo"];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.txtFarmerPhone = responseObject[@"data"][@"txtFarmerPhone"];
            model.txtMatnerMembNo = responseObject[@"data"][@"txtMatnerMembNo"];
            model.txtEqpNo = responseObject[@"data"][@"txtEqpNo"];
            model.txtMatnerMembName = responseObject[@"data"][@"txtMatnerMembName"];
            model.txtPondsName = responseObject[@"data"][@"txtPondsName"];
            model.region = responseObject[@"data"][@"region"];
            model.latitude = responseObject[@"data"][@"latitude"];
            model.longitude = responseObject[@"data"][@"longitude"];
            model.picture = responseObject[@"data"][@"picture"];
            model.txtRepairEqpKind = responseObject[@"data"][@"txtRepairEqpKind"];
            model.txtHKName = responseObject[@"data"][@"txtHKName"];
            model.txtMonMembName = responseObject[@"data"][@"txtMonMembName"];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 跳转第三方地图
- (void)showOtherMap {
    JKMaintainInfoModel *model = self.dataSource[0];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *iosMapAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
        CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(coor.latitude,coor.longitude);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
        tolocation.name = @"目的地";
        [MKMapItem openMapsWithItems:@[currentLocation,tolocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }];
    [actionSheet addAction:iosMapAction];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        UIAlertAction *baiduMapAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
            NSString *baiduParameterFormat = @"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name:目的地&mode=driving&coord_type=gcj02&src=运维管家";
            NSString *urlString = [[NSString stringWithFormat:
                                    baiduParameterFormat,
                                    [NSString stringWithFormat:@"%f",coor.latitude],
                                    [NSString stringWithFormat:@"%f",coor.longitude]]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:baiduMapAction];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction *gaodeMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
            NSString *gaodeParameterFormat = @"iosamap://navi?sourceApplication= &backScheme= &lat=%@&lon=%@&dev=0&style=2";
            NSString *urlString = [[NSString stringWithFormat:
                                    gaodeParameterFormat,
                                    [NSString stringWithFormat:@"%f",coor.latitude],
                                    [NSString stringWithFormat:@"%f",coor.longitude]]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [actionSheet addAction:gaodeMapAction];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -- 结束维护
- (void)orderBtnClick:(UIButton *)btn {
    if (self.txtClockLatitude == nil) {
        [YJProgressHUD showMessage:@"请打卡" inView:self.view];
        return;
    }
    
    if (self.mrCell.imageArr.count == 0) {
        [self submitInfo];
    } else {
        [self getImgUrl];
    }
}

- (void)getImgUrl {
    [self.imgArr removeAllObjects];

    [self saveImage:self.mrCell.imageArr];
}

- (void)saveImage:(NSArray *)imgArr {
    [YJProgressHUD showProgressCircleNoValue:@"结束中..." inView:self.view];
    _forCount = 0;
    [self getImgArr:imgArr withIndex:_forCount];
}

- (void)getImgArr:(NSArray *)imgArr withIndex:(NSInteger)tag {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"maPic" forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%ld.jpg",(long)[JKToolKit getNowTimestamp]] forKey:@"imageName"];
    [params setObject:[JKToolKit imageToString:imgArr[tag]] forKey:@"imageData"];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/%@/uploadImage", kUrl_Base, loginId];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [self.imgArr addObject:responseObject[@"data"]];
        _forCount++;
        if (_forCount == self.mrCell.imageArr.count) {
            [self submitInfo];
        } else {
            [self getImgArr:imgArr withIndex:_forCount];
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)submitInfo  {
    JKMaintainInfoModel *model = self.dataSource[0];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
    [dict setObject:model.txtFarmerID forKey:@"farmerId"];
    NSString *tarMaintainCon = [self.mrCell.selectArr componentsJoinedByString:@","];
    [dict setObject:tarMaintainCon forKey:@"tarMaintainCon"];
    [dict setObject:self.mrCell.textV.text forKey:@"tarRemarks"];
    [dict setObject:self.txtClockLatitude forKey:@"txtClockLatitude"];
    [dict setObject:self.txtClockLongitude forKey:@"txtClockLongitude"];
    [dict setObject:self.txtClockTime forKey:@"txtClockTime"];
    if (self.imgArr.count == 0) {
        [dict setObject:@"" forKey:@"txtMaintainImgSrc"];
    } else {
        [dict setObject:self.imgArr forKey:@"txtMaintainImgSrc"];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:dict forKey:@"appData"];
    [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit", kUrl_Base,self.tskID];
    
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            [YJProgressHUD showMessage:@"提交成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for(UIViewController *controller in self.navigationController.viewControllers) {
                    if([controller isKindOfClass:[JKMaintainVC class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            });
        } else {
            [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 打卡
- (void)getLocationLatAndLngAndTime {
    //@@
//    _locService = [[BMKLocationService alloc] init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];
}

////定位代理经纬度回调
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    CLLocation *newLocation = locations[0];
//    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
//    self.txtClockLatitude = [NSString stringWithFormat:@"%f",newCoordinate.latitude];
//    self.txtClockLongitude = [NSString stringWithFormat:@"%f",newCoordinate.longitude];
//    self.txtClockTime = [self currentTimeStr];
//    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
//}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //    [JKNotificationCenter postNotification:[NSNotification notificationWithName:@"CurrentLatAndLngNotification" object:nil userInfo:@{@"lat":[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude], @"lng":[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude]}]];
    [_locService stopUserLocationService];

    self.txtClockLatitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.txtClockLongitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    self.txtClockTime = [self currentTimeStr];
}

- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

#pragma mark -- 获取维修内容多选项
- (void)getMaintainResultList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/formData/repairList/maintain",kUrl_Base];
    
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            for (NSString *reason in responseObject[@"data"]) {
                [self.contentBtnTitleArr addObject:[NSString stringWithFormat:@"  %@",reason]];
            }
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}


#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else if (indexPath.row == 1) {
        return 260;
    } else if (indexPath.row == 2) {
        if (self.contentBtnTitleArr.count == 0) {
            return 408;
        }
        return 48 + 48 + (self.contentBtnTitleArr.count / 2  + self.contentBtnTitleArr.count % 2) * 30 + 30  + 100 + 148 ;
    }  else {
        return 70;
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
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKMaintainInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmerName;
        if (model.region == nil) {
           cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddr];
        } else {
            cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddr];
        }
        cell.telStr = model.txtFarmerPhone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKMaintainOrderCell";
        JKMaintainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKMaintainOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.dataSource.count == 0) {
            return cell;
        }
        cell.maintainType = self.maintainType;
        JKMaintainInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKMaintainResultCell";
        JKMaintainResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKMaintainResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKMaintainInfoModel *model = self.dataSource[0];
        cell.maintainType = self.maintainType;
        [cell createUI:model];
        cell.delegate = self;
        self.mrCell = cell;
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
            make.top.equalTo(cell).offset(15);
            make.left.right.bottom.equalTo(cell);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"结束维护" forState:UIControlStateNormal];
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
            make.centerY.equalTo(bgView.mas_centerY).offset(-5);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        return cell;
    }
}

@end
