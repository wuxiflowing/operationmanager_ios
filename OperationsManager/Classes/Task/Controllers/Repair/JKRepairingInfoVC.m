//
//  JKRepairingInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/8/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRepairingInfoVC.h"
#import "JKTaskTopCell.h"
#import "JKRepairOrderCell.h"
#import "JKRepairResultCell.h"
#import "JKRepairDeviceCell.h"
#import "JKReplaceEquipmentVC.h"
#import "JKRepaireInfoModel.h"
#import "JKDeviceModel.h"
#import "JKEquipmentInfoVC.h"
#import "JKRepairVC.h"

@interface JKRepairingInfoVC () <UITableViewDelegate, UITableViewDataSource, JKRepairDeviceCellDelegate, JKReplaceEquipmentVCDelegate, JKTaskTopCellDelegate, JKRepairOrderCellDelegate>
{
    BOOL _isNewDevice;
    NSInteger _forRepaireCount;
    NSInteger _forPayCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *nDeviceID;
@property (nonatomic, strong) NSString *oDeviceID;
@property (nonatomic, strong) JKRepairResultCell *rrCell;
@property (nonatomic, strong) NSMutableArray *repairArr;
@property (nonatomic, strong) NSMutableArray *payArr;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, strong) NSString *addrStr;
@end

@implementation JKRepairingInfoVC

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

- (NSMutableArray *)repairArr {
    if (!_repairArr) {
        _repairArr = [[NSMutableArray alloc] init];
    }
    return _repairArr;
}

