//
//  JKRepaireWaitInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/8/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRepaireWaitInfoVC.h"
#import "JKTaskTopCell.h"
#import "JKRepairOrderCell.h"
#import "JKRepaireInfoModel.h"
#import "JKRepairingInfoVC.h"

@interface JKRepaireWaitInfoVC () <UITableViewDelegate, UITableViewDataSource, JKTaskTopCellDelegate, JKRepairOrderCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JKRepaireWaitInfoVC

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
    
    self.title = @"任务详情";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-70);
    }];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderBtn setTitle:@"接 单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
    orderBtn.titleLabel.font = JKFont(15);
    orderBtn.layer.cornerRadius = 4;
    orderBtn.layer.masksToBounds = YES;
    [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-XTopHeight);
        make.left.equalTo(self.view.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(44);
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
            model.txtAppRepairImg = responseObject[@"data"][@"txtAppRepairImg"];
            model.txtFormNo = responseObject[@"data"][@"txtFormNo"];
            model.txtMonMembName = responseObject[@"data"][@"txtMonMembName"];
            model.txtHKName = responseObject[@"data"][@"txtHKName"];
            model.latitude = responseObject[@"data"][@"latitude"];
            model.longitude = responseObject[@"data"][@"longitude"];
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


#pragma mark -- 接单
- (void)orderBtnClick:(UIButton *)btn {
    if (self.repaireType == JKRepaireWait) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确认接单?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self getTask];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (self.repaireType == JKRepaireIng) {
        NSLog(@"结束维护");
    }
}

#pragma mark -- 接单
- (void)getTask {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/mytask/%@/getTask",kUrl_Base,self.tskID];
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            
            JKRepairingInfoVC *riVC = [[JKRepairingInfoVC alloc] init];
            riVC.repaireType = JKRepaireIng;
            riVC.tskID = self.tskID;
            [self.navigationController pushViewController:riVC animated:YES];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else {
        if (self.dataSource.count == 0) {
            return 0;
        }
        JKRepaireInfoModel *model = self.dataSource[0];
        if (model.txtAppRepairImg.length == 0) {
            return 255;
        } else {
            return 370;
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
        JKRepaireInfoModel *model = self.dataSource[0];
        cell.headImgStr = model.picture;
        cell.nameLb.text = model.txtFarmerName;
        cell.addrLb.text = [NSString stringWithFormat:@"%@", model.txtFarmerAddr];
        cell.telStr = model.txtFarmerPhone;
        cell.delegate = self;
        return cell;
    } else {
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
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[JKRepaireWaitInfoVC class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}

@end
