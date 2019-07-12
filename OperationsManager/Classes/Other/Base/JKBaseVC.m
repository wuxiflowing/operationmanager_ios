//
//  JKBaseVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKBaseVC.h"

@interface JKBaseVC ()

@end

@implementation JKBaseVC

- (UIView *)safeAreaTopView {
    if (_safeAreaTopView == nil) {
        _safeAreaTopView = [[UIView alloc] init];
        _safeAreaTopView.backgroundColor = kClearColor;
    }
    return _safeAreaTopView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;

    [self addTapGestureRecognizer];
    
    [self.view addSubview:self.safeAreaTopView];
    [self.safeAreaTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SafeAreaTopHeight);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchNetwork];
}

- (void)createEmptyImgV {
    [self.imgV removeFromSuperview];
    [self.titleLb removeFromSuperview];
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"ic_emept_page"];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(180, 130));
    }];
    self.imgV = imgV;
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"暂无数据";
    titleLb.textColor = RGBHex(0x666666);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = JKFont(16);
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    self.titleLb = titleLb;
}

#pragma mark -- 监听网络
- (void)fetchNetwork{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = 未知
     AFNetworkReachabilityStatusNotReachable     = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [YJProgressHUD showMsgWithImage:@"似乎已断开与互联网的连接" imageName:iFailPath inview:self.view];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                break;
            default:
                break;
        }
    }];
    //3.开始监听
    [manager startMonitoring];
}

#pragma mark -- 隐藏键盘
- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

@end
