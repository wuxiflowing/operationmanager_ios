//
//  JKGuidePagesView.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKGuidePagesView.h"
#import "JKGuidePagesCell.h"

@interface JKGuidePagesView() <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSString *loginBtnTitle;
@property (nonatomic, strong) UIColor *loginBtnTitleColor;
@property (nonatomic, strong) UIColor *loginBtnBgColor;
@property (nonatomic, strong) UIColor *loginBtnBorderColor;
@end

@implementation JKGuidePagesView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = SCREEN_BOUNDS.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_BOUNDS collectionViewLayout:layout];
        _collectionView.backgroundColor = kWhiteColor;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JKGuidePagesCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = kLightGrayColor;
        _pageControl.currentPageIndicatorTintColor = kThemeColor;
        _pageControl.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    }
    return _pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)showGuideViewWithImages:(NSArray *)images
               andLoginBtnTitle:(NSString *)loginBtnTitle
          andLoginBtnTitleColor:(UIColor *)loginBtnTitleColor
             andLoginBtnBgColor:(UIColor *)loginBtnBgColor
         andLoginBtnBorderColor:(UIColor *)loginBtnBorderColor {
    self.images = images;
    self.loginBtnTitle = loginBtnTitle;
    self.loginBtnTitleColor = loginBtnTitleColor;
    self.loginBtnBgColor = loginBtnBgColor;
    self.loginBtnBorderColor = loginBtnBorderColor;
    self.pageControl.numberOfPages = images.count;
    
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-SafeAreaBottomHeight - 50);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKGuidePagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImage *img = [self.images objectAtIndex:indexPath.row];
    CGSize imgSize = [self adaptImageSize:img.size compareScreenSize:SCREEN_BOUNDS.size];
    cell.imageView.frame = CGRectMake(0, 0, imgSize.width, imgSize.height);
    cell.imageView.center = CGPointMake(SCREEN_BOUNDS.size.width / 2, SCREEN_BOUNDS.size.height / 2);
    cell.imageView.image = img;
    
    if (indexPath.row == self.images.count - 1) {
        cell.loginBtn.hidden = NO;
        [cell.loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.loginBtn setTitle:self.loginBtnTitle forState:UIControlStateNormal];
        [cell.loginBtn setTitleColor:self.loginBtnTitleColor forState:UIControlStateNormal];
        cell.loginBtn.backgroundColor = self.loginBtnBgColor;
        cell.loginBtn.layer.borderColor = self.loginBtnBorderColor.CGColor;
        cell.loginBtn.layer.borderWidth = 1;
    } else {
        cell.loginBtn.hidden = YES;
    }
    return cell;
}

#pragma mark -- 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    [self removeAll];
}

#pragma mark -- 销毁控件
- (void)removeAll {
    [self.collectionView removeFromSuperview];
    [self.pageControl removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark -- 适配图片尺寸
- (CGSize)adaptImageSize:(CGSize)imgSize compareScreenSize:(CGSize)screenSize {
    CGFloat width = screenSize.width;
    CGFloat height = screenSize.width / imgSize.width * imgSize.height;
    
    if (height < screenSize.height) {
        width = screenSize.height / height * width;
        height = screenSize.height;
    }
    return CGSizeMake(width, height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / SCREEN_BOUNDS.size.width;
}

@end
