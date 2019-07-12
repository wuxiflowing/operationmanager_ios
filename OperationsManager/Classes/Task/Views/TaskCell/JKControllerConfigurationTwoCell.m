//
//  JKControllerConfigurationTwoCell.m
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKControllerConfigurationTwoCell.h"
#import "JKDeviceModel.h"

@interface JKControllerConfigurationTwoCell () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *ammeterSwitch;
@property (nonatomic, strong) NSString *ammeterName;
@property (nonatomic, strong) NSString *ammeterId;
@property (nonatomic, strong) NSString *open;
@property (nonatomic, strong) UITextField *ammeterTypeTF;
@property (nonatomic, strong) UITextField *powerBTF;
@property (nonatomic, strong) UITextField *voltageUpBTF;
@property (nonatomic, strong) UITextField *voltageDownBTF;
@property (nonatomic, strong) UITextField *electricCurrentUpBTF;
@property (nonatomic, strong) UITextField *electricCurrentDownBTF;

@end

@implementation JKControllerConfigurationTwoCell

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
    self.hasAmmeterB = model.hasAmmeterB;
    self.deviceType = model.type;
    self.ammeterTypeB = model.ammeterTypeB;
    self.powerB = model.powerB;
    self.voltageUpB = model.voltageUpB;
    self.voltageDownB = model.voltageDownB;
    self.electricCurrentUpB = model.electricCurrentUpB;
    self.electricCurrentDownB = model.electricCurrentDownB;
    self.ammeterName = model.aeratorNameB;
    self.open = [NSString stringWithFormat:@"%@",model.openB];
    self.ammeterId = model.ammeterIdB;
    [self.tableView reloadData];
}

- (void)setIsControllerTwo:(BOOL)isControllerTwo {
    _isControllerTwo = isControllerTwo;
    [self.tableView reloadData];
}

- (void)setPondName:(NSString *)pondName {
    _pondName = pondName;
    [self.tableView reloadData];
}

- (void)ammeterSwitchTouch:(UISwitch *)sender {
    if (sender.isOn) {
        self.isControllerTwo = YES;
        self.hasAmmeterB = @"1";
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadControllerTwoCell" object:nil userInfo:@{@"height":@"442"}]];
    } else {
        self.isControllerTwo = NO;
        self.hasAmmeterB = @"0";
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadControllerTwoCell" object:nil userInfo:@{@"height":@"154"}]];
    }
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    if (_dataSource.count == 0) {
        UITextField *textField = (UITextField *)[notification object];
        if (textField.tag == 3) {
            self.ammeterTypeB = textField.text;
        } else if (textField.tag == 4) {
            self.powerB = textField.text;
        } else if (textField.tag == 5) {
            self.voltageUpB = textField.text;
        } else if (textField.tag == 6) {
            self.voltageDownB = textField.text;
        } else if (textField.tag == 7) {
            self.electricCurrentUpB = textField.text;
        } else if (textField.tag == 8) {
            self.electricCurrentDownB = textField.text;
        }
    } else {
        JKDeviceModel *model = _dataSource[0];
        UITextField *textField = (UITextField *)[notification object];
        if (textField.tag == 3) {
            self.ammeterTypeB = textField.text;
            model.ammeterTypeB = self.ammeterTypeB;
        } else if (textField.tag == 4) {
            self.powerB = textField.text;
            model.powerB = self.powerB;
        } else if (textField.tag == 5) {
            self.voltageUpB = textField.text;
            model.voltageUpB = self.voltageUpB;
        } else if (textField.tag == 6) {
            self.voltageDownB = textField.text;
            model.voltageDownB = self.voltageDownB;
        } else if (textField.tag == 7) {
            self.electricCurrentUpB = textField.text;
            model.electricCurrentUpB = self.electricCurrentUpB;
        } else if (textField.tag == 8) {
            self.electricCurrentDownB = textField.text;
            model.electricCurrentDownB = self.electricCurrentDownB;
        }
    }
    
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.isControllerTwo) {
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
        cell.textLabel.text = @"控制器2配置";
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
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@2#",self.pondName,self.deviceType];
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
        if (!self.isControllerTwo) {
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
                if (self.ammeterTypeB != nil) {
                    textField.placeholder = self.ammeterTypeB;
                } else {
                    textField.placeholder = @"请输入编码";
                }
                
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell);
                    make.bottom.equalTo(cell);
                    make.right.equalTo(cell).offset(-15);
                    make.width.mas_offset(100);
                }];
                
                [self.ammeterTypeTF removeFromSuperview];
                self.ammeterTypeTF = textField;
                if (self.ammeterTypeB != nil) {
                    self.ammeterTypeTF.text = self.ammeterTypeB;
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
                [self.powerBTF removeFromSuperview];
                self.powerBTF = textField;
                if (self.powerB!= nil) {
                    self.powerBTF.text = self.powerB;
                }
                
            } else if (indexPath.row == 5 || indexPath.row == 6) {
                cell.detailTextLabel.text = @"V";
                if (indexPath.row == 5) {
                    [self.voltageUpBTF removeFromSuperview];
                    self.voltageUpBTF = textField;
                    if (self.voltageUpB != nil) {
                        self.voltageUpBTF.text = self.voltageUpB;
                    }
                } else {
                    [self.voltageDownBTF removeFromSuperview];
                    self.voltageDownBTF = textField;
                    if (self.voltageDownB != nil) {
                        self.voltageDownBTF.text = self.voltageDownB;
                    }
                }
            } else if (indexPath.row == 7 || indexPath.row == 8) {
                cell.detailTextLabel.text = @"A";
                if (indexPath.row == 7) {
                    [self.electricCurrentUpBTF removeFromSuperview];
                    self.electricCurrentUpBTF = textField;
                    if (self.electricCurrentUpB != nil) {
                        self.electricCurrentUpBTF.text = self.electricCurrentUpB;
                    }
                } else {
                    [self.electricCurrentDownBTF removeFromSuperview];
                    self.electricCurrentDownBTF = textField;
                    if (self.electricCurrentDownB != nil) {
                        self.electricCurrentDownBTF.text = self.electricCurrentDownB;
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
