//
//  JKLocationVC.m
//  OperationsManager
//
//  Created by    on 2018/9/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKLocationVC.h"
#import "CoreLocation/CoreLocation.h"

@interface JKLocationVC () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation JKLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
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
    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    [JKNotificationCenter postNotification:[NSNotification notificationWithName:@"CurrentLatAndLngNotification" object:nil userInfo:@{@"lat":[NSString stringWithFormat:@"%f",newCoordinate.latitude], @"lng":[NSString stringWithFormat:@"%f",newCoordinate.longitude]}]];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}


@end
