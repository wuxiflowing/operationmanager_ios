//
//  JKReplaceEquipmentVC.m
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKReplaceNewEquipmentVC.h"
#import "JKDeviceConfigurationCell.h"
#import "JKNewSensorConfigurationCell.h"
#import "JKNewControllerConfigurationOneCell.h"
#import "JKNewControllerConfigurationTwoCell.h"
#import "JKNewControllerConfigurationThreeCell.h"
#import "JKNewControllerConfigurationFourCell.h"
#import "JKChoosePondView.h"
#import "JKDeviceModel.h"
#import "JKScanVC.h"
#import "JKGeoCodeSearchVC.h"
#import "ZQAlterField.h"
#import "JKShowContactView.h"
#import "JKDeviceControlInfo.h"

@interface JKReplaceNewEquipmentVC () <UITableViewDelegate, UITableViewDataSource, JKDeviceConfigurationCellDelegate,JKChoosePondViewDelegate, JKScanVCDelegate, JKNewSensorConfigurationCellDelegate, CLLocationManagerDelegate, JKGeoCodeSearchVCDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *tskID;
@property (nonatomic, strong) JKNewSensorConfigurationCell *scgCell;
@property (nonatomic, strong) JKNewControllerConfigurationOneCell *ccgoCell;
@property (nonatomic, strong) JKNewControllerConfigurationTwoCell *ccgtCell;
@property (nonatomic, strong) JKNewControllerConfigurationThreeCell *ccgthCell;
@property (nonatomic, strong) JKNewControllerConfigurationFourCell *ccgfCell;
@property (nonatomic, strong) JKDeviceConfigurationCell *dcgCell;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, strong) NSString *pondid;
@property (nonatomic, strong) NSString *addrStr;
@property (nonatomic, strong) NSMutableArray *contactList;
@property (nonatomic, strong) JKContactsModel *contactsModel;
@end

@implementation JKReplaceNewEquipmentVC

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

- (NSMutableArray *)contactList{
    if (!_contactList) {
        _contactList = [[NSMutableArray alloc] init];
    }
    return _contactList;
}

- (JKContactsModel *)contactsModel{
    if (!_contactsModel) {
        _contactsModel = [JKContactsModel new];
    }
    return _contactsModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == JKEquipmentInfoTypeInstall) {
        self.title = @"设备配置";
    } else {
        self.title = @"更换设备";
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerOneCell:)name:@"reloadControllerOneCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadControllerTwoCell:)name:@"reloadControllerTwoCell" object:nil];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self startLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllContactList];
    if (self.deviceID != nil) {
        if (self.isFromRepairVC) {
            [self getDeviceInfo:self.deviceID];
        } else {
            [self checkDeviceTskID:self.deviceID];
        }
    }
    if (self.type == JKEquipmentInfoTypeRepaire) {
        [self getDeviceContactList];
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.locationManager = nil;
}