- (NSMutableArray *)payArr {
    if (!_payArr) {
        _payArr = [[NSMutableArray alloc] init];
    }
    return _payArr;
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
    
    _isNewDevice = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getRepaireTaskInfoList];
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
- (void)getRepaireTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKRepaireInfoModel *model = [[JKRepaireInfoModel alloc] init];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.txtFarmerName = responseObject[@"data"][@"txtFarmerName"];
            model.txtFarmerAddr = responseObject[@"data"][@"txtFarmerAddr"];
            model.txtFarmerPhone = responseObject[@"data"][@"txtFarmerPhone"];
            model.txtPondsName = responseObject[@"data"][@"txtPondsName"];
            model.txtPondAddr = responseObject[@"data"][@"txtPondAddr"];
            model.txtRepairEqpKind = responseObject[@"data"][@"txtRepairEqpKind"];
            model.txtRepairEqpID = responseObject[@"data"][@"txtRepairEqpID"];
            model.txtNewID = responseObject[@"data"][@"txtNewID"];
            model.txtPondPhone = responseObject[@"data"][@"txtPondPhone"];
            model.txtMaintenDetail = responseObject[@"data"][@"txtMaintenDetail"];
            model.txtMatnerMembName = responseObject[@"data"][@"txtMatnerMembName"];
            model.rdoSelfYes = responseObject[@"data"][@"rdoSelfYes"];
            model.txtResMulti = responseObject[@"data"][@"txtResMulti"];
            model.tarResOth = responseObject[@"data"][@"tarResOth"];
            model.txtConMulti = responseObject[@"data"][@"txtConMulti"];
            model.tarConOth = responseObject[@"data"][@"tarConOth"];
            model.tarRemarks = responseObject[@"data"][@"tarRemarks"];
            model.txtRepairFormImg = responseObject[@"data"][@"txtRepairFormImg"];
            model.txtReceiptImg = responseObject[@"data"][@"txtReceiptImg"];
            model.region = responseObject[@"data"][@"region"];
            model.picture = responseObject[@"data"][@"picture"];
            model.txtPondID = responseObject[@"data"][@"txtPondID"];
            model.txtAppRepairImg = responseObject[@"data"][@"txtAppRepairImg"];
            model.txtFormNo = responseObject[@"data"][@"txtFormNo"];
            model.txtMonMembName = responseObject[@"data"][@"txtMonMembName"];
            model.txtHKName = responseObject[@"data"][@"txtHKName"];
            model.latitude = responseObject[@"data"][@"latitude"];
            model.longitude = responseObject[@"data"][@"longitude"];
            self.oDeviceID = model.txtRepairEqpID;
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 跳转第三方地图
- (void)showOtherMap {
    JKRepaireInfoModel *model = self.dataSource[0];
    
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

#pragma mark -- 设备详情
- (void)showDeviceInfo:(NSString *)tskId {
    JKEquipmentInfoVC *eiVC = [[JKEquipmentInfoVC alloc] init];
    eiVC.tskID = tskId;
    [self.navigationController pushViewController:eiVC animated:YES];
}

#pragma mark -- 参数配置
- (void)configurationDeviceInfo:(NSString *)tskId {
    JKRepaireInfoModel *model = [self.dataSource lastObject];
    JKReplaceEquipmentVC *reVC = [[JKReplaceEquipmentVC alloc] init];
    reVC.delegate = self;
    reVC.customerId = model.txtFarmerID;
    reVC.deviceID = tskId;
    reVC.pondId = model.txtPondID;
    reVC.pondName = model.txtPondsName;
    reVC.isSet = YES;
    reVC.isFromRepairVC = YES;
    [self.navigationController pushViewController:reVC animated:YES];
}

#pragma mark -- 结束维修
- (void)orderBtnClick:(UIButton *)btn {
    [self.repairArr removeAllObjects];
    [self.payArr removeAllObjects];
    
    if (self.rrCell.imageFixOrderArr.count == 0 && self.rrCell.imageReceiptArr.count == 0) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.oDeviceID forKey:@"oldDeviceId"];
        if (self.nDeviceID != nil) {
            [dict setObject:self.nDeviceID forKey:@"newDeviceId"];
        }
        if (self.rrCell.chooseSingleTreatment) {
            [dict setObject:@"1" forKey:@"selfYes"];
        } else {
            [dict setObject:@"0" forKey:@"selfYes"];
        }
        
        NSString *result = [self.rrCell.selectResultArr componentsJoinedByString:@","];
        [dict setObject:result forKey:@"resMulti"];
        [dict setObject:self.rrCell.resultTV.text forKey:@"resOth"];
        NSString *content = [self.rrCell.selectContentArr componentsJoinedByString:@","];
        [dict setObject:content forKey:@"conMulti"];
        [dict setObject:self.rrCell.contentTV.text forKey:@"conOth"];
        [dict setObject:self.rrCell.remarkTV.text forKey:@"remarks"];
        if (self.addrStr != nil) {
           [dict setObject:self.addrStr forKey:@"pondAddr"];
        } else {
            [dict setObject:@"" forKey:@"pondAddr"];
        }
        [dict setObject:[NSString stringWithFormat:@"%f",self.lat] forKey:@"latitude"];
        [dict setObject:[NSString stringWithFormat:@"%f",self.lng] forKey:@"longitude"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:dict forKey:@"appData"];
        JKRepaireInfoModel *model = self.dataSource[0];
        [params setObject:model.txtFarmerID forKey:@"farmerId"];
        [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit", kUrl_Base,self.tskID];
        
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
            }
        } withFailureBlock:^(NSError *error) {
            [YJProgressHUD hide];
        }];
    } else {
        if (self.rrCell.imageFixOrderArr.count != 0) {
            [self saveImage:self.rrCell.imageFixOrderArr withImageType:JKImageTypeRepaireFixOrder];
        }
        
        if (self.rrCell.imageReceiptArr.count != 0) {
            [self saveImage:self.rrCell.imageReceiptArr withImageType:JKImageTypeRepaireReceipt];
        }
    }
}

