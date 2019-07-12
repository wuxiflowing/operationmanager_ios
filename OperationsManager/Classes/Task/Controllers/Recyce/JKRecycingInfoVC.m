//
//  JKRecycingInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/10/30.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecycingInfoVC.h"
#import "JKTaskTopCell.h"
#import "JKRecyceOrderCell.h"
#import "JKRecyceDeviceCell.h"
#import "JKRecyceInfoModel.h"
#import "JKRecyceResultCell.h"
#import "JKRecyceUntiedView.h"
#import "JKScanVC.h"
#import "JKUnitedDeviceModel.h"
#import "JKRecyceVC.h"

@interface JKRecycingInfoVC () <UITableViewDelegate, UITableViewDataSource, JKRecyceDeviceCellDelegate, JKTaskTopCellDelegate, JKRecyceUntiedViewDelegate, JKScanVCDelegate, JKRecyceOrderCellDelegate>
{
    NSInteger _forPhotoCount;
    NSInteger _forOrderCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *imgPhotoArr;
@property (nonatomic, strong) NSMutableArray *imgOrderArr;
@property (nonatomic, strong) NSMutableArray *untiedDeviceArr;
@property (nonatomic, strong) JKRecyceResultCell *rrCell;
@property (nonatomic, strong) NSMutableArray *deciceArr;
@end

@implementation JKRecycingInfoVC

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

- (NSMutableArray *)deciceArr {
    if (!_deciceArr) {
        _deciceArr = [[NSMutableArray alloc] init];
    }
    return _deciceArr;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)imgPhotoArr {
    if (!_imgPhotoArr) {
        _imgPhotoArr = [[NSMutableArray alloc] init];
    }
    return _imgPhotoArr;
}

- (NSMutableArray *)imgOrderArr {
    if (!_imgOrderArr) {
        _imgOrderArr = [[NSMutableArray alloc] init];
    }
    return _imgOrderArr;
}

- (NSMutableArray *)untiedDeviceArr {
    if (!_untiedDeviceArr) {
        _untiedDeviceArr = [[NSMutableArray alloc] init];
    }
    return _untiedDeviceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"任务详情";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self getRecyceTaskInfoList];
}

#pragma mark -- 确认回收/接单
- (void)orderBtnClick:(UIButton *)btn {
    [self.imgPhotoArr removeAllObjects];
    [self.imgOrderArr removeAllObjects];

    JKRecyceInfoModel *model = self.dataSource[0];
    if (self.untiedDeviceArr.count != model.tarEqps.count) {
        [YJProgressHUD showMessage:@"请解绑所有设备" inView:self.view];
        return;
    }

    if (self.rrCell.imagePhotoArr.count == 0 && self.rrCell.imageOrderArr.count == 0) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(self.rrCell.chooseSingle) forKey:@"isGood"];
        if (self.rrCell.descriptionLbTV.text.length == 0) {
            [dict setObject:@"" forKey:@"explain"];
        } else {
            [dict setObject:self.rrCell.descriptionLbTV.text forKey:@"explain"];
        }
        if (self.rrCell.remarkTV.text.length == 0) {
            [dict setObject:@"" forKey:@"remarks"];
        } else {
            [dict setObject:self.rrCell.remarkTV.text forKey:@"remarks"];
        }

        [dict setObject:@"" forKey:@"recycleUrls"];
        [dict setObject:@"" forKey:@"brokenUrls"];

        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:dict forKey:@"appData"];
        [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];

        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit", kUrl_Base,self.tskID];

        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:@"提交成功" inView:self.view];
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
        if (self.rrCell.imagePhotoArr.count != 0) {
            [self saveImage:self.rrCell.imagePhotoArr withImageType:JKImageTypeRecyceDevicePhoto];
        }

        if (self.rrCell.imageOrderArr.count != 0) {
            [self saveImage:self.rrCell.imageOrderArr withImageType:JKImageTypeRecyceDeviceOrder];
        }
    }
    
//    JKRecyceView *alertV = [[JKRecyceView alloc] initWithFrame:self.view.frame];
//    [alertV alertViewInView:self.view WithTitle:@"确认回收" withContent:@"计划回收设备3套，实际回收设备2套，\n是否确认回收？"];
}