#pragma mark -- 开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    self.lat = newLocation.coordinate.latitude;
    self.lng = newLocation.coordinate.longitude;
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *province = placemark.administrativeArea;
            NSString *city = placemark.locality;
            NSString *district = placemark.subLocality;
            NSString *town = placemark.thoroughfare;
            NSString *name = placemark.name;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            if (!district) {
                district = placemark.subAdministrativeArea;
            }
            
            if (!town) {
                town = placemark.subThoroughfare;
            }
            
            NSString *addr;
            if ([province isEqualToString:city]) {
                addr = [NSString stringWithFormat:@"%@%@%@",city,district,name];
            } else {
                addr = [NSString stringWithFormat:@"%@%@%@%@",province,city,district,name];
            }
            
            self.addrStr = addr;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        } else if (error == nil && [array count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

#pragma mark -- 取消
- (void)cancleBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadControllerOneCell:(NSNotification *)noti {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadControllerTwoCell:(NSNotification *)noti {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 扫描
- (void)scanDeviceId {
    JKScanVC *sVC = [[JKScanVC alloc] init];
    sVC.delegate = self;
    [self.navigationController pushViewController:sVC animated:YES];
}

- (void)showDeviceId:(NSString *)deviceId {
    self.deviceID = deviceId;
    if (self.isFromRepairVC) {
        [self getDeviceInfo:self.deviceID];
    } else {
        [self checkDeviceTskID:self.deviceID];
    }
}

#pragma mark -- 选择鱼塘
- (void)choosePond {
    JKChoosePondView *cpV = [[JKChoosePondView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    cpV.customerId = self.customerId;
    cpV.delegate = self;
    cpV.farmerName = self.farmerName;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: cpV];
}

#pragma mark -- 点击添加联系人
- (void)chooseAddContact{
    ZQAlterField *alertView = [ZQAlterField alertView];
    [alertView ensureClickBlock:^(NSString *nameString, NSString *phoneString) {
        NSLog(@"%@-%@",nameString,phoneString);
        if (nameString.length== 0) {
            return ;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:nameString forKey:@"name"];
        [params setObject:phoneString forKey:@"phoneNumber"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/linkMan/%@/save",kUrl_Base,self.customerId];
        
        [YJProgressHUD showProgressCircleNoValue:nil inView:self.view];
        [[JKHttpTool shareInstance] PutReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                if ([responseObject[@"message"] isEqualToString:@"联系人已存在"]) {
                    [YJProgressHUD showMessage:@"联系人已存在" inView:self.view];
                }else{
                    JKContactModel *contactModel = [JKContactModel new];
                    contactModel.linkManID = responseObject[@"data"][@"linkManID"];
                    contactModel.name = responseObject[@"data"][@"name"];
                    contactModel.phoneNumber = responseObject[@"data"][@"phoneNumber"];
                    [self.contactList addObject:contactModel];
                }
            }
        } withFailureBlock:^(NSError *error) {
            [YJProgressHUD hide];
        }];
    }];
    [alertView show];
}
#pragma mark -- 选择联系人tag:1~4
- (void)chooseContact:(NSInteger)tag{
    JKShowContactView *showContactView = [JKShowContactView showContactView];
    showContactView.list = self.contactList;
    [showContactView ensureCotactClickBlock:^(JKContactModel * _Nonnull contact) {
        NSLog(@"%@",contact);
        switch (tag) {
            case 1:
                self.contactsModel.contacters = contact.name;
                self.contactsModel.contactPhone = contact.phoneNumber;
                break;
            case 2:
                self.contactsModel.nightContacters = contact.name;
                self.contactsModel.nightContactPhone = contact.phoneNumber;
                break;
            case 3:
                self.contactsModel.standbyContact = contact.name;
                self.contactsModel.standbyContactPhone = contact.phoneNumber;
                break;
            case 4:
                self.contactsModel.standbynightContact = contact.name;
                self.contactsModel.standbynightContactPhone = contact.phoneNumber;
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadContactCell" object:nil userInfo:@{@"tag":@(tag),@"contact":[NSString stringWithFormat:@"%@(%@)",contact.name,contact.phoneNumber]}]];
    }];
    [showContactView show];
    

}

- (void)showPondName:(NSString *)pondName withPondId:(NSString *)pondId {
    self.pondName = pondName;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadPondNameCell" object:nil userInfo:@{@"pondName":pondName,@"pondId":pondId}]];
    NSIndexPath *indexPathOne = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayOne = @[indexPathOne];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayOne withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray <NSIndexPath *> *indexPathArrayTwo = @[indexPathTwo];
    [self.tableView reloadRowsAtIndexPaths:indexPathArrayTwo withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 测试连接
- (void)onlineCheckWithTskID:(NSString *)tskID {
    self.deviceID = tskID;
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/%@/onlineCheck",kUrl_Base,tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"测试连接..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            //            [YJProgressHUD showMessage:[NSString stringWithFormat:@"%@",responseObject[@"message"]] inView:self.view];
            [YJProgressHUD showMessage:@"设备在线" inView:self.view];
        } else {
            [YJProgressHUD showMessage:@"设备不在线" inView:self.view];
            //            [YJProgressHUD showMessage:[NSString stringWithFormat:@"%@",responseObject[@"message"]] inView:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 开/关
- (void)getDeviceControlState:(NSString *)state withTskID:(NSString *)tskID{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:state forKey:@"powerControl"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/%@/updateCommand",kUrl_Base,tskID];
    
    [[JKHttpTool shareInstance] PutReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            if ([state isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:@"已开启" inView:self.view];
            } else {
                [YJProgressHUD showMessage:@"已关闭" inView:self.view];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getDeviceInfo:tskID];
            });
        } else {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
    }];
}

#pragma mark -- 设备校准
- (void)resetInstall:(NSString *)tskID {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/%@/reset/install",kUrl_Base,tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"设备校准..." inView:self.view];
    [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            [YJProgressHUD showMessage:@"设备校准成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getDeviceInfo:tskID];
            });
        } else {
            [YJProgressHUD showMessage:@"设备校准失败" inView:self.view];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)getDeviceInfoWithTskID:(NSString *)tskID {
    [self checkDeviceTskID:tskID];
}

#pragma mark -- 设备检验
- (void)checkDeviceTskID:(NSString *)tskID {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/%@/deviceCheck",kUrl_Base,tskID];
    [YJProgressHUD showProgressCircleNoValue:nil inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"data"]] isEqualToString:@"OK"]) {
            [self getDeviceInfo:tskID];
        } else {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 设备信息
- (void)getDeviceInfo:(NSString *)tskID {
    self.tskID = tskID;
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/new/%@",kUrl_Base,tskID];
    
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            NSLog(@"%@",responseObject);
            [self.dataSource removeAllObjects];
            NSDictionary *dict = responseObject[@"data"];
            JKDeviceModel *model = [[JKDeviceModel alloc] init];
            model.deviceId = [NSString stringWithFormat:@"%@",dict[@"identifier"]];
            model.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
            model.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
            model.workStatus = [dict[@"workStatus"] integerValue];
            model.deviceControlInfoBeanList = dict[@"deviceControlInfoBeanList"];
            model.oxy = [JKSafeNull(dict[@"oxy"]) floatValue];
            model.temp = [JKSafeNull(dict[@"temp"]) floatValue];
            model.ph = [JKSafeNull(dict[@"ph"]) floatValue];
            model.connectionType = [dict[@"connectionType"] integerValue];
            model.alertlineOne = [dict[@"alertline1"] floatValue];
            model.alertlineTwo = [dict[@"alertline2"] floatValue];
            if (![model.deviceControlInfoBeanList isKindOfClass:[NSNull class]]) {
                if (model.deviceControlInfoBeanList.count != 0) {
                    for (NSInteger i = 0; i<4; i++) {
                        NSDictionary *dic = [model.deviceControlInfoBeanList objectAtIndex:i];
                        JKDeviceControlInfo *dviceControl = [JKDeviceControlInfo new];
                        dviceControl.controlId = [dic[@"controlId"] integerValue];
                        dviceControl.oxyLimitUp = [dic[@"oxyLimitUp"] floatValue];
                        dviceControl.oxyLimitDown = [dic[@"oxyLimitDown"] floatValue];
                        dviceControl.electricityUp = [dic[@"electricityUp"] floatValue];
                        dviceControl.electricityDown = [dic[@"electricityDown"] floatValue];
                        dviceControl.open = [JKSafeNull(dic[@"open"]) integerValue];
                        dviceControl.isAuto = [JKSafeNull(dic[@"isAuto"]) integerValue];
                        if (i == 0) {
                            model.controlInfo1 = dviceControl;
                        }
                        if (i == 1) {
                            model.controlInfo2 = dviceControl;
                        }
                        if (i == 2) {
                            model.controlInfo3 = dviceControl;
                        }
                        if (i == 3) {
                            model.controlInfo4 = dviceControl;
                        }
                    }
                }
            }
            
            [self.dataSource addObject:model];
        } else {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取所有联系人列表
- (void)getAllContactList{
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/linkMan/farmerId/%@",kUrl_Base,self.customerId];
    [YJProgressHUD showProgressCircleNoValue:nil inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            NSArray *contacts =  responseObject[@"data"];
            [self.contactList removeAllObjects];
            for (NSDictionary *dic in contacts) {
                JKContactModel *contactModel = [JKContactModel new];
                contactModel.linkManID = dic[@"linkManID"];
                contactModel.name = dic[@"name"];
                contactModel.phoneNumber = dic[@"phoneNumber"];
                [self.contactList addObject:contactModel];
            }
            
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 根据鱼塘id获取绑定的设备联系人
- (void)getDeviceContactList{
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/linkMan/deviceId/%@",kUrl_Base,self.pondId];
    [YJProgressHUD showProgressCircleNoValue:nil inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            NSDictionary *dic =  responseObject[@"data"];
            JKContactsModel *contactsModel = [JKContactsModel new];
            contactsModel.contacters = dic[@"contacters"];
            contactsModel.contactPhone = dic[@"contactPhone"];
            contactsModel.nightContacters = dic[@"nightContacters"];
            contactsModel.nightContactPhone = dic[@"nightContactPhone"];
            contactsModel.standbyContact = dic[@"standbyContact"];
            contactsModel.standbyContactPhone = dic[@"standbyContactPhone"];
            contactsModel.standbynightContact = dic[@"standbynightContact"];
            contactsModel.standbynightContactPhone = dic[@"standbynightContactPhone"];
            self.contactsModel = contactsModel;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 获取鱼塘ID
- (void)getPondId:(NSString *)pondId {
    self.pondid = pondId;
    NSLog(@"%@",self.pondid);
}

#pragma mark -- 鱼塘地址
- (void)locationAddr {
    JKGeoCodeSearchVC *gcsVC = [[JKGeoCodeSearchVC alloc] init];
    gcsVC.delegate = self;
    gcsVC.lat = self.lat + 0.006;
    gcsVC.lng = self.lng + 0.0065;
    [self.navigationController pushViewController:gcsVC animated:YES];
}

#pragma mark -- 返回安装地点
- (void)chooseAdddrInfo:(NSString *)info {
    NSArray *arr = [info componentsSeparatedByString:@","];
    self.addrStr = arr[0];
    self.lat = [arr[1] floatValue];
    self.lng = [arr[2] floatValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 保存
- (void)saveBtnClick:(UIButton *)btn {
    if (self.tskID == nil) {
        [YJProgressHUD showMessage:@"请输入设备ID" inView:self.view];
        return;
    }
    
    if ([self.tskID trimmingCharacters].length != 6) {
        [YJProgressHUD showMessage:@"请输入6位设备ID" inView:self.view];
        return;
    }
    
    if (self.scgCell.alertlineOneStr == nil || self.scgCell.alertlineTwoStr == nil) {
        [YJProgressHUD showMessage:@"请完善传感器配置" inView:self.view];
        return;
    }
    
    
    //    if (self.ccgoCell.pondName == nil || self.ccgoCell.ammeterTypeA == nil || self.ccgoCell.powerA == nil || self.ccgoCell.voltageUpA == nil || self.ccgoCell.voltageDownA == nil || self.ccgoCell.electricCurrentUpA == nil|| self.ccgoCell.electricCurrentDownA == nil) {
    //        [YJProgressHUD showMessage:@"请完善控制器1配置" inView:self.view];
    //        return;
    //    }
    //
    //    if (self.ccgtCell.pondName == nil || self.ccgtCell.ammeterTypeB == nil || self.ccgtCell.powerB == nil || self.ccgtCell.voltageUpB == nil || self.ccgtCell.voltageDownB == nil || self.ccgtCell.electricCurrentUpB == nil|| self.ccgtCell.electricCurrentDownB == nil) {
    //        [YJProgressHUD showMessage:@"请完善控制器2配置" inView:self.view];
    //        return;
    //    }
    
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setObject:@(0) forKey:@"controlId"];
    if (self.ccgoCell.electricCurrentUpA == nil) {
        [dict1 setObject:@(0)  forKey:@"electricityUp"];
    } else {
        [dict1 setObject:self.ccgoCell.electricCurrentUpA  forKey:@"electricityUp"];
    }
    if (self.ccgoCell.electricCurrentDownA == nil) {
        [dict1 setObject:@(0) forKey:@"electricityDown"];
    } else {
        [dict1 setObject:self.ccgoCell.electricCurrentDownA forKey:@"electricityDown"];
    }
    if (self.ccgoCell.oxygenUpA == nil) {
        [dict1 setObject:@(0) forKey:@"oxyLimitUp"];
    } else {
        [dict1 setObject:self.ccgoCell.oxygenUpA forKey:@"oxyLimitUp"];
    }
    if (self.ccgoCell.oxygenDownA == nil) {
        [dict1 setObject:@(0) forKey:@"oxyLimitDown"];
    } else {
        [dict1 setObject:self.ccgoCell.oxygenDownA forKey:@"oxyLimitDown"];
    }
    
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setObject:@(1) forKey:@"controlId"];
    if (self.ccgtCell.electricCurrentUpB == nil) {
        [dict2 setObject:@(0)  forKey:@"electricityUp"];
    } else {
        [dict2 setObject:self.ccgtCell.electricCurrentUpB  forKey:@"electricityUp"];
    }
    if (self.ccgtCell.electricCurrentDownB == nil) {
        [dict2 setObject:@(0) forKey:@"electricityDown"];
    } else {
        [dict2 setObject:self.ccgtCell.electricCurrentDownB forKey:@"electricityDown"];
    }

    if (self.ccgtCell.oxygenUpB == nil) {
        [dict2 setObject:@(0) forKey:@"oxyLimitUp"];
    } else {
        [dict2 setObject:self.ccgtCell.oxygenUpB forKey:@"oxyLimitUp"];
    }
    if (self.ccgtCell.oxygenDownB == nil) {
        [dict2 setObject:@(0) forKey:@"oxyLimitDown"];
    } else {
        [dict2 setObject:self.ccgtCell.oxygenDownB forKey:@"oxyLimitDown"];
    }
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    [dict3 setObject:@(2) forKey:@"controlId"];
    if (self.ccgthCell.electricCurrentUpC == nil) {
        [dict3 setObject:@(0)  forKey:@"electricityUp"];
    } else {
        [dict3 setObject:self.ccgthCell.electricCurrentUpC  forKey:@"electricityUp"];
    }
    if (self.ccgthCell.electricCurrentDownC == nil) {
        [dict3 setObject:@(0) forKey:@"electricityDown"];
    } else {
        [dict3 setObject:self.ccgthCell.electricCurrentDownC forKey:@"electricityDown"];
    }
    
    if (self.ccgthCell.oxygenUpC == nil) {
        [dict3 setObject:@(0) forKey:@"oxyLimitUp"];
    } else {
        [dict3 setObject:self.ccgthCell.oxygenUpC forKey:@"oxyLimitUp"];
    }
    if (self.ccgthCell.oxygenDownC == nil) {
        [dict3 setObject:@(0) forKey:@"oxyLimitDown"];
    } else {
        [dict3 setObject:self.ccgthCell.oxygenDownC forKey:@"oxyLimitDown"];
    }
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
    [dict4 setObject:@(3) forKey:@"controlId"];
    if (self.ccgfCell.electricCurrentUpD == nil) {
        [dict4 setObject:@(0)  forKey:@"electricityUp"];
    } else {
        [dict4 setObject:self.ccgfCell.electricCurrentUpD  forKey:@"electricityUp"];
    }
    if (self.ccgfCell.electricCurrentDownD == nil) {
        [dict4 setObject:@(0) forKey:@"electricityDown"];
    } else {
        [dict4 setObject:self.ccgfCell.electricCurrentDownD forKey:@"electricityDown"];
    }
    
    if (self.ccgfCell.oxygenUpD == nil) {
        [dict4 setObject:@(0) forKey:@"oxyLimitUp"];
    } else {
        [dict4 setObject:self.ccgfCell.oxygenUpD forKey:@"oxyLimitUp"];
    }
    if (self.ccgfCell.oxygenDownD == nil) {
        [dict4 setObject:@(0) forKey:@"oxyLimitDown"];
    } else {
        [dict4 setObject:self.ccgfCell.oxygenDownD forKey:@"oxyLimitDown"];
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:dict1];
    [arr addObject:dict2];
    [arr addObject:dict3];
    [arr addObject:dict4];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:arr forKey:@"deviceControlInfoBeanList"];
    [params setObject:self.scgCell.alertlineOneStr forKey:@"alertline1"];
    [params setObject:self.scgCell.alertlineTwoStr forKey:@"alertline2"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/newDevice/%@",kUrl_Base,self.tskID];
    [YJProgressHUD showProgressCircleNoValue:@"保存中..." inView:self.view];
    [[JKHttpTool shareInstance] PutReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            //            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
            [YJProgressHUD showMessage:@"保存成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.isSet) {
                    JKDeviceModel *model = self.dataSource[0];
                    if ([self->_delegate respondsToSelector:@selector(newChangeDevice:withPondName:withPondId:withNo:contactsModel:)]) {
                        [self->_delegate newChangeDevice:model withPondName:self.dcgCell.pondName withPondId:self.dcgCell.pondId withNo:self.no contactsModel:self.contactsModel];
                    }
                } else {
                    JKDeviceModel *model = self.dataSource[0];
                    if (self.type == JKEquipmentInfoTypeRepaire) {
                        if ([self->_delegate respondsToSelector:@selector(newReplaceDevice:withPondAddr:withLat:withLng:contactsModel:)]) {
                            [self->_delegate newReplaceDevice:model withPondAddr:self.addrStr withLat:self.lat withLng:self.lng contactsModel:self.contactsModel];
                        }
                    } else {
                        if ([self->_delegate respondsToSelector:@selector(newAddDevice:withPondName:withPondId:withPondAddr:withLat:withLng:contactsModel:)]) {
                            [self->_delegate newAddDevice:model withPondName:self.dcgCell.pondName withPondId:self.pondid withPondAddr:self.addrStr withLat:self.lat withLng:self.lng contactsModel:self.contactsModel];
                        }
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}



- (void)changeSensorConfigurationSetting:(NSMutableArray *)dataSource {
    self.dataSource = dataSource;
    JKDeviceModel *model = dataSource[0];
    NSLog(@"%f--%f",model.oxyLimitDownOne,model.oxyLimitUp);
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 248 +240;
    } else if (indexPath.row == 1) {
        return 207;
    } else if (indexPath.row == 6) {
        return 70;
    } else {
        return 48*6+15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID = @"JKDeviceConfigurationCell";
        JKDeviceConfigurationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKDeviceConfigurationCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.dataSource = self.dataSource;
        cell.deviceId = self.deviceID;
        cell.pondName = self.pondName;
        cell.pondId = self.pondId;
        cell.isFromRepairVC = self.isFromRepairVC;
        cell.addrStr = self.addrStr;
        self.dcgCell = cell;
        cell.equipmentType = JKEquipmentType_New;
        if (self.type == JKEquipmentInfoTypeRepaire) {
            cell.contactsModel = self.contactsModel;
        }
        [cell createUI];
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKNewSensorConfigurationCell";
        JKNewSensorConfigurationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKNewSensorConfigurationCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.scgCell = cell;
        cell.dataSource = self.dataSource;
        cell.delegate = self;
        cell.matchingBlock = ^(NSInteger connectionType) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:[NSString stringWithFormat:@"%zd",connectionType] forKey:@"pairType"];
            NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/%@/devicePair",kUrl_Base,self.tskID];
            
            [[JKHttpTool shareInstance] PutReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
                if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                    [YJProgressHUD showMessage:@"配对成功" inView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self getDeviceInfo:self.tskID];
                    });
                } else {
                    [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                }
                [self.tableView reloadData];
            } withFailureBlock:^(NSError *error) {
            }];
        };
        return cell;
    } else if (indexPath.row == 6) {
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = kBgColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kWhiteColor;
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(15);
            make.left.right.bottom.equalTo(cell);
        }];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        cancleBtn.layer.cornerRadius = 6;
        cancleBtn.layer.masksToBounds = YES;
        cancleBtn.layer.borderColor = kThemeColor.CGColor;
        cancleBtn.layer.borderWidth = 1;
        cancleBtn.titleLabel.font = JKFont(16);
        [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_centerX).offset(-SCALE_SIZE(7.5));
            make.height.mas_equalTo(40);
        }];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        saveBtn.layer.cornerRadius = 6;
        saveBtn.layer.masksToBounds = YES;
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        saveBtn.titleLabel.font = JKFont(16);
        [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:saveBtn];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.right.equalTo(bgView).offset(-SCALE_SIZE(15));
            make.left.equalTo(bgView.mas_centerX).offset(SCALE_SIZE(7.5));
            make.height.mas_equalTo(40);
        }];
        
        return cell;
    } else {
        if (indexPath.row == 2) {
            static NSString *ID = @"JKNewControllerConfigurationOneCell";
            JKNewControllerConfigurationOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKNewControllerConfigurationOneCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            self.ccgoCell = cell;
            if (self.dataSource.count == 0) {
                return cell;
            } else {
                cell.dataSource = self.dataSource;
            }
            cell.controlCallBack = ^(NSString * _Nonnull controlState) {
                NSString *state = [controlState isEqualToString:@"1"]?@"on":@"off";
                NSString *urlStr = [NSString stringWithFormat:@"%@/v1/deviceMonitor/core/device/identifier/%@/control/0/switch/%@",kUrl_Base,self.tskID,state];
                [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
                    if (![responseObject[@"err"] boolValue]) {
                        if ([responseObject[@"state"] isEqualToString:@"on"]) {
                            [YJProgressHUD showMessage:@"已开启" inView:self.view];
                        } else {
                            [YJProgressHUD showMessage:@"已关闭" inView:self.view];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self getDeviceInfo:self.tskID];
                        });
                    }else{
                        [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                    }
                    [self.tableView reloadData];
                } withFailureBlock:^(NSError *error) {
                }];
            };
            return cell;
        }  else if (indexPath.row == 3) {
            static NSString *ID = @"JKNewControllerConfigurationTwoCell";
            JKNewControllerConfigurationTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKNewControllerConfigurationTwoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            self.ccgtCell = cell;
            if (self.dataSource.count == 0) {
                return cell;
            } else {
                cell.dataSource = self.dataSource;
            }
            cell.controlCallBack = ^(NSString * _Nonnull controlState) {
                NSString *state = [controlState isEqualToString:@"1"]?@"on":@"off";
                NSString *urlStr = [NSString stringWithFormat:@"%@/v1/deviceMonitor/core/device/identifier/%@/control/1/switch/%@",kUrl_Base,self.tskID,state];
                [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
                    if (![responseObject[@"err"] boolValue]) {
                        if ([responseObject[@"state"] isEqualToString:@"on"]) {
                            [YJProgressHUD showMessage:@"已开启" inView:self.view];
                        } else {
                            [YJProgressHUD showMessage:@"已关闭" inView:self.view];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self getDeviceInfo:self.tskID];
                        });
                    }else{
                        [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                    }
                    [self.tableView reloadData];
                } withFailureBlock:^(NSError *error) {
                }];
            };
            return cell;
        } else if (indexPath.row == 4) {
            static NSString *ID = @"JKNewControllerConfigurationThreeCell";
            JKNewControllerConfigurationThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKNewControllerConfigurationThreeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            self.ccgthCell = cell;
            if (self.dataSource.count == 0) {
                return cell;
            } else {
                cell.dataSource = self.dataSource;
            }
            cell.controlCallBack = ^(NSString * _Nonnull controlState) {
                NSString *state = [controlState isEqualToString:@"1"]?@"on":@"off";
                NSString *urlStr = [NSString stringWithFormat:@"%@/v1/deviceMonitor/core/device/identifier/%@/control/2/switch/%@",kUrl_Base,self.tskID,state];
                [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
                    if (![responseObject[@"err"] boolValue]) {
                        if ([responseObject[@"state"] isEqualToString:@"on"]) {
                            [YJProgressHUD showMessage:@"已开启" inView:self.view];
                        } else {
                            [YJProgressHUD showMessage:@"已关闭" inView:self.view];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self getDeviceInfo:self.tskID];
                        });
                    }else{
                        [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                    }
                    [self.tableView reloadData];
                } withFailureBlock:^(NSError *error) {
                }];
            };
            return cell;
        } else {
            static NSString *ID = @"JKNewControllerConfigurationFourCell";
            JKNewControllerConfigurationFourCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if(!cell){
                cell = [[JKNewControllerConfigurationFourCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            self.ccgfCell = cell;
            if (self.dataSource.count == 0) {
                return cell;
            } else {
                cell.dataSource = self.dataSource;
            }
            cell.controlCallBack = ^(NSString * _Nonnull controlState) {
                NSString *state = [controlState isEqualToString:@"1"]?@"on":@"off";
                NSString *urlStr = [NSString stringWithFormat:@"%@/v1/deviceMonitor/core/device/identifier/%@/control/3/switch/%@",kUrl_Base,self.tskID,state];
                [[JKHttpTool shareInstance] PutReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
                    if (![responseObject[@"err"] boolValue]) {
                        if ([responseObject[@"state"] isEqualToString:@"on"]) {
                            [YJProgressHUD showMessage:@"已开启" inView:self.view];
                        } else {
                            [YJProgressHUD showMessage:@"已关闭" inView:self.view];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self getDeviceInfo:self.tskID];
                        });
                    }else{
                        [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                    }
                    [self.tableView reloadData];
                } withFailureBlock:^(NSError *error) {
                }];
            };
            return cell;
        }
    }
}

@end
