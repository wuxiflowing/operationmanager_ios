//
//  JKInstallationVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKInstallationVC.h"
#import "JKInstallWaitVC.h"
#import "JKInstallingVC.h"
#import "JKInstalledVC.h"
#import "JKSearchTaskVC.h"

@interface JKInstallationVC () <XXPageTabViewDelegate>
{
    NSInteger _installType;
}
@property (nonatomic, strong) XXPageTabView *pageTabView;

@end

@implementation JKInstallationVC

- (XXPageTabView *)pageTabView {
    if (!_pageTabView) {
        _pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:@[@"待接单", @"进行中",@"已完成"]];
        _pageTabView.delegate = self;
        _pageTabView.titleStyle = XXPageTabTitleStyleDefault;
        _pageTabView.indicatorStyle = XXPageTabIndicatorStyleFollowText;
        _pageTabView.selectedColor = kThemeColor;
        _pageTabView.unSelectedColor = RGBHex(0x999999);
        _pageTabView.selectedTabIndex = 0;
        _pageTabView.bodyBounces = NO;
    }
    return _pageTabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"安装任务";
    
    _installType = 0;
    
    [self createNavigationUI];
    
    [self addChildVC];
    [self.view addSubview:self.pageTabView];
    [self.pageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -- 导航栏
- (void)createNavigationUI {
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnClick:)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

#pragma mark -- 搜索
- (void)searchBtnClick:(UIButton *)btn {
    JKSearchTaskVC *stVC = [[JKSearchTaskVC alloc] init];
    stVC.queryType = @"install";
    if (_installType == 0) {
        stVC.type = @"prepare";
    } else if (_installType == 1) {
        stVC.type = @"ing";
    } else if (_installType == 2) {
        stVC.type = @"finish";
    }
    stVC.title = @"安装任务";
    [self.navigationController pushViewController:stVC animated:YES];
}

#pragma mark -- 加载控制器
- (void)addChildVC {
    //待接单
    JKInstallWaitVC *iwVC = [[JKInstallWaitVC alloc] init];
    [self addChildViewController:iwVC];
    
    //进行中
    JKInstallingVC *iiVC = [[JKInstallingVC alloc] init];
    [self addChildViewController:iiVC];
    
    //已完成
    JKInstalledVC *idVC = [[JKInstalledVC alloc] init];
    [self addChildViewController:idVC];
}

#pragma mark -- XXPageTabViewDelegate
- (void)pageTabViewDidEndChange {
    _installType = self.pageTabView.selectedTabIndex;
}

- (void)scrollToLast:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex-1];
}

- (void)scrollToNext:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex+1];
}

@end