- (void)saveImage:(NSArray *)imgArr withImageType:(JKImageType)imageType {
    [YJProgressHUD showProgressCircleNoValue:@"结束回收中..." inView:self.view];
    if (imageType == JKImageTypeRecyceDevicePhoto) {
        _forPhotoCount = 0;
        [self getImgArr:imgArr withIndex:_forPhotoCount withType:@"recyclingPic"];
    } else if (imageType == JKImageTypeRecyceDeviceOrder) {
        _forOrderCount = 0;
        [self getImgArr:imgArr withIndex:_forOrderCount withType:@"recyclingForm"];
    }
}

- (void)getImgArr:(NSArray *)imgArr withIndex:(NSInteger)tag withType:(NSString *)type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:type forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%ld.jpg",(long)[JKToolKit getNowTimestamp]] forKey:@"imageName"];
    [params setObject:[JKToolKit imageToString:imgArr[tag]] forKey:@"imageData"];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/%@/uploadImage", kUrl_Base, loginId];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        if ([type isEqualToString:@"recyclingPic"]) {
            [self.imgPhotoArr addObject:responseObject[@"data"]];
            _forPhotoCount++;
            if (_forPhotoCount == self.rrCell.imagePhotoArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forPhotoCount withType:@"recyclingPic"];
            }
        } else if ([type isEqualToString:@"recyclingForm"]) {
            [self.imgOrderArr addObject:responseObject[@"data"]];
            _forOrderCount++;
            if (_forOrderCount == self.rrCell.imageOrderArr.count) {
                [self submitInfo];
            } else {
                [self getImgArr:imgArr withIndex:_forOrderCount withType:@"recyclingForm"];
            }
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)submitInfo  {
    if (self.rrCell.imagePhotoArr.count == self.imgPhotoArr.count && self.rrCell.imageOrderArr.count == self.imgOrderArr.count) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(self.rrCell.chooseSingle) forKey:@"isGood"];
        if (self.rrCell.descriptionLbTV.text.length == 0) {
            [dict setObject:@"" forKey:@"explain"];
        } else {
            [dict setObject:self.rrCell.descriptionLbTV.text forKey:@"explain"];
        }
        if (self.rrCell.remarkTV.text.length == 0) {
            [dict setObject:@"" forKey:@"remarks"];
        } else {
            [dict setObject:self.rrCell.remarkTV.text forKey:@"remarks"];
        }
        
        if (self.imgOrderArr.count == 0) {
            [dict setObject:@"" forKey:@"recycleUrls"];
        } else {
            [dict setObject:self.imgOrderArr forKey:@"recycleUrls"];
        }
        if (self.imgPhotoArr.count == 0) {
            [dict setObject:@"" forKey:@"brokenUrls"];
        } else {
            [dict setObject:self.imgPhotoArr forKey:@"brokenUrls"];
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:dict forKey:@"appData"];
        [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/device/%@/submit", kUrl_Base,self.tskID];
        
        [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
            [YJProgressHUD hide];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for(UIViewController *controller in self.navigationController.viewControllers) {
                        if([controller isKindOfClass:[JKRecyceVC class]]) {
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

#pragma mark -- 解绑设备
- (void)untiedDeviceWithIdent:(NSString *)ident withPondName:(NSString *)pondName withIsSelected:(NSInteger)isSelected withBtnTag:(NSInteger)tag {
    JKRecyceUntiedView *ruV = [[JKRecyceUntiedView alloc] initWithFrame:self.view.frame withIdent:ident withPondName:pondName withPondIndex:tag];
    ruV.delegate = self;
    [ruV alertViewInView:self.view];
}

- (void)unitiedDevice:(NSString *)ident withDeviceIndex:(NSInteger)index{
    JKRecyceInfoModel *model = self.dataSource[0];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/device/%@/recycle/from/group/%@",kUrl_Base,ident, model.txtPondID];
    [YJProgressHUD showProgressCircleNoValue:@"解绑中..." inView:self.view];
    [[JKHttpTool shareInstance] DeleteReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        [self.untiedDeviceArr addObject:ident];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            [YJProgressHUD showMessage:@"提交成功" inView:self.view];
        } else {
            if ([responseObject[@"message"] isEqualToString:@"删除失败"]) {
                [YJProgressHUD showMessage:@"该设备已解绑" inView:self.view];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"unitiedState" object:nil userInfo:@{@"index":@(index)}]];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 扫描
- (void)scanDeviceIdent {
    JKScanVC *sVC = [[JKScanVC alloc] init];
    sVC.delegate = self;
    [self.navigationController pushViewController:sVC animated:YES];
}

- (void)showDeviceId:(NSString *)deviceId {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"scanDeviceId" object:nil userInfo:@{@"deviceId":deviceId}]];
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
- (void)getRecyceTaskInfoList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/data",kUrl_Base,self.tskID];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            JKRecyceInfoModel *model = [[JKRecyceInfoModel alloc] init];
            model.txtPondPhone = responseObject[@"data"][@"txtPondPhone"];
            model.txtPondName = responseObject[@"data"][@"txtPondName"];
            model.txtPondID = responseObject[@"data"][@"txtPondID"];
            model.txtPondAddr = responseObject[@"data"][@"txtPondAddr"];
            model.txtFarmerName = responseObject[@"data"][@"txtFarmerName"];
            model.txtFarmerAddr = responseObject[@"data"][@"txtFarmerAddr"];
            model.txtHKID = responseObject[@"data"][@"txtHKID"];
            model.txtHKPhone = responseObject[@"data"][@"txtHKPhone"];
            model.txtFarmerPhone = responseObject[@"data"][@"txtFarmerPhone"];
            model.txtFormNo = responseObject[@"data"][@"txtFormNo"];
            model.txtFarmerID = responseObject[@"data"][@"txtFarmerID"];
            model.txtMatnerMembNo = responseObject[@"data"][@"txtMatnerMembNo"];
            model.txtMatnerMembName = responseObject[@"data"][@"txtMatnerMembName"];
            model.picture = responseObject[@"data"][@"picture"];
            model.latitude = responseObject[@"data"][@"latitude"];
            model.longitude = responseObject[@"data"][@"longitude"];
            model.region = responseObject[@"data"][@"region"];
            model.txtResMulti = responseObject[@"data"][@"txtResMulti"];
            model.tarRemarks = responseObject[@"data"][@"tarReson"];
            model.tarEqps = responseObject[@"data"][@"tarEqps"];
            model.txtHK = responseObject[@"data"][@"txtHK"];
            for (NSDictionary *dict in model.tarEqps) {
                JKUnitedDeviceModel *models = [[JKUnitedDeviceModel alloc] init];
                models.ident = dict[@"ITEM2"];
                models.name = dict[@"ITEM5"];
                models.isSelect = NO;
                [self.deciceArr addObject:models];
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
    JKRecyceInfoModel *model = self.dataSource[0];
    
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

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else if (indexPath.row == 1) {
        return 290;
    } else if (indexPath.row == 2) {
        if (self.dataSource.count == 0) {
            return 48 + 15;
        }
        
        JKRecyceInfoModel *model = self.dataSource[0];
        return model.tarEqps.count * 48 + 48 + 15;
    } else if (indexPath.row == 3) {
        return 611;
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
        
        JKRecyceInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmerName;
        cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddr];
        cell.telStr = model.txtFarmerPhone;
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKRecyceOrderCell";
        JKRecyceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        
        cell.recyceType = self.recyceType;
        JKRecyceInfoModel *model = self.dataSource[0];
        [cell createUI:model];
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKRecyceDeviceCell";
        JKRecyceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceDeviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        
//        JKRecyceInfoModel *model = self.dataSource[0];
        cell.dataSource = self.deciceArr;
        cell.recyceType = self.recyceType;
        cell.delegate = self;

        return cell;
    } else if (indexPath.row == 3) {
        static NSString *ID = @"JKRecyceResultCell";
        JKRecyceResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKRecyceResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.recyceType = self.recyceType;
        self.rrCell = cell;
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
            make.top.equalTo(cell).offset(5);
            make.left.right.bottom.equalTo(cell);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"确认回收" forState:UIControlStateNormal];
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
