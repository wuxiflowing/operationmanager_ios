//
//  JKControllerConfigurationOneCell.m
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKControllerConfigurationOneCell.h"
#import "JKDeviceModel.h"

@interface JKControllerConfigurationOneCell () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *ammeterSwitch;
@property (nonatomic, strong) NSString *ammeterName;
@property (nonatomic, strong) NSString *ammeterId;
@property (nonatomic, strong) NSString *open;
@property (nonatomic, strong) UITextField *ammeterTypeTF;
@property (nonatomic, strong) UITextField *powerATF;
@property (nonatomic, strong) UITextField *voltageUpATF;
@property (nonatomic, strong) UITextField *voltageDownATF;
@property (nonatomic, strong) UITextField *electricCurrentUpATF;
@property (nonatomic, strong) UITextField *electricCurrentDownATF;
@end

@implementation JKControllerConfigurationOneCell

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
    self.hasAmmeterA = model.hasAmmeterA;
    self.deviceType = model.type;
    self.ammeterTypeA = model.ammeterTypeA;
    self.powerA = model.powerA;
    self.voltageUpA = model.voltageUpA;
    self.voltageDownA = model.voltageDownA;
    self.electricCurrentUpA = model.electricCurrentUpA;
    self.electricCurrentDownA = model.electricCurrentDownA;
    self.ammeterName = model.aeratorNameA;
    self.open = [NSString stringWithFormat:@"%@",model.openA];
    self.ammeterId = model.ammeterIdA;
    [self.tableView reloadData];
}

- (void)setIsControllerOne:(BOOL)isControllerOne {
    _isControllerOne = isControllerOne;
    [self.tableView reloadData];
}

- (void)setPondName:(NSString *)pondName {
    _pondName = pondName;
    [self.tableView reloadData];
}

- (void)ammeterSwitchTouch:(UISwitch *)sender {
    if (sender.isOn) {
        self.isControllerOne = YES;
        self.hasAmmeterA = @"1";
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadControllerOneCell" object:nil userInfo:@{@"height":@"442"}]];
    } else {
        self.isControllerOne = NO;
        self.hasAmmeterA = @"0";
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadControllerOneCell" object:nil userInfo:@{@"height":@"154"}]];
    }
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    if (_dataSource.count == 0) {
        UITextField *textField = (UITextField *)[notification object];
        if (textField.tag == 3) {
            self.ammeterTypeA = textField.text;
        } else if (textField.tag == 4) {
            self.powerA = textField.text;
        } else if (textField.tag == 5) {
            self.voltageUpA = textField.text;
        } else if (textField.tag == 6) {
            self.voltageDownA = textField.text;
        } else if (textField.tag == 7) {
            self.electricCurrentUpA = textField.text;
        } else if (textField.tag == 8) {
            self.electricCurrentDownA = textField.text;
        }
    } else {
        JKDeviceModel *model = _dataSource[0];
        UITextField *textField = (UITextField *)[notification object];
        if (textField.tag == 3) {
            self.ammeterTypeA = textField.text;
            model.ammeterTypeA = self.ammeterTypeA;
        } else if (textField.tag == 4) {
            self.powerA = textField.text;
            model.powerA = self.powerA;
        } else if (textField.tag == 5) {
            self.voltageUpA = textField.text;
            model.voltageUpA = self.voltageUpA;
        } else if (textField.tag == 6) {
            self.voltageDownA = textField.text;
            model.voltageDownA = self.voltageDownA;
        } else if (textField.tag == 7) {
            self.electricCurrentUpA = textField.text;
            model.electricCurrentUpA = self.electricCurrentUpA;
        } else if (textField.tag == 8) {
            self.electricCurrentDownA = textField.text;
            model.electricCurrentDownA = self.electricCurrentDownA;
        }
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.isControllerOne) {
        return 3;
    } else {
        return 9;
    }
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
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"通道名称";
        if (self.pondName != nil && self.deviceType != nil) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@1#",self.pondName,self.deviceType];
            cell.detailTextLabel.textColor = RGBHex(0x333333);
        } else {
            if (self.ammeterName != nil) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.ammeterName];
                cell.detailTextLabel.textColor = RGBHex(0x333333);
            } else {
                cell.detailTextLabel.text = @"鱼塘名字+设备类型+编号";
            }
        }
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"是否有电流表";
        [self.ammeterSwitch removeFromSuperview];
        UISwitch *ammeterSwitch = [[UISwitch alloc] init];
        ammeterSwitch.transform = CGAffineTransformMakeScale( 0.7, 0.7);
        if (!self.isControllerOne) {
            [ammeterSwitch setOn:NO];
        } else {
            [ammeterSwitch setOn:YES];
        }
        [ammeterSwitch addTarget:self action:@selector(ammeterSwitchTouch:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:ammeterSwitch];
        [ammeterSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell).mas_offset(-15);
        }];
        self.ammeterSwitch = ammeterSwitch;
    } else if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 ||
               indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8) {
        if (indexPath.row == 3) {
            cell.textLabel.text = @"电流表编号";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"功率";
        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"电压上限";
        } else if (indexPath.row == 6) {
            cell.textLabel.text = @"电压下限";
        } else if (indexPath.row == 7) {
            cell.textLabel.text = @"电流上限";
        } else if (indexPath.row == 8) {
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
        
        if (indexPath.row == 3) {
            if (self.ammeterId != nil) {
                cell.detailTextLabel.text = self.ammeterId;
                cell.detailTextLabel.textColor = RGBHex(0x333333);
            } else {
                textField.placeholder = @"请输入编码";
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell);
                    make.bottom.equalTo(cell);
                    make.right.equalTo(cell).offset(-15);
                    make.width.mas_offset(100);
                }];

                [self.ammeterTypeTF removeFromSuperview];
                self.ammeterTypeTF = textField;
                if (self.ammeterTypeA != nil) {
                    self.ammeterTypeTF.text = self.ammeterTypeA;
                }
            }
            
        } else {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.bottom.equalTo(cell);
                make.right.equalTo(cell.detailTextLabel.mas_left).offset(-5);
                make.width.mas_offset(100);
            }];
            
            if (indexPath.row == 4) {
                cell.detailTextLabel.text = @"KW";
                [self.powerATF removeFromSuperview];
                self.powerATF = textField;
                if (self.powerA != nil) {
                    self.powerATF.text = self.powerA;
                }
                
            } else if (indexPath.row == 5 || indexPath.row == 6) {
                cell.detailTextLabel.text = @"V";
                if (indexPath.row == 5) {
                    [self.voltageUpATF removeFromSuperview];
                    self.voltageUpATF = textField;
                    if (self.voltageUpA != nil) {
                        self.voltageUpATF.text = self.voltageUpA;
                    }
                } else {
                    [self.voltageDownATF removeFromSuperview];
                    self.voltageDownATF = textField;
                    if (self.voltageDownA != nil) {
                        self.voltageDownATF.text = self.voltageDownA;
                    }
                }
            } else if (indexPath.row == 7 || indexPath.row == 8) {
                cell.detailTextLabel.text = @"A";
                if (indexPath.row == 7) {
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
