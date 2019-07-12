//
//  JKMaintainVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMaintainVC.h"
#import "JKMaintainWaitVC.h"
#import "JKMaintainingVC.h"
#import "JKMaintainedVC.h"
#import "JKSearchTaskVC.h"

@interface JKMaintainVC () <XXPageTabViewDelegate>
{
    NSInteger _maintainType;
}
@property (nonatomic, strong) XXPageTabView *pageTabView;

@end

@implementation JKMaintainVC

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
    
    self.title = @"维护任务";
    
    _maintainType = 0;
    
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
    stVC.queryType = @"maintain";
    if (_maintainType == 0) {
        stVC.type = @"prepare";
    } else if (_maintainType == 1) {
        stVC.type = @"ing";
    } else if (_maintainType == 2) {
        stVC.type = @"finish";
    }
    stVC.title = @"维护任务";
    [self.navigationController pushViewController:stVC animated:YES];
}

#pragma mark -- 加载控制器
- (void)addChildVC {
    //待接单
    JKMaintainWaitVC *mwVC = [[JKMaintainWaitVC alloc] init];
    [self addChildViewController:mwVC];
    
    //进行中
    JKMaintainingVC *miVC = [[JKMaintainingVC alloc] init];
    [self addChildViewController:miVC];
    
    //已完成
    JKMaintainedVC *mdVC = [[JKMaintainedVC alloc] init];
    [self addChildViewController:mdVC];
}

#pragma mark -- XXPageTabViewDelegate
- (void)pageTabViewDidEndChange {
    _maintainType = self.pageTabView.selectedTabIndex;
}

- (void)scrollToLast:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex-1];
}

- (void)scrollToNext:(id)sender {
    [self.pageTabView setSelectedTabIndexWithAnimation:self.pageTabView.selectedTabIndex+1];
}

@end
