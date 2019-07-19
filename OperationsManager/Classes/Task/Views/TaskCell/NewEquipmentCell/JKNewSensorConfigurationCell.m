//
//  JKSensorConfigurationCell.m
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKNewSensorConfigurationCell.h"
#import "JKDeviceModel.h"

@interface JKNewSensorConfigurationCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placeholderArr;
@property (nonatomic, strong) UIButton *lineBtn;
@property (nonatomic, strong) UIButton *noLineBtn;
@property (nonatomic, strong) UIButton *matchBtn;
@property (nonatomic, strong) UITextField *alertlineOneTF;
@property (nonatomic, strong) UITextField *alertlineTwoTF;

@end

@implementation JKNewSensorConfigurationCell

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        self.titleArr = @[@"传感器配置",@"选择连接方式",@"警报线1",@"警报线2"];
        self.placeholderArr = @[@"", @"",@"请输入警报线1", @"请输入警报线2"];
        self.connectionType = 1;
        [self createUI];
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        return;
    }
    
    JKDeviceModel *model = _dataSource[0];
    self.alertlineOneStr = [NSString stringWithFormat:@"%.2f",model.alertlineOne];
    self.alertlineTwoStr = [NSString stringWithFormat:@"%.2f",model.alertlineTwo];
    self.connectionType = model.connectionType;
    [self.tableView reloadData];
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    if (_dataSource.count == 0) {
        return;
    }
    JKDeviceModel *model = _dataSource[0];
    UITextField *textField = (UITextField *)[notification object];
    if (textField.tag == 2) {
        self.alertlineOneStr = textField.text;
        model.alertlineOne = [self.alertlineOneStr floatValue];
    } else if (textField.tag == 3) {
        self.alertlineTwoStr = textField.text;
        model.alertlineTwo = [self.alertlineTwoStr floatValue];
    }
    [_delegate changeSensorConfigurationSetting:self.dataSource];
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(bgView);
    }];
}

#pragma mark -- 控制类型
- (void)singleSelected:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    
    btn.selected = !btn.selected;
    if (btn.tag == 0) {
        self.noLineBtn.selected = NO;
        self.connectionType = 1;
    } else {
        self.lineBtn.selected = NO;
        self.connectionType = 0;
    }
    
    if (_dataSource.count != 0) {
        JKDeviceModel *model = _dataSource[0];
        model.connectionType = self.connectionType;
    }
    if (self.connectionType) {
        self.matchBtn.enabled = NO;
    }else{
        self.matchBtn.enabled = YES;
    }

}

- (void)btnMatchingClick:(UIButton *)btn{
    if (_dataSource.count == 0) {
        return;
    }
    if (self.matchingBlock) {
        self.matchingBlock(self.connectionType);
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = JKFont(14);
    cell.detailTextLabel.font = JKFont(14);
    
    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        [self.lineBtn removeFromSuperview];
        UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lineBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [lineBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [lineBtn setTitle:@"  有线" forState:UIControlStateNormal];
        [lineBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [lineBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        lineBtn.titleLabel.font = JKFont(14);
        lineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        lineBtn.tag = 0;
        if (self.connectionType) {
            lineBtn.selected = YES;
        } else {
            lineBtn.selected = NO;
        }
        [lineBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:lineBtn];
        [lineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(cell.textLabel.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.lineBtn = lineBtn;
        
        [self.noLineBtn  removeFromSuperview];
        UIButton *noLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [noLineBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [noLineBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [noLineBtn setTitle:@"  无线" forState:UIControlStateNormal];
        [noLineBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [noLineBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        noLineBtn.titleLabel.font = JKFont(14);
        noLineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        noLineBtn.tag = 1;
        if (self.connectionType) {
            noLineBtn.selected = NO;
        } else {
            noLineBtn.selected = YES;
        }
        [noLineBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:noLineBtn];
        [noLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(lineBtn.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.noLineBtn = noLineBtn;
        
        [self.matchBtn  removeFromSuperview];
        UIButton *matchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [matchBtn setTitle:@"配对" forState:UIControlStateNormal];
        [matchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        matchBtn.titleLabel.font = JKFont(14);
        matchBtn.layer.cornerRadius = 4;
        matchBtn.layer.masksToBounds = YES;
        [matchBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [matchBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [matchBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        [matchBtn addTarget:self action:@selector(btnMatchingClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.connectionType) {
            matchBtn.enabled = NO;
        }else{
            matchBtn.enabled = YES;
        }
        [cell addSubview:matchBtn];
        [matchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(noLineBtn.mas_right).offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.matchBtn = matchBtn;

    } else {
        cell.detailTextLabel.text = @"mg/L";
        
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = RGBHex(0x333333);
        textField.placeholder = self.placeholderArr[indexPath.row];
        textField.textAlignment = NSTextAlignmentRight;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.font = JKFont(14);
        textField.tag = indexPath.row;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
        [cell addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.detailTextLabel.mas_centerY);
            make.right.equalTo(cell.detailTextLabel.mas_left).offset(-5);
            make.width.mas_offset(100);
            make.height.mas_equalTo(30);
        }];
        
        if (indexPath.row == 2) {
            [self.alertlineOneTF removeFromSuperview];
            self.alertlineOneTF = textField;
            if (self.alertlineOneStr != nil) {
                self.alertlineOneTF.text = self.alertlineOneStr;
            }
        } else if (indexPath.row == 3) {
            [self.alertlineTwoTF removeFromSuperview];
            self.alertlineTwoTF = textField;
            if (self.alertlineTwoStr != nil) {
                self.alertlineTwoTF.text = self.alertlineTwoStr;
            }
        }
        
    }
    

    
    return cell;
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
