//
//  JKInstallIngInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/8/13.
//  Copyright © 2018年   . All rights reserved.
//
//contactPhone                           白班联系人电话
//contacters                                白班联系人姓名
//standbyContact                       白班备用联系人姓名
//standbyContactPhone             白班备用联系人电话
//nightContactPhone                 晚班联系人电话
//nightContacters                      晚班联系人姓名
//standbyNightContact             晚班备用联系人姓名
//standbyNightContactPhone   晚班备用联系人电话
#import "JKInstallIngInfoVC.h"
#import "JKTaskTopCell.h"
#import "JKInstallationOrderCell.h"
#import "JKDeviceListCell.h"
#import "JKInstallationResultCell.h"
#import "JKInstallInfoModel.h"
#import "JKReplaceEquipmentVC.h"
#import "JKReplaceNewEquipmentVC.h"
#import "JKDeviceModel.h"
#import "JKEquipmentInfoVC.h"
#import "JKNewEquipmentInfoVC.h"
#import "JKInstallationVC.h"
#import "JKFarmerEquipmentTaskCell.h"
@interface JKInstallIngInfoVC () <UITableViewDelegate, UITableViewDataSource,JKReplaceEquipmentVCDelegate,JKReplaceNewEquipmentVCDelegate,JKFarmerEquipmentMainCellDelegate, JKTaskTopCellDelegate,JKInstallationOrderCellDelegate>
{
    BOOL _isServiceOn;
    BOOL _isDepositOn;
    NSInteger _indexCell;
    NSInteger _forOrderCount;
    NSInteger _forServiceCount;
    NSInteger _forDepositCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *addDeviceArr;
@property (nonatomic, assign) NSInteger serviceHeight;
@property (nonatomic, assign) NSInteger depositHeight;
@property (nonatomic, assign) JKInstallationResultCell *irCell;
@property (nonatomic, strong) NSMutableArray *deviceInfoArr;
@property (nonatomic, strong) NSMutableArray *intallOrderArr;
@property (nonatomic, strong) NSMutableArray *intallServiceArr;
@property (nonatomic, strong) NSMutableArray *intallDepositArr;
@property (nonatomic, strong) NSString *deviceStr;

@end

@implementation JKInstallIngInfoVC
- (NSMutableArray *)intallOrderArr {
    if (!_intallOrderArr) {
        _intallOrderArr = [[NSMutableArray alloc] init];
    }
    return _intallOrderArr;
}

- (NSMutableArray *)intallServiceArr {
    if (!_intallServiceArr) {
        _intallServiceArr = [[NSMutableArray alloc] init];
    }
    return _intallServiceArr;
}

- (NSMutableArray *)intallDepositArr {
    if (!_intallDepositArr) {
        _intallDepositArr = [[NSMutableArray alloc] init];
    }
    return _intallDepositArr;
}

- (NSMutableArray *)deviceInfoArr {
    if (!_deviceInfoArr) {
        _deviceInfoArr = [[NSMutableArray alloc] init];
    }
    return _deviceInfoArr;
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

- (NSMutableArray *)addDeviceArr {
    if (!_addDeviceArr) {
        _addDeviceArr = [[NSMutableArray alloc] init];
    }
    return _addDeviceArr;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"任务详情";
    
    _isServiceOn = NO;
    _isDepositOn = NO;
    self.serviceHeight = 0;
    self.depositHeight = 0;
    _indexCell = 0;
    
    NSString *allDeviceStr = [JKUserDefaults objectForKey:self.tskID];
    NSArray *allDeviceArr = [allDeviceStr componentsSeparatedByString:@"+"];
    for (NSString *deviceStr in allDeviceArr) {
        NSArray *deviceArr = [deviceStr componentsSeparatedByString:@","];
        if (deviceArr.count == 12) {
            JKDeviceModel *dModel = [[JKDeviceModel alloc] init];
            dModel.deviceId = deviceArr[0];
            dModel.name = [NSString stringWithFormat:@"%@",deviceArr[1]];
            dModel.pondId = deviceArr[2];
            dModel.type = deviceArr[3];
            dModel.dissolvedOxygen = [deviceArr[4] integerValue];
            dModel.temperature = [deviceArr[5] integerValue];
            dModel.ph = [deviceArr[6] integerValue];
            dModel.alarmType = [deviceArr[7] integerValue];
            NSDictionary *dic1 = @{@"open":deviceArr[8]};
            NSDictionary *dic2 = @{@"open":deviceArr[9]};
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:dic1];
            [arr addObject:dic2];
            dModel.aeratorControls = [arr copy];
            dModel.automatic = deviceArr[10];
            dModel.workStatus = deviceArr[11];
            [self.addDeviceArr addObject:dModel];
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadServiceCellHeight:)name:@"reloadServiceCellHeight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDepositCellHeight:)name:@"reloadDepositCellHeight" object:nil];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getInstallTaskInfoList];
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
- (void)getInstallTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKInstallInfoModel *model = [[JKInstallInfoModel alloc] init];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.txtFarmer = responseObject[@"data"][@"txtFarmer"];
            model.txtFarmerAddress = responseObject[@"data"][@"txtFarmerAddress"];
            model.txtPhone = responseObject[@"data"][@"txtPhone"];
            model.txtStatus = responseObject[@"data"][@"txtStatus"];
            model.txtDeviceNum = responseObject[@"data"][@"txtDeviceNum"];
            model.txtInstallationPersonnel = responseObject[@"data"][@"txtInstallationPersonnel"];
            model.txtFishPondCount = responseObject[@"data"][@"txtFishPondCount"];
            model.txtInstallAddress = responseObject[@"data"][@"txtInstallAddress"];
            model.txtDepositAmount = responseObject[@"data"][@"txtDepositAmount"];
            model.txtServiceAmount = responseObject[@"data"][@"txtServiceAmount"];
            model.calExpectedTime = responseObject[@"data"][@"calExpectedTime"];
            model.tabEquipmentList = responseObject[@"data"][@"tabEquipmentList"];
            model.region = responseObject[@"data"][@"region"];
            model.picture = responseObject[@"data"][@"picture"];
            model.txtFarmerManager = responseObject[@"data"][@"txtFarmerManager"];
            model.latitude = responseObject[@"data"][@"latitude"];
            model.longitude = responseObject[@"data"][@"longitude"];
            model.txtReciptTime = responseObject[@"data"][@"txtReciptTime"];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 跳转第三方地图
- (void)showOtherMap {
    JKInstallInfoModel *model = self.dataSource[0];
    
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

- (void)saveBtnClick:(UIButton *)btn {
    if (self.addDeviceArr.count == 0) {
        [YJProgressHUD showMessage:@"请添加设备" inView:self.view];
        return;
    }
    
    [JKUserDefaults removeObjectForKey:self.tskID];
    
    NSMutableArray *allDeviceArr = [[NSMutableArray alloc] init];
    for (JKDeviceModel *model in self.addDeviceArr) {
        NSMutableArray *deviceArr = [[NSMutableArray alloc] init];
        NSString *deviceId = model.deviceId;
        NSString *name = model.name;
        NSString *pondId = model.pondId;
        NSString *type = model.type;
        NSString *dissolvedOxygen = [NSString stringWithFormat:@"%.1f",model.dissolvedOxygen];
        NSString *temperature = [NSString stringWithFormat:@"%.1f",model.temperature];
        NSString *ph = [NSString stringWithFormat:@"%.1f",model.ph];
        NSString *alarmType = [NSString stringWithFormat:@"%ld",model.alarmType];
        NSArray *arr = model.aeratorControls;
        NSString *aeratorControl0;
        NSString *aeratorControl1;
        if (arr.count == 0) {
            aeratorControl0 = @"0";
            aeratorControl1 = @"0";
        } else {
            aeratorControl0 = model.aeratorControls[0][@"open"];
            aeratorControl1 = model.aeratorControls[1][@"open"];
        }
        NSString *automatic = model.automatic;
        [deviceArr addObject:deviceId];
        [deviceArr addObject:name];
        [deviceArr addObject:pondId];
        [deviceArr addObject:type];
        [deviceArr addObject:dissolvedOxygen];
        [deviceArr addObject:temperature];
        [deviceArr addObject:ph];
        [deviceArr addObject:alarmType];
        [deviceArr addObject:aeratorControl0];
        [deviceArr addObject:aeratorControl1];
        [deviceArr addObject:automatic];
        [deviceArr addObject:model.workStatus];
        self.deviceStr = [deviceArr componentsJoinedByString:@","];
        [allDeviceArr addObject:self.deviceStr];
    }
    NSString *allDeviceStr = [allDeviceArr componentsJoinedByString:@"+"];
    [JKUserDefaults setObject:allDeviceStr forKey:self.tskID];
    [JKUserDefaults synchronize];
    [YJProgressHUD showMessage:@"保存成功" inView:self.view];
}

- (void)orderBtnClick:(UIButton *)btn {
    JKInstallInfoModel *model = [self.dataSource lastObject];
    if (self.addDeviceArr.count != [model.txtDeviceNum integerValue]) {
        [YJProgressHUD showMessage:@"安装数量不符" inView:self.view];
        return;
    }
    
    if (self.addDeviceArr.count == 0) {
        [YJProgressHUD showMessage:@"请添加设备" inView:self.view];
        return;
    }
    
    for (JKDeviceModel *model in self.addDeviceArr) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (![arr containsObject:model.deviceId]) {
            [arr addObject:model.deviceId];
        } else {
            [YJProgressHUD showMessage:@"安装设备重复" inView:self.view];
            return;
        }
    }
    
    for (JKDeviceModel *model in self.addDeviceArr) {
        NSMutableDictionary *deviceDic = [[NSMutableDictionary alloc] init];
        if (model.pondId != nil) {
          [deviceDic setObject:model.pondId forKey:@"pondId"];
        }
        [deviceDic setObject:model.name forKey:@"pondName"];
        [deviceDic setObject:model.deviceId forKey:@"deviceId"];
        [deviceDic setObject:model.addr forKey:@"pondAddr"];
        [deviceDic setObject:[NSString stringWithFormat:@"%f",model.lat] forKey:@"latitude"];
        [deviceDic setObject:[NSString stringWithFormat:@"%f",model.lng] forKey:@"longitude"];
        if (model.contactsModel.contacters) {
            [deviceDic setObject:model.contactsModel.contacters forKey:@"contacters"];
        }
        if (model.contactsModel.contactPhone) {
            [deviceDic setObject:model.contactsModel.contactPhone forKey:@"contactPhone"];
        }
        if (model.contactsModel.standbyContact) {
            [deviceDic setObject:model.contactsModel.standbyContact forKey:@"standbyContact"];
        }
        if (model.contactsModel.standbyContactPhone) {
            [deviceDic setObject:model.contactsModel.standbyContactPhone forKey:@"standbyContactPhone"];
        }
        if (model.contactsModel.nightContacters) {
            [deviceDic setObject:model.contactsModel.nightContacters forKey:@"nightContacters"];
        }
        if (model.contactsModel.nightContactPhone) {
            [deviceDic setObject:model.contactsModel.nightContactPhone forKey:@"nightContactPhone"];
        }
        if (model.contactsModel.standbynightContact) {
            [deviceDic setObject:model.contactsModel.standbynightContact forKey:@"standbynightContact"];
        }
        if (model.contactsModel.standbynightContactPhone) {
            [deviceDic setObject:model.contactsModel.standbynightContactPhone forKey:@"standbynightContactPhone"];
        }
        
        [self.deviceInfoArr addObject:deviceDic];
    }
    
    if (self.irCell.imageOrderArr.count != 0 || self.irCell.imageServiceArr.count != 0 || self.irCell.imageDepositArr.count != 0) {
        [self getImgUrl];
    } else {
        JKInstallInfoModel *model = self.dataSource[0];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
        [dict setObject:model.txtFarmerID forKey:@"farmerId"];
        if (self.irCell.isServiceFree) {
            if (self.irCell.serverFreeStr == nil) {
                [dict setObject:@"0" forKey:@"realServiceAmount"];
            } else {
                [dict setObject:self.irCell.serverFreeStr forKey:@"realServiceAmount"];
            }
            if (self.irCell.isChooseServerRemit) {
                [dict setObject:@"银行汇款" forKey:@"payServiceMethod"];
            } else {
                [dict setObject:@"现金" forKey:@"payServiceMethod"];
            }
            if (self.irCell.serverRemarkStr == nil) {
                [dict setObject:@"" forKey:@"serviceNote"];
            } else {
                [dict setObject:self.irCell.serverRemarkStr forKey:@"serviceNote"];
            }
        } else {
            [dict setObject:@"0" forKey:@"realServiceAmount"];
        }
        if (self.irCell.isDepositFree) {
            if (self.irCell.depositFreeStr == nil) {
                [dict setObject:@"0" forKey:@"realDepositAmount"];
            } else {
                [dict setObject:self.irCell.depositFreeStr forKey:@"realDepositAmount"];
            }
            if (self.irCell.isChooseDepositRemit) {
                [dict setObject:@"银行汇款" forKey:@"payDepositMethod"];
            } else {
                [dict setObject:@"现金" forKey:@"payDepositMethod"];
            }
            if (self.irCell.depositRemarkStr == nil) {
                [dict setObject:@"" forKey:@"depositNote"];
            } else {
                [dict setObject:self.irCell.depositRemarkStr forKey:@"depositNote"];
            }
        } else {
            [dict setObject:@"0" forKey:@"realDepositAmount"];
        }
        
        [dict setObject:self.deviceInfoArr forKey:@"bindDeviceList"];
//        [dict setObject:self.intallOrderArr forKey:@"confirmUrls"];
//        [dict setObject:self.intallServiceArr forKey:@"servicePayUrls"];
//        [dict setObject:self.intallDepositArr forKey:@"depositPayUrls"];
        
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:dict forKey:@"appData"];
        [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
        
        NSLog(@"%@",params);
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit", kUrl_Base,self.tskID];
        
        [YJProgressHUD showProgressCircleNoValue:@"上传资料中..." inView:self.view];
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:@"结束安装" inView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for(UIViewController *controller in self.navigationController.viewControllers) {
                        if([controller isKindOfClass:[JKInstallationVC class]]) {
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
}

- (void)getImgUrl {
    [self.intallOrderArr removeAllObjects];
    [self.intallServiceArr removeAllObjects];
    [self.intallDepositArr removeAllObjects];
    if (self.irCell.imageOrderArr.count != 0) {
        [self saveImage:self.irCell.imageOrderArr withImageType:JKImageTypeInstallOrder];
    }
    
    if (self.irCell.imageServiceArr.count != 0) {
        [self saveImage:self.irCell.imageServiceArr withImageType:JKImageTypeInstallService];
    }
    
    if (self.irCell.imageDepositArr.count != 0) {
        [self saveImage:self.irCell.imageDepositArr withImageType:JKImageTypeInstallDeposit];
    }
}

- (void)saveImage:(NSArray *)imgArr withImageType:(JKImageType)imageType {
    [YJProgressHUD showProgressCircleNoValue:@"上传资料中..." inView:self.view];
    if (imageType == JKImageTypeInstallOrder) {
        _forOrderCount = 0;
        [self getImgArr:imgArr withIndex:_forOrderCount withType:@"installForm"];
    } else if (imageType == JKImageTypeInstallService) {
        _forServiceCount = 0;
        [self getImgArr:imgArr withIndex:_forServiceCount withType:@"installService"];
    } else if (imageType == JKImageTypeInstallDeposit) {
        _forDepositCount = 0;
        [self getImgArr:imgArr withIndex:_forDepositCount withType:@"installDeposit"];
    }
}

- (void)getImgArr:(NSArray *)imgArr withIndex:(NSInteger)tag withType:(NSString *)type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:type forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%ld.jpg",[JKToolKit getNowTimestamp]] forKey:@"imageName"];
    [params setObject:[JKToolKit imageToString:imgArr[tag]] forKey:@"imageData"];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/%@/uploadImage", kUrl_Base, loginId];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        if ([type isEqualToString:@"installForm"]) {
            [self.intallOrderArr addObject:responseObject[@"data"]];
            _forOrderCount++;
            if (_forOrderCount == self.irCell.imageOrderArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forOrderCount withType:@"installForm"];
            }
        } else if ([type isEqualToString:@"installService"]) {
            [self.intallServiceArr addObject:responseObject[@"data"]];
            _forServiceCount++;
            if (_forServiceCount == self.irCell.imageServiceArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forServiceCount withType:@"installService"];
            }
        } else if ([type isEqualToString:@"installDeposit"]) {
            [self.intallDepositArr addObject:responseObject[@"data"]];
            _forDepositCount++;
            if (_forDepositCount == self.irCell.imageDepositArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forDepositCount withType:@"installDeposit"];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)submitInfo  {
//    NSLog(@"%ld--%ld",self.irCell.imageOrderArr.count,self.intallOrderArr.count);
//    NSLog(@"%ld--%ld",self.irCell.imageServiceArr.count,self.intallServiceArr.count);
//    NSLog(@"%ld--%ld",self.irCell.imageDepositArr.count,self.intallDepositArr.count);
    if (self.irCell.imageOrderArr.count == self.intallOrderArr.count && self.irCell.imageServiceArr.count == self.intallServiceArr.count && self.irCell.imageDepositArr.count == self.intallDepositArr.count) {
        JKInstallInfoModel *model = self.dataSource[0];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
        [dict setObject:model.txtFarmerID forKey:@"farmerId"];
        if (self.irCell.isServiceFree) {
            if (self.irCell.serverFreeStr == nil) {
                [dict setObject:@"0" forKey:@"realServiceAmount"];
            } else {
                [dict setObject:self.irCell.serverFreeStr forKey:@"realServiceAmount"];
            }
            if (self.irCell.isChooseServerRemit) {
                [dict setObject:@"银行汇款" forKey:@"payServiceMethod"];
            } else {
                [dict setObject:@"现金" forKey:@"payServiceMethod"];
            }
            if (self.irCell.serverRemarkStr == nil) {
                [dict setObject:@"" forKey:@"serviceNote"];
            } else {
                [dict setObject:self.irCell.serverRemarkStr forKey:@"serviceNote"];
            }
        } else {
            [dict setObject:@"0" forKey:@"realServiceAmount"];
        }
        if (self.irCell.isDepositFree) {
            if (self.irCell.depositFreeStr == nil) {
                [dict setObject:@"0" forKey:@"realDepositAmount"];
            } else {
                [dict setObject:self.irCell.depositFreeStr forKey:@"realDepositAmount"];
            }
            if (self.irCell.isChooseDepositRemit) {
                [dict setObject:@"银行汇款" forKey:@"payDepositMethod"];
            } else {
                [dict setObject:@"现金" forKey:@"payDepositMethod"];
            }
            if (self.irCell.depositRemarkStr == nil) {
                [dict setObject:@"" forKey:@"depositNote"];
            } else {
                [dict setObject:self.irCell.depositRemarkStr forKey:@"depositNote"];
            }
        } else {
            [dict setObject:@"0" forKey:@"realDepositAmount"];
        }
        
        [dict setObject:self.deviceInfoArr forKey:@"bindDeviceList"];
        [dict setObject:self.intallOrderArr forKey:@"confirmUrls"];
        [dict setObject:self.intallServiceArr forKey:@"servicePayUrls"];
        [dict setObject:self.intallDepositArr forKey:@"depositPayUrls"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:dict forKey:@"appData"];
        [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit", kUrl_Base,self.tskID];
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:@"结束安装" inView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
            }
        } withFailureBlock:^(NSError *error) {
            [YJProgressHUD hide];
        }];
    }
}

- (void)reloadServiceCellHeight:(NSNotification *)noti {
    NSString *temp = noti.userInfo[@"serviceHeight"];
    self.serviceHeight = [temp integerValue];
    if (self.serviceHeight == 348) {
        _isServiceOn = YES;
    } else {
        _isServiceOn = NO;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)reloadDepositCellHeight:(NSNotification *)noti {
    NSString *temp = noti.userInfo[@"depositHeight"];
    self.depositHeight = [temp integerValue];
    if (self.depositHeight == 348) {
        _isDepositOn = YES;
    } else {
        _isDepositOn = NO;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark -- 添加设备
- (void)addKDBtnClick:(UIButton *)btn {
    _indexCell = btn.tag;
    NSLog(@"%ld",_indexCell);
    JKInstallInfoModel *model = self.dataSource[0];
    JKReplaceEquipmentVC *reVC = [[JKReplaceEquipmentVC alloc] init];
    reVC.delegate = self;
    reVC.customerId = model.txtFarmerID;
    reVC.farmerName = model.txtFarmer;
    [self.navigationController pushViewController:reVC animated:YES];
}

- (void)addDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withPondAddr:(NSString *)pondAddr withLat:(CGFloat)lat withLng:(CGFloat)lng contactsModel:(JKContactsModel *)contactsModel{
    JKDeviceModel *dModel = [[JKDeviceModel alloc] init];
    dModel.deviceId = model.deviceId;
    dModel.name = pondName;
    dModel.pondId = pondId;
    dModel.type = model.type;
    dModel.dissolvedOxygen = model.dissolvedOxygen;
    dModel.temperature = model.temperature;
    dModel.ph = model.ph;
    dModel.workStatus = model.workStatus;
    dModel.aeratorControlOne = model.aeratorControls[0][@"open"];
    dModel.aeratorControlTwo = model.aeratorControls[1][@"open"];
    dModel.statusControlOne = model.aeratorControls[0][@"automatic"];
    dModel.statusControlTwo = model.aeratorControls[1][@"automatic"];

    dModel.aeratorControls = model.aeratorControls;
    dModel.alarmType = model.alarmType;
    dModel.automatic = model.automatic;
    dModel.addr = pondAddr;
    dModel.lat = lat;
    dModel.lng = lng;
    dModel.contactsModel = contactsModel;
    [self.addDeviceArr addObject:dModel];
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_indexCell inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}

- (void)deleteDevice:(NSInteger)no {
    [self.addDeviceArr removeObjectAtIndex:no - 3];
    [self.tableView reloadData];
}

- (void)changeDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withNo:(NSInteger)no contactsModel:(JKContactsModel *)contactsModel{
    JKDeviceModel *dModel = [[JKDeviceModel alloc] init];
    dModel.deviceId = model.deviceId;
    dModel.name = pondName;
    dModel.pondId = pondId;
    dModel.type = model.type;
    dModel.dissolvedOxygen = model.dissolvedOxygen;
    dModel.temperature = model.temperature;
    dModel.ph = model.ph;
    dModel.workStatus = model.workStatus;
    dModel.aeratorControlOne = model.aeratorControls[0][@"open"];
    dModel.aeratorControlTwo = model.aeratorControls[1][@"open"];
    dModel.statusControlOne = model.aeratorControls[0][@"automatic"];
    dModel.statusControlTwo = model.aeratorControls[1][@"automatic"];
    
    dModel.aeratorControls = model.aeratorControls;
    dModel.alarmType = model.alarmType;
    dModel.automatic = model.automatic;
    dModel.contactsModel = contactsModel;
    [self.addDeviceArr addObject:dModel];
    
    for (JKDeviceModel *dModel in self.addDeviceArr) {
        NSLog(@"%@",dModel.deviceId);
    }
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:no inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addQYBtnClick:(UIButton *)btn {
    _indexCell = btn.tag;
    NSLog(@"%ld",_indexCell);
    JKInstallInfoModel *model = self.dataSource[0];
    JKReplaceNewEquipmentVC *reVC = [[JKReplaceNewEquipmentVC alloc] init];
    reVC.delegate = self;
    reVC.customerId = model.txtFarmerID;
    reVC.farmerName = model.txtFarmer;
    [self.navigationController pushViewController:reVC animated:YES];
}

- (void)newAddDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withPondAddr:(NSString *)pondAddr withLat:(CGFloat)lat withLng:(CGFloat)lng contactsModel:(JKContactsModel *)contactsModel{
    JKDeviceModel *dModel = [[JKDeviceModel alloc] init];
    dModel.deviceId = model.deviceId;
    dModel.name = pondName;
    dModel.pondId = pondId;
    dModel.type = model.type;
    dModel.dissolvedOxygen = model.oxy;
    dModel.temperature = model.temp;
    dModel.ph = model.ph;
    dModel.workStatus = model.workStatus;
    
    dModel.aeratorControlOne = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[0][@"open"]];
    dModel.aeratorControlTwo = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[1][@"open"]];
    dModel.aeratorControlTree = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[2][@"open"]];
    dModel.aeratorControlFour = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[3][@"open"]];
    dModel.statusControlOne = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[0][@"auto"]];
    dModel.statusControlTwo = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[1][@"auto"]];
    dModel.statusControlTree = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[2][@"auto"]];
    dModel.statusControlFour = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[3][@"auto"]];
    
    dModel.addr = pondAddr;
    dModel.lat = lat;
    dModel.lng = lng;
    dModel.contactsModel = contactsModel;
    [self.addDeviceArr addObject:dModel];
    //    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_indexCell inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}
