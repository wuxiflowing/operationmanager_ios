//
//  AppDelegate.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "AppDelegate.h"
#import "JKGuidePagesView.h"
#import <GTSDK/GeTuiSdk.h>

#import <BaiduMapAPI_Base/BMKMapManager.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define BaiduMapAK @"23n3ZmwHQoD6MmZLdaIcrMLBu9GoZrBG"

@interface AppDelegate () <GeTuiSdkDelegate, UNUserNotificationCenterDelegate, BMKGeneralDelegate>
@property (nonatomic, strong) JKTabBarVC *tabBarVC;
@property (nonatomic, strong) BMKMapManager *mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //Bugly
    [Bugly startWithAppId:@"c477803690"];
    
    //[GTSdk]：使用APPID/APPKEY/APPSECRENT启动个推
    
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    //注册APNs
    [self registerRemoteNotification];
    
    [self initIQKeyboardManager];
    
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    if (loginId != nil) {
        [self setUpTabBarController];
    } else {
        [self setUpLoginViewController];
    }
    
    //百度地图
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:BaiduMapAK generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [GeTuiSdk setBadge:0];

    [self hsUpdateApp];
    
    return YES;
}

#pragma mark -- 显示TabBar
- (void)setUpTabBarController {
    JKTabBarVC *tabBarVC = [[JKTabBarVC alloc] init];
    tabBarVC.selectedIndex = 1;
    [self.window setRootViewController:tabBarVC];
    self.tabBarVC = tabBarVC;
}

#pragma mark -- 显示LoginVC
- (void)setUpLoginViewController {
    JKLoginVC *lVC = [[JKLoginVC alloc] init];
    JKNavigationVC *navi = [[JKNavigationVC alloc] initWithRootViewController:lVC];
    [self.window setRootViewController:navi];
}

#pragma mark -- IQKeyboardManager
- (void)initIQKeyboardManager {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = JKFont(15); // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    keyboardManager.toolbarTintColor = kThemeColor;
}

#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // [ GTSdk ]：Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 用户通知(推送) _自定义方法
/** 注册远程通知 */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/** APP已经接收到“远程”通知(推送) - (App运行在后台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // 显示APNs信息到页面
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - iOS 10中收到推送消息
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);

    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);

    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}
#endif

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [JKUserDefaults setObject:clientId forKey:@"gtToken"];
    
}

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",payloadMsg);
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 页面显示：上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"%@",record);
}

#pragma mark -- 百度地图联网成功
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        //                NSLog(@"联网成功");
    } else {
        NSLog(@"onGetNetworkState %d",iError);
    }
}

#pragma mark -- 百度地图授权成功
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        //                NSLog(@"授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark -- 检测app更新
-(void)hsUpdateApp {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:API_KEY forKey:@"_api_key"];
    [params setObject:APP_KEY forKey:@"appKey"];
    
    NSString *urlStr = @"https://www.pgyer.com/apiv2/app/check";
    
    [[JKHttpTool shareInstance] PostPgyerReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        NSString *buildVersion = responseObject[@"data"][@"buildVersion"];
        if (buildVersion == nil) {
            return;
        }
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
        if([currentVersion compare:buildVersion] == NSOrderedAscending) {
            NSString *message = [NSString stringWithFormat:@"检测到新版本(v%@),是否更新?",buildVersion];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本有更新" message:message preferredStyle:UIAlertControllerStyleAlert];
            
//            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSString *buildShortcutUrl = responseObject[@"data"][@"buildShortcutUrl"];
                NSURL *url = [NSURL URLWithString:buildShortcutUrl];
                [[UIApplication sharedApplication] openURL:url];
            }]];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        } else {
            NSLog(@"版本号好像比商店大噢!检测到不需要更新");
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [GeTuiSdk setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
