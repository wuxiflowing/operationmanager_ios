//
//  JKInstalledInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/8/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKInstalledInfoVC.h"
#import "JKTaskTopCell.h"
#import "JKInstallationOrderCell.h"
#import "JKDeviceListCell.h"
#import "JKInstallInfoModel.h"
#import "JKAddDeviceCell.h"
#import "JKInstallationedResultCell.h"
#import "JKEquipmentInfoVC.h"

@interface JKInstalledInfoVC () <UITableViewDelegate, UITableViewDataSource, JKDeviceListCellDelegate, JKTaskTopCellDelegate, JKInstallationOrderCellDelegate>
{
    BOOL _hasPayServiceFree;
    BOOL _hasPayDepositFree;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JKInstalledInfoVC

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
    
    self.title = @"任务详情";
    
    _hasPayServiceFree = NO;
    _hasPayDepositFree = NO;

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
            model.tabEquipmentBindPond = responseObject[@"data"][@"tabEquipmentBindPond"];
            model.txtRelaceAmoutS = responseObject[@"data"][@"txtRelaceAmoutS"];
            model.txtRelaceAmoutD = responseObject[@"data"][@"txtRelaceAmoutD"];
            model.calInstallationTime = responseObject[@"data"][@"calInstallationTime"];
            model.calDispatchTime = responseObject[@"data"][@"calDispatchTime"];
            model.calInstallationTime = responseObject[@"data"][@"calInstallationTime"];
            model.txtUrls = responseObject[@"data"][@"txtUrls"];
            model.txtPaymentMethodS = responseObject[@"data"][@"txtPaymentMethodS"];
            model.txtNoteS = responseObject[@"data"][@"txtNoteS"];
            model.txtPaymentUrlS = responseObject[@"data"][@"txtPaymentUrlS"];
            model.txtPaymentMethodD = responseObject[@"data"][@"txtPaymentMethodD"];
            model.txtNoteD = responseObject[@"data"][@"txtNoteD"];
            model.txtPaymentUrlD = responseObject[@"data"][@"txtPaymentUrlD"];
            model.region = responseObject[@"data"][@"region"];
            model.picture = responseObject[@"data"][@"picture"];
            model.txtFarmerManager = responseObject[@"data"][@"txtFarmerManager"];
            model.txtDepositRemark = responseObject[@"data"][@"txtDepositRemark"];
            model.txtServiceRemark = responseObject[@"data"][@"txtServiceRemark"];
            model.latitude = responseObject[@"data"][@"latitude"];
            model.longitude = responseObject[@"data"][@"longitude"];
            model.txtReciptTime = responseObject[@"data"][@"txtReciptTime"];
            if ([model.txtRelaceAmoutS isEqualToString:@"0"]) {
                _hasPayServiceFree = NO;
            } else {
                _hasPayServiceFree = YES;
            }
            if ([model.txtRelaceAmoutD isEqualToString:@"0"]) {
                _hasPayDepositFree = NO;
            } else {
                _hasPayDepositFree = YES;
            }
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

#pragma mark -- 查看设备详情
- (void)checkEquipmentInfo:(JKInstallInfoModel *)model withTag:(NSInteger)tag{
    JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
    eiVC.tskID = model.tabEquipmentBindPond[tag - 1][@"ITEM1"];
    [self.navigationController pushViewController:eiVC animated:YES];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
        if (model.tabEquipmentBindPond.count == 0) {
            return 96 + 10;
        } else {
            return 48 * (model.tabEquipmentBindPond.count + 1) + 10;
        }
    } else {
        if (_hasPayServiceFree && _hasPayDepositFree) {
            return 666;
        } else if (!_hasPayServiceFree && !_hasPayDepositFree) {
            return 386;
        } else {
            return 526;
        }
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
        cell.type = JKInstallationEd;
        cell.delegate = self;
        [cell createUI:model];

        return cell;
    } else {
        static NSString *ID = @"JKInstallationedResultCell";
        JKInstallationedResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKInstallationedResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.hasPayDepositFree = _hasPayDepositFree;
        cell.hasPayServiceFree = _hasPayServiceFree;
        if (self.dataSource.count != 0) {
            JKInstallInfoModel *model = self.dataSource[0];
            [cell getModel:model];
        }
        return cell;
    }
}
@end
