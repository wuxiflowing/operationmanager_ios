//
//  JKRecyceDeviceVC.m
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceDeviceVC.h"

@interface JKRecyceDeviceVC () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _chooseSingle;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, strong) UIButton *yesBtn;
@end

@implementation JKRecyceDeviceVC

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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设备回收";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(296);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"结束回收" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = JKFont(17);
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(SCALE_SIZE(25));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(SCALE_SIZE(44));
    }];
}

#pragma mark -- 结束回收
- (void)submitBtnClick:(UIButton *)btn {
    NSLog(@"结束回收");
}

#pragma mark -- 回收信息是否符合
- (void)singleSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.noBtn.selected = NO;
        } else {
            self.yesBtn.selected = NO;
        }
        _chooseSingle = !_chooseSingle;
    }
    NSLog(@"%d",_chooseSingle);
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 100;
    } else if (indexPath.row == 3) {
        return 100;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = JKFont(13);
    cell.textLabel.textColor = RGBHex(0x333333);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"处理结果";
        cell.textLabel.font = JKFont(15);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"回收信息是否符合";
        
        UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [noBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [noBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [noBtn setTitle:@"  否" forState:UIControlStateNormal];
        [noBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [noBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        noBtn.titleLabel.font = JKFont(13);
        noBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        noBtn.tag = 1;
        noBtn.selected = NO;
        [noBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:noBtn];
        [noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.noBtn = noBtn;
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [yesBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [yesBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [yesBtn setTitle:@"  是" forState:UIControlStateNormal];
        [yesBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [yesBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        yesBtn.titleLabel.font = JKFont(13);
        yesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        yesBtn.tag = 0;
        yesBtn.selected = YES;
        [yesBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:yesBtn];
        [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(self.noBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.yesBtn = yesBtn;
    } else if (indexPath.row == 2) {
        UILabel *remarkLb = [[UILabel alloc] init];
        remarkLb.text = @"备注";
        remarkLb.textColor = RGBHex(0x333333);
        remarkLb.textAlignment = NSTextAlignmentLeft;
        remarkLb.font = JKFont(13);
        [cell addSubview:remarkLb];
        [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(70);
            make.height.mas_equalTo(48);
        }];
        
        UITextView *remarkTV = [[UITextView alloc] init];
        remarkTV.font = JKFont(13);
        remarkTV.textColor = RGBHex(0x666666);
        remarkTV.layer.borderColor = RGBHex(0xdddddd).CGColor;
        remarkTV.layer.borderWidth = 1;
        [remarkTV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
        [cell addSubview:remarkTV];
        [remarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(remarkLb.mas_right);
            make.bottom.equalTo(cell).offset(-10);
        }];
        
    } else {
        UILabel *annexLb = [[UILabel alloc] init];
        annexLb.text = @"附件照片";
        annexLb.textColor = RGBHex(0x333333);
        annexLb.textAlignment = NSTextAlignmentLeft;
        annexLb.font = JKFont(13);
        [cell addSubview:annexLb];
        [annexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(70);
            make.height.mas_equalTo(48);
        }];
    }
    
    return cell;
}


@end