- (void)saveImage:(NSArray *)imgArr withImageType:(JKImageType)imageType {
    [YJProgressHUD showProgressCircleNoValue:@"上传资料中..." inView:self.view];
    if (imageType == JKImageTypeRepaireFixOrder) {
        _forRepaireCount = 0;
        [self getImgArr:imgArr withIndex:_forRepaireCount withType:@"repairPic"];
    } else if (imageType == JKImageTypeRepaireReceipt) {
        _forPayCount = 0;
        [self getImgArr:imgArr withIndex:_forPayCount withType:@"repairFee"];
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
        if ([type isEqualToString:@"repairPic"]) {
            [self.repairArr addObject:responseObject[@"data"]];
            _forRepaireCount++;
            if (_forRepaireCount == self.rrCell.imageFixOrderArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forRepaireCount withType:@"repairPic"];
            }
        } else if ([type isEqualToString:@"repairFee"]) {
            [self.payArr addObject:responseObject[@"data"]];
            _forPayCount++;
            if (_forPayCount == self.rrCell.imageReceiptArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forPayCount withType:@"repairFee"];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)submitInfo {
    if (self.rrCell.imageFixOrderArr.count == self.repairArr.count && self.rrCell.imageReceiptArr.count == self.payArr.count) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.oDeviceID forKey:@"oldDeviceId"];
        if (self.nDeviceID != nil) {
           [dict setObject:self.nDeviceID forKey:@"newDeviceId"];
        }
        if (self.rrCell.chooseSingleTreatment) {
            [dict setObject:@"1" forKey:@"selfYes"];
        } else {
            [dict setObject:@"0" forKey:@"selfYes"];
        }
        
        NSString *result = [self.rrCell.selectResultArr componentsJoinedByString:@","];
        [dict setObject:result forKey:@"resMulti"];
        [dict setObject:self.rrCell.resultTV.text forKey:@"resOth"];
        NSString *content = [self.rrCell.selectContentArr componentsJoinedByString:@","];
        [dict setObject:content forKey:@"conMulti"];
        [dict setObject:self.rrCell.contentTV.text forKey:@"conOth"];
        [dict setObject:self.rrCell.remarkTV.text forKey:@"remarks"];
        if (self.repairArr.count != 0) {
            [dict setObject:self.repairArr forKey:@"repairUrls"];
        }
        if (self.payArr.count != 0) {
            [dict setObject:self.payArr forKey:@"payUrls"];
        }
        if (self.addrStr != nil) {
            [dict setObject:self.addrStr forKey:@"pondAddr"];
        } else {
            [dict setObject:@"" forKey:@"pondAddr"];
        }
        [dict setObject:[NSString stringWithFormat:@"%f",self.lat] forKey:@"latitude"];
        [dict setObject:[NSString stringWithFormat:@"%f",self.lng] forKey:@"longitude"];

        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:dict forKey:@"appData"];
        JKRepaireInfoModel *model = self.dataSource[0];
        [params setObject:model.txtFarmerID forKey:@"farmerId"];
        [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit", kUrl_Base,self.tskID];
        
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for(UIViewController *controller in self.navigationController.viewControllers) {
                        if([controller isKindOfClass:[JKRepairVC class]]) {
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

#pragma mark -- 更换设备
- (void)addNewDevice {
    JKRepaireInfoModel *model = [self.dataSource lastObject];
    JKReplaceEquipmentVC *reVC = [[JKReplaceEquipmentVC alloc] init];
    reVC.type = JKEquipmentInfoTypeRepaire;
    reVC.pondName = model.txtPondsName;
    reVC.delegate = self;
    reVC.isFromRepairVC = YES;
    [self.navigationController pushViewController:reVC animated:YES];
}

- (void)replaceDevice:(JKDeviceModel *)model withPondAddr:(NSString *)pondAddr withLat:(CGFloat)lat withLng:(CGFloat)lng{
    _isNewDevice = YES;
    self.nDeviceID = model.deviceId;
    self.addrStr = pondAddr;
    self.lat = lat;
    self.lng = lng;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else if (indexPath.row == 1) {
        if (self.dataSource.count == 0) {
            return 0;
        }
        JKRepaireInfoModel *model = self.dataSource[0];
        if (model.txtAppRepairImg.length == 0) {
            return 255;
        } else {
            return 370;
        }
    } else if (indexPath.row == 2) {
        return 150;
    } else if (indexPath.row == 3) {
        return 1000;
    } else {
        return 80;
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
        JKRepaireInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmerName;
        cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddr];
        cell.telStr = model.txtFarmerPhone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKRepairOrderCell";
        JKRepairOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRepairOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.repaireType = self.repaireType;
        
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKRepaireInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        if (model.txtAppRepairImg.length != 0) {
            cell.repaireImg = model.txtAppRepairImg;
        }
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKRepairDeviceCell";
        JKRepairDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRepairDeviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        JKRepaireInfoModel *model = self.dataSource[0];
        cell.repaireType = self.repaireType;
        cell.tag = indexPath.row;
        if (_isNewDevice) {
            [cell createUI:self.nDeviceID withNewDevice:_isNewDevice];
        } else {
            [cell createUI:model.txtRepairEqpID withNewDevice:_isNewDevice];
        }
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.row == 3) {
        static NSString *ID = @"JKRepairResultCell";
        JKRepairResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRepairResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        self.rrCell = cell;
        cell.repaireType = self.repaireType;
        [cell createUI];
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
        [orderBtn setTitle:@"结束维修" forState:UIControlStateNormal];
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
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        return cell;
    }
}

@end