- (void)newChangeDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withNo:(NSInteger)no contactsModel:(JKContactsModel *)contactsModel{
    JKDeviceModel *dModel = [[JKDeviceModel alloc] init];
    dModel.deviceId = model.deviceId;
    dModel.name = pondName;
    dModel.pondId = pondId;
    dModel.type = model.type;
    dModel.dissolvedOxygen = model.oxy;
    dModel.temperature = model.temp;
    dModel.ph = model.ph;
    dModel.workStatus = model.workStatus;
    
    dModel.aeratorControlOne = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[0][@"open"]];
    dModel.aeratorControlTwo = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[1][@"open"]];
    dModel.aeratorControlTree = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[2][@"open"]];
    dModel.aeratorControlFour = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[3][@"open"]];
    dModel.statusControlOne = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[0][@"auto"]];
    dModel.statusControlTwo = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[1][@"auto"]];
    dModel.statusControlTree = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[2][@"auto"]];
    dModel.statusControlFour = [NSString stringWithFormat:@"%@",model.deviceControlInfoBeanList[3][@"auto"]];
    
    dModel.contactsModel = contactsModel;
    [self.tableView reloadData];
    
    for (JKDeviceModel *dModel in self.addDeviceArr) {
        NSLog(@"%@",dModel.deviceId);
    }
}

