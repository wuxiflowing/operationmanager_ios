//
//  JKChooseEquipmentChartView.m
//  OperationsManager
//
//  Created by    on 2018/9/19.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKChooseEquipmentChartView.h"

@interface JKChooseEquipmentChartView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation JKChooseEquipmentChartView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]init];
        _coverView.backgroundColor = kBlackColor;
        _coverView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleClick)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.titleArr = @[@"溶氧曲线", @"温度曲线", @"PH值曲线"];
        
        [self addSubview:self.coverView]; //蒙版
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kClearColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH *0.7);
        make.height.mas_equalTo(144);
    }];
    
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(bgView);
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = self.titleArr[indexPath.row];
    titleLb.textColor = RGBHex(0x333333);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = JKFont(16);
    [cell addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(cell);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title;
    if (indexPath.row == 0) {
        title = @"溶氧曲线";
    } else if (indexPath.row == 1) {
        title = @"温度曲线";
    } else {
        title = @"PH值曲线";
    }
    if ([_delegate respondsToSelector:@selector(chooseChartTitle:)]) {
        [_delegate chooseChartTitle:title];
    }
    [self cancleView];
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma mark -- 关闭
- (void)cancleClick {
    [self cancleView];
}

#pragma mark -- 移除
- (void)cancleView {
    [UIView animateWithDuration:0 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
