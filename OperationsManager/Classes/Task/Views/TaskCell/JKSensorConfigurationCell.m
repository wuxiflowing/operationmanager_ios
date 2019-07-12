//
//  JKSensorConfigurationCell.m
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKSensorConfigurationCell.h"
#import "JKDeviceModel.h"

@interface JKSensorConfigurationCell () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _chooseSingle;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placeholderArr;
@property (nonatomic, strong) UIButton *manualBtn;
@property (nonatomic, strong) UIButton *automaticBtn;
@property (nonatomic, strong) UITextField *oxyLimitUpTF;
@property (nonatomic, strong) UITextField *oxyLimitDownOneTF;
@property (nonatomic, strong) UITextField *oxyLimitDownTwoTF;
@property (nonatomic, strong) UITextField *alertlineOneTF;
@property (nonatomic, strong) UITextField *alertlineTwoTF;

@end

@implementation JKSensorConfigurationCell

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
        
        self.titleArr = @[@"传感器配置",@"上限",@"下限1",@"下限2",@"警报线1",@"警报线2",@"控制类型"];
        self.placeholderArr = @[@"", @"请输入上限", @"请输入下限1", @"请输入下限2", @"请输入警报线1", @"请输入警报线2", @""];
        self.isAutomatic = YES;
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
    self.oxyLimitUpStr = [NSString stringWithFormat:@"%.2f",model.oxyLimitUp];
    self.oxyLimitDownOneStr = [NSString stringWithFormat:@"%.2f",model.oxyLimitDownOne];
    self.oxyLimitDownTwoStr = [NSString stringWithFormat:@"%.2f",model.oxyLimitDownTwo];
    self.alertlineOneStr = [NSString stringWithFormat:@"%.2f",model.alertlineOne];
    self.alertlineTwoStr = [NSString stringWithFormat:@"%.2f",model.alertlineTwo];
    self.isAutomatic = [model.automatic boolValue];
    [self.tableView reloadData];
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    if (_dataSource.count == 0) {
        return;
    }
    JKDeviceModel *model = _dataSource[0];
    UITextField *textField = (UITextField *)[notification object];
    if (textField.tag == 1) {
        self.oxyLimitUpStr = textField.text;
        model.oxyLimitUp = [self.oxyLimitUpStr floatValue];
    } else if (textField.tag == 2) {
        self.oxyLimitDownOneStr = textField.text;
        model.oxyLimitDownOne = [self.oxyLimitDownOneStr floatValue];
    } else if (textField.tag == 3) {
        self.oxyLimitDownTwoStr = textField.text;
        model.oxyLimitDownTwo = [self.oxyLimitDownTwoStr floatValue];
    } else if (textField.tag == 4) {
        self.alertlineOneStr = textField.text;
        model.alertlineOne = [self.alertlineOneStr floatValue];
    } else if (textField.tag == 5) {
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
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.manualBtn.selected = NO;
        } else {
            self.automaticBtn.selected = NO;
        }
        _chooseSingle = !_chooseSingle;
    }
    self.isAutomatic = _chooseSingle;
    if (_dataSource.count != 0) {
        JKDeviceModel *model = _dataSource[0];
        model.automatic = [NSString stringWithFormat:@"%d",!self.isAutomatic];
        [_delegate changeAutomatic:!self.isAutomatic];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
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
    }
    
    if (indexPath.row != 6 && indexPath.row != 0) {
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
        
        if (indexPath.row == 1) {
            [self.oxyLimitUpTF removeFromSuperview];
            self.oxyLimitUpTF = textField;
            if (self.oxyLimitUpStr != nil) {
                self.oxyLimitUpTF.text = self.oxyLimitUpStr;
            }
        } else if (indexPath.row == 2) {
            [self.oxyLimitDownOneTF removeFromSuperview];
            self.oxyLimitDownOneTF = textField;
            if (self.oxyLimitDownOneStr != nil) {
                self.oxyLimitDownOneTF.text = self.oxyLimitDownOneStr;
            }
        } else if (indexPath.row == 3) {
            [self.oxyLimitDownTwoTF removeFromSuperview];
            self.oxyLimitDownTwoTF = textField;
            if (self.oxyLimitDownTwoStr != nil) {
                self.oxyLimitDownTwoTF.text = self.oxyLimitDownTwoStr;
            }
        } else if (indexPath.row == 4) {
            [self.alertlineOneTF removeFromSuperview];
            self.alertlineOneTF = textField;
            if (self.alertlineOneStr != nil) {
                self.alertlineOneTF.text = self.alertlineOneStr;
            }
        } else if (indexPath.row == 5) {
            [self.alertlineTwoTF removeFromSuperview];
            self.alertlineTwoTF = textField;
            if (self.alertlineTwoStr != nil) {
                self.alertlineTwoTF.text = self.alertlineTwoStr;
            }
        }
        
    }
    
    if (indexPath.row == 6) {
        [self.manualBtn  removeFromSuperview];
        UIButton *manualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [manualBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [manualBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [manualBtn setTitle:@"  手动" forState:UIControlStateNormal];
        [manualBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [manualBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        manualBtn.titleLabel.font = JKFont(14);
        manualBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        manualBtn.tag = 1;
        if (self.isAutomatic) {
            manualBtn.selected = NO;
        } else {
            manualBtn.selected = YES;
        }
        [manualBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:manualBtn];
        [manualBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.manualBtn = manualBtn;
        
        [self.automaticBtn removeFromSuperview];
        UIButton *automaticBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [automaticBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [automaticBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [automaticBtn setTitle:@"  自动" forState:UIControlStateNormal];
        [automaticBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [automaticBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        automaticBtn.titleLabel.font = JKFont(14);
        automaticBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        automaticBtn.tag = 0;
        if (self.isAutomatic) {
            automaticBtn.selected = YES;
        } else {
            automaticBtn.selected = NO;
        }
        [automaticBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:automaticBtn];
        [automaticBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(manualBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.automaticBtn = automaticBtn;
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