- (void)setDeviceInfo:(NSString *)deviceId withPondName:(NSString *)pondName withPondId:(NSString *)pondId withNo:(NSInteger)no withType:(JKEquipmentType)equipmentType{
    JKInstallInfoModel *model = self.dataSource[0];
    if (equipmentType == JKEquipmentType_Old) {
        JKReplaceEquipmentVC *reVC = [[JKReplaceEquipmentVC alloc] init];
        reVC.delegate = self;
        reVC.customerId = model.txtFarmerID;
        reVC.deviceID = deviceId;
        reVC.pondId =  pondId;
        reVC.pondName = pondName;
        reVC.isSet = YES;
        reVC.no = no;
        [self.navigationController pushViewController:reVC animated:YES];
    }
    
    if (equipmentType == JKEquipmentType_New) {
        JKReplaceNewEquipmentVC *reVC = [[JKReplaceNewEquipmentVC alloc] init];
        reVC.delegate = self;
        reVC.customerId = model.txtFarmerID;
        reVC.deviceID = deviceId;
        reVC.pondId =  pondId;
        reVC.pondName = pondName;
        reVC.isSet = YES;
        reVC.no = no;
        [self.navigationController pushViewController:reVC animated:YES];
    }

}



#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addDeviceArr.count + 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else if (indexPath.row == 1) {
        return 310;
    } else if (indexPath.row == 2) {
        if (self.dataSource.count == 0) {
            return 48 + 10;
        }
        JKInstallInfoModel *model = self.dataSource[0];
        if (model.tabEquipmentList.count == 0) {
            return 96 + 10;
        } else {
            return 48 * (model.tabEquipmentList.count + 1) + 10;
        }
    } else if (indexPath.row == (self.addDeviceArr.count + 6 - 1)) {
        return 88;
    } else if (indexPath.row == (self.addDeviceArr.count + 6 - 2)) {
        if (self.serviceHeight == 0 && self.depositHeight == 0) {
            return 48 + 125 + 48 * 2 + 15;
        } else if (self.serviceHeight != 0 && self.depositHeight == 0) {
            return 48 + 125 + 10 + self.serviceHeight + 48 + 5;
        } else if (self.serviceHeight == 0 && self.depositHeight != 0) {
            return 48 + 125 + 10 + self.depositHeight + 48 + 5;
        } else {
            return 48 + 125 + 10 + self.serviceHeight + self.depositHeight + 5;
        }
    } else if (indexPath.row == (self.addDeviceArr.count + 6 - 3)) {
        return 88;
    } else {
        return 195;
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
        JKInstallInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmer;
        cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddress];
        cell.telStr = model.txtPhone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKInstallationOrderCell";
        JKInstallationOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKInstallationOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.installType = self.installType;
        
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKInstallInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKDeviceListCell";
        JKDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKDeviceListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKInstallInfoModel *model = self.dataSource[0];
        cell.type = JKInstallationIng;
        [cell createUI:model];
        return cell;
    } else if (indexPath.row == (self.addDeviceArr.count + 6 - 1)) {
        static NSString *ID = @"EndCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBgColor;
        }
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kWhiteColor;
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(15);
            make.left.right.bottom.equalTo(cell);
        }];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        saveBtn.titleLabel.font = JKFont(15);
        saveBtn.layer.cornerRadius = 4;
        saveBtn.layer.masksToBounds = YES;
        saveBtn.layer.borderColor = kThemeColor.CGColor;
        saveBtn.layer.borderWidth = 1;
        saveBtn.tag = 1;
        [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:saveBtn];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_centerX).offset(-SCALE_SIZE(7.5));
            make.height.mas_equalTo(44);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"结束安装" forState:UIControlStateNormal];
        [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        orderBtn.titleLabel.font = JKFont(15);
        orderBtn.layer.cornerRadius = 4;
        orderBtn.layer.masksToBounds = YES;
        orderBtn.tag = 2;
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_centerX).offset(SCALE_SIZE(7.5));
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        return cell;
    } else if (indexPath.row == (self.addDeviceArr.count + 6 - 2)) {
        static NSString *ID = @"JKResultCell";
        JKInstallationResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKInstallationResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.installType = self.installType;
        cell.isServiceFree = _isServiceOn;
        cell.isDepositFree = _isDepositOn;
        self.irCell = cell;
        return cell;
    } else if (indexPath.row == (self.addDeviceArr.count + 6 - 3)) {
        static NSString *ID = @"AddCell";
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
            make.left.right.bottom.equalTo(cell);
            make.top.equalTo(cell).offset(15);
        }];
        
        UIButton *addKDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addKDBtn setTitle:@"+ 添加KD326设备" forState:UIControlStateNormal];
        [addKDBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [addKDBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [addKDBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        addKDBtn.tag = indexPath.row;
        addKDBtn.layer.cornerRadius = 4;
        addKDBtn.layer.masksToBounds = YES;
        [addKDBtn addTarget:self action:@selector(addKDBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        addKDBtn.titleLabel.font = JKFont(14);
        [bgView addSubview:addKDBtn];
        [addKDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_centerX).offset(-SCALE_SIZE(7.5));
            make.height.mas_equalTo(44);
        }];
        
        UIButton *addQYBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addQYBtn setTitle:@"+ 添加QY601设备" forState:UIControlStateNormal];
        [addQYBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [addQYBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [addQYBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        addQYBtn.tag = indexPath.row;
        addQYBtn.layer.cornerRadius = 4;
        addQYBtn.layer.masksToBounds = YES;
        [addQYBtn addTarget:self action:@selector(addQYBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        addQYBtn.titleLabel.font = JKFont(14);
        [bgView addSubview:addQYBtn];
        [addQYBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_centerX).offset(SCALE_SIZE(7.5));
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        return cell;
    } else {
        NSString *cellIdentifier = @"JKFarmerEquipmentTaskCell";
        JKFarmerEquipmentTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JKFarmerEquipmentTaskCell" owner:nil options:nil] firstObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBgColor;
        }
        cell.tag = indexPath.row;
        cell.backgroundColor = kBgColor;
        cell.delegate = self;
        if (self.addDeviceArr.count != 0) {
            JKDeviceModel *model = self.addDeviceArr[indexPath.row - 3];
            [cell configCellWithModel:model];
        }
        
        return cell;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.addDeviceArr.count==0) {
//        return;
//    }
//    JKDeviceModel *model = self.addDeviceArr[indexPath.row - 3];
//    if ([model.type isEqualToString:@"QY601"]) {
//        JKNewEquipmentInfoVC *eiVC = [[JKNewEquipmentInfoVC alloc] init];
//        eiVC.tskID = model.deviceId;
//        [self.navigationController pushViewController:eiVC animated:YES];
//    }else{
//        JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
//        eiVC.tskID = model.deviceId;
//        [self.navigationController pushViewController:eiVC animated:YES];
//    }
//
//}
@end
