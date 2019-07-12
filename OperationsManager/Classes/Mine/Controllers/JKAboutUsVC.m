//
//  JKAboutUsVC.m
//  OperationsManager
//
//  Created by    on 2018/10/31.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKAboutUsVC.h"

@interface JKAboutUsVC ()
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation JKAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于我们";
    
    self.imgArr = @[@"麦好渔iOS", @"麦好渔安卓", @"庆渔iOS", @"庆渔安卓", @"养殖管家-iOS", @"养殖管家", @"运维管家-iOS", @"运维管家", @"庆渔堂微信公众号", @"公司鱼粮收款账号"];
    self.titleArr = @[@"麦好渔(iOS)", @"麦好渔(安卓)", @"庆渔(iOS)", @"庆渔(安卓)", @"养殖管家(iOS)", @"养殖管家(安卓)", @"运维管家(iOS)", @"运维管家(安卓)", @"庆渔堂微信公众号", @"公司鱼粮收款账号"];
    
    [self createUI];
}

- (void)createUI {
    CGFloat width = SCREEN_WIDTH / 3 * 2;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = kWhiteColor;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (width + 30) * 10 + 30);
    
    for (NSInteger i = 0; i < self.imgArr.count; i++) {
        NSInteger col = i / 1;
        UIView *bgView = [[UIView alloc] init];
        [scrollView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scrollView).offset((width + 30) * col + 30);
            make.centerX.equalTo(scrollView);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
        
        UIImageView *btnImgV = [[UIImageView alloc] init];
        btnImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[i]]];
        [bgView addSubview:btnImgV];
        [btnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView.mas_centerX);
            make.centerY.equalTo(bgView.mas_centerY).offset(-10);
            make.size.mas_equalTo(CGSizeMake((width - 30), (width - 30)));
        }];
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = self.titleArr[i];
        titleLb.textColor = RGBHex(0x666666);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(14);
//        titleLb.adjustsFontSizeToFitWidth = YES;
        [bgView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView.mas_centerX);
            make.bottom.equalTo(bgView.mas_bottom);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(30);
        }];
    }
}

@end
