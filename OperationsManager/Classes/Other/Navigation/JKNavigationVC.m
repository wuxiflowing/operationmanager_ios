//
//  JKNavigationVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKNavigationVC.h"
#import "JKRecycedInfoVC.h"
#import "JKRecycingInfoVC.h"
#import "JKRecyceWaitInfoVC.h"
#import "JKMaintainWaitInfoVC.h"
#import "JKMaintainIngInfoVC.h"
#import "JKMaintainedInfoVC.h"
#import "JKMessageVC.h"
@interface JKNavigationVC () <UIGestureRecognizerDelegate>

@end

@implementation JKNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    //设置NavigationBar
    [self setupNavigationBar];
}

#pragma mark -- 设置NavigationBar
- (void)setupNavigationBar {
    UINavigationBar *bar = [UINavigationBar appearance];
    //统一设置导航栏颜色，如果单个界面需要设置，可以在viewWillAppear里面设置，在viewWillDisappear设置回统一格式。
    [bar setBarTintColor:kThemeColor];
    
    //导航栏title格式
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = kWhiteColor;
    textAttribute[NSFontAttributeName] = JKFont(18);
    [bar setTitleTextAttributes:textAttribute];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //返回按钮
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 22)];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        if (@available(iOS 11.0, *)) {
            [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        } else {
            [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        }
        [backBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        UIBarButtonItem *navigationSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if (@available(iOS 11.0, *)) {
            
        } else {
            navigationSpace.width = -15;
        }
        
        viewController.navigationItem.leftBarButtonItems = @[navigationSpace, btnItem];
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark -- 返回
- (void)popView {
    UINavigationController * lastVC = [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
    UINavigationController * fistVC = [self.viewControllers objectAtIndex:0];
    
    NSString * name = NSStringFromClass([lastVC class]);
    
    if ([name isEqualToString:@"JKMaintainIngInfoVC"] || [name isEqualToString:@"JKRecycingInfoVC"]) {
        
        [self popToViewController:[self.viewControllers objectAtIndex:self.viewControllers.count - 3] animated:YES];
        return;
    }
    NSArray * names = @[@"JKRecycedInfoVC",@"JKRecyceWaitInfoVC",@"JKMaintainWaitInfoVC",@"JKMaintainedInfoVC"];
    
    if ([names containsObject:name] && [fistVC isKindOfClass:[JKMessageVC class]])
        [self popToRootViewControllerAnimated:YES];
    else
        [self popViewControllerAnimated:YES];
}

#pragma mark -- 手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count > 1;
}

#pragma mark -- 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
