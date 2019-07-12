//
//  JKMaintainInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMaintainInfoVC.h"
#import "JKTaskTopCell.h"
#import "JKMaintainOrderCell.h"
#import "JKMaintainResultCell.h"

@interface JKMaintainInfoVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _cellRow;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JKMaintainInfoVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kClearColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.maintainType == JKMaintainWait) {
        _cellRow = 2;
    } else if (self.maintainType == JKMaintainIng) {
        _cellRow = 4;
    } else if (self.maintainType == JKMaintainEd) {
        _cellRow = 3;
    }
    
    [self.view addSubview:self.tableView];
    if (self.maintainType == JKMaintainWait) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-80);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"接 单" forState:UIControlStateNormal];
        [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        orderBtn.titleLabel.font = JKFont(15);
        orderBtn.layer.cornerRadius = 4;
        orderBtn.layer.masksToBounds = YES;
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-XTopHeight);
            make.left.equalTo(self.view.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(self.view.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        self.tableView.scrollEnabled = NO;
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
}

#pragma mark -- 添加弹起
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    
    [UIView animateWithDuration:1 animations:^ {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-keyboardRect.size.height);
        }];
        
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.bounds.size.height + keyboardRect.size.height) animated:NO];
    }];
}

#pragma mark -- 键盘收回
- (void)keyboardWillHide:(NSNotification *)aNotification {
    [UIView animateWithDuration:1 animations:^ {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.safeAreaTopView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }];
}

#pragma mark -- 接单
- (void)orderBtnClick:(UIButton *)btn {
    if (self.maintainType == JKMaintainWait) {
        NSLog(@"接单");
    } else if (self.maintainType == JKMaintainIng) {
        NSLog(@"结束维护");
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row == 1) {
        return 200;
    } else if (indexPath.row == 2) {
        return 429;
    }  else {
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID = @"JKTaskTopCell";
        JKTaskTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKTaskTopCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"JKMaintainOrderCell";
        JKMaintainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKMaintainOrderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.maintainType = self.maintainType;
//        [cell createUI];
        
        return cell;
        
    } else if (indexPath.row == 2) {
        static NSString *ID = @"JKMaintainResultCell";
        JKMaintainResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[JKMaintainResultCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.maintainType = self.maintainType;
//        [cell createUI];
        return cell;
    } else {
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = kBgColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kBgColor;
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(15);
            make.left.right.bottom.equalTo(cell);
        }];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setTitle:@"结束维护" forState:UIControlStateNormal];
        [orderBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        orderBtn.titleLabel.font = JKFont(15);
        orderBtn.layer.cornerRadius = 4;
        orderBtn.layer.masksToBounds = YES;
        [orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        return cell;
    }
}


@end
