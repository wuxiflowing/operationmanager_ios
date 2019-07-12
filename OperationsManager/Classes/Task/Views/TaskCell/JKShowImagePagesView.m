//
//  JKShowImagePagesView.m
//  BusinessManager
//
//  Created by    on 2018/9/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKShowImagePagesView.h"
#import "JKShowImagesCell.h"

@interface JKShowImagePagesView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@end

@implementation JKShowImagePagesView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = kBlackColor;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JKShowImagesCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)showGuideViewWithImages:(NSArray *)images withTag:(NSInteger)tag {
    self.images = images;
    [self layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self addSubview:self.collectionView];
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
    JKShowImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.titleLb.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1, self.images.count];
    if ([self.images[indexPath.row] hasPrefix:@"http"]) {
        cell.imageView.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.images[indexPath.row]]];
    } else {
        cell.imageView.image = [UIImage imageWithContentsOfFile:self.images[indexPath.row]];
    }
    [cell.imageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)btnClick:(UIButton *)btn {
    [self removeAll];
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
}

#pragma mark -- 销毁控件
- (void)removeAll {
    [self.collectionView removeFromSuperview];
    [self removeFromSuperview];
}

@end
