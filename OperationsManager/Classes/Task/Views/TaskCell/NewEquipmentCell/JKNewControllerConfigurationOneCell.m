//
//  JKControllerConfigurationOneCell.m
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKNewControllerConfigurationOneCell.h"
#import "JKDeviceModel.h"

@interface JKNewControllerConfigurationOneCell () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *oxygenUpATF;
@property (nonatomic, strong) UITextField *oxygenDownATF;
@property (nonatomic, strong) UITextField *electricCurrentUpATF;
@property (nonatomic, strong) UITextField *electricCurrentDownATF;
@end

@implementation JKNewControllerConfigurationOneCell

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
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(bgView);
    }];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count == 0) {
        return;
    }
    JKDeviceModel *model = dataSource[0];
    self.oxygenUpA = [NSString stringWithFormat:@"%.1f",model.controlInfo1.oxyLimitUp];
    self.oxygenDownA =[NSString stringWithFormat:@"%.1f",model.controlInfo1.oxyLimitDown];
    self.electricCurrentUpA = [NSString stringWithFormat:@"%.1f",model.controlInfo1.electricityUp];
    self.electricCurrentDownA = [NSString stringWithFormat:@"%.1f",model.controlInfo1.electricityDown];
    self.open = [NSString stringWithFormat:@"%zd",model.controlInfo1.open];
    [self.tableView reloadData];
}



- (void)textFieldDidChangeValue:(NSNotification *)notification {
    if (_dataSource.count == 0) {
        UITextField *textField = (UITextField *)[notification object];
       if (textField.tag == 1) {
            self.oxygenUpA = textField.text;
        } else if (textField.tag == 2) {
            self.oxygenDownA = textField.text;
        } else if (textField.tag == 3) {
            self.electricCurrentUpA = textField.text;
        } else if (textField.tag == 4) {
            self.electricCurrentDownA = textField.text;
        }
    } else {
        JKDeviceModel *model = _dataSource[0];
        UITextField *textField = (UITextField *)[notification object];
        if (textField.tag == 1) {
            self.oxygenUpA = textField.text;
            model.voltageUpA = self.oxygenUpA;
        } else if (textField.tag == 2) {
            self.oxygenDownA = textField.text;
            model.voltageDownA = self.oxygenDownA;
        } else if (textField.tag == 3) {
            self.electricCurrentUpA = textField.text;
            model.electricCurrentUpA = self.electricCurrentUpA;
        } else if (textField.tag == 4) {
            self.electricCurrentDownA = textField.text;
            model.electricCurrentDownA = self.electricCurrentDownA;
        }
    }
}

#pragma mark -- 按钮点击
- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 1001) {
        if (self.controlCallBack) {
            self.controlCallBack(@"1");
        }
    } else if (btn.tag == 1002) {
        if (self.controlCallBack) {
            self.controlCallBack(@"0");
        }
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%zd",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = JKFont(14);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0xcccccc);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"控制器1配置";
        cell.textLabel.font = JKFont(16);
        
        if (self.open != nil) {
            UILabel *stateLb = [[UILabel alloc] init];
            if ([self.open isEqualToString:@"1"]) {
                stateLb.text = @"开";
                stateLb.textColor = kGreenColor;
            } else {
                stateLb.text = @"关";
                stateLb.textColor = kRedColor;
            }
            stateLb.textAlignment = NSTextAlignmentRight;
            stateLb.font = JKFont(14);
            [cell.contentView addSubview:stateLb];
            [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
                make.width.mas_equalTo(30);
            }];
        }
    } else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 ||
               indexPath.row == 4) {
        if (indexPath.row == 1) {
            cell.textLabel.text = @"溶氧上限";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"溶氧下限";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"电流上限";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"电流下限";
        }
        
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = RGBHex(0x333333);
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = JKFont(14);
        textField.tag = indexPath.row;
        textField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
        [cell addSubview:textField];
        
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.bottom.equalTo(cell);
            make.right.equalTo(cell).offset(-50);
            make.width.mas_offset(100);
        }];
        
        if (indexPath.row == 1 || indexPath.row == 2) {
            cell.detailTextLabel.text = @"mg/L";
            if (indexPath.row == 1) {
                [self.oxygenUpATF removeFromSuperview];
                self.oxygenUpATF = textField;
                if (self.oxygenUpA != nil) {
                    self.oxygenUpATF.text = self.oxygenUpA;
                }
            } else {
                [self.oxygenDownATF removeFromSuperview];
                self.oxygenDownATF = textField;
                if (self.oxygenDownA != nil) {
                    self.oxygenDownATF.text = self.oxygenDownA;
                }
            }
        } else if (indexPath.row == 3 || indexPath.row == 4) {
            cell.detailTextLabel.text = @"A";
            if (indexPath.row == 3) {
                [self.electricCurrentUpATF removeFromSuperview];
                self.electricCurrentUpATF = textField;
                if (self.electricCurrentUpA != nil) {
                    self.electricCurrentUpATF.text = self.electricCurrentUpA;
                }
            } else {
                [self.electricCurrentDownATF removeFromSuperview];
                self.electricCurrentDownATF = textField;
                if (self.electricCurrentDownA != nil) {
                    self.electricCurrentDownATF.text = self.electricCurrentDownA;
                }
            }
        }
    }else{
        cell.textLabel.text = @"开关控制";
        for (NSInteger i = 1; i < 3; i++) {
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = kWhiteColor;
            [cell.contentView addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(SCREEN_WIDTH / 4 * i);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, 48));
            }];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 1) {
                [btn setTitle:@"开" forState:UIControlStateNormal];
            } else if (i == 2) {
                [btn setTitle:@"关" forState:UIControlStateNormal];
            }
            [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            btn.titleLabel.font = JKFont(14);
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.mas_centerY);
                make.centerX.equalTo(bgView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4 * 0.8, 30));
            }];
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

@end
