//
//  JKDeviceConfigurationCell.m
//  OperationsManager
//
//  Created by    on 2018/7/11.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKDeviceConfigurationCell.h"
#import "JKPondModel.h"
#import "JKDeviceModel.h"

@interface JKDeviceConfigurationCell () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *tskID;
@property (nonatomic, strong) UITextField *deviceIDTF;
@end

@implementation JKDeviceConfigurationCell

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPondNameCell:)name:@"reloadPondNameCell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContactCell:)name:@"reloadContactCell" object:nil];
    }
    return self;
}

- (void)setAddrStr:(NSString *)addrStr {
    _addrStr = addrStr;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)createUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
//    if (self.deviceId != nil) {
//        self.tskID = self.deviceId;
//    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadPondNameCell:(NSNotification *)noti {
    self.pondName = noti.userInfo[@"pondName"];
    self.pondId = noti.userInfo[@"pondId"];
    if ([_delegate respondsToSelector:@selector(getPondId:)]) {
        [_delegate getPondId:self.pondId];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadContactCell:(NSNotification *)noti{
    NSNumber *tag = noti.userInfo[@"tag"];
    NSString *contact = noti.userInfo[@"contact"];
    switch (tag.integerValue) {
            case 1:
            self.dayContact = contact;
            break;
            case 2:
            self.nightContact = contact;
            break;
            case 3:
            self.secondDayContact = contact;
            break;
            case 4:
            self.secondNightContact = contact;
            break;
            
        default:
            break;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag.integerValue+3 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- 按钮点击
- (void)btnClick:(UIButton *)btn {
    if ([NSString stringWithFormat:@"%@",self.tskID].length == 0 || self.tskID == nil) {
        [YJProgressHUD showMessage:@"请输入设备ID" inView:self];
        return;
    }
    
    if (btn.tag == 0) {
        if (self.tskID.length != 6) {
            [YJProgressHUD showMessage:@"请输入6位设备ID" inView:self];
            return;
        }
        if ([_delegate respondsToSelector:@selector(onlineCheckWithTskID:)]) {
            [_delegate onlineCheckWithTskID:self.tskID];
        }
    } else if (btn.tag == 1) {
        if ([self.tskID trimmingCharacters].length != 6) {
            [YJProgressHUD showMessage:@"请输入6位设备ID" inView:self];
            return;
        }
        if ([_delegate respondsToSelector:@selector(getDeviceControlState:withTskID:)]) {
            [_delegate getDeviceControlState:@"1" withTskID:self.tskID];
        }
    } else if (btn.tag == 2) {
        if ([self.tskID trimmingCharacters].length != 6) {
            [YJProgressHUD showMessage:@"请输入6位设备ID" inView:self];
            return;
        }
        if ([_delegate respondsToSelector:@selector(getDeviceControlState:withTskID:)]) {
            [_delegate getDeviceControlState:@"0" withTskID:self.tskID];
        }
    } else if (btn.tag == 3) {
        if (self.tskID.length != 6) {
            [YJProgressHUD showMessage:@"请输入6位设备ID" inView:self];
            return;
        }
        if ([_delegate respondsToSelector:@selector(resetInstall:)]) {
            [_delegate resetInstall:self.tskID];
        }
    }
}

- (void)addContactClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(chooseAddContact)]) {
        [_delegate chooseAddContact];
    }
}

#pragma mark -- 扫描
- (void)scanBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(scanDeviceId)]) {
        [_delegate scanDeviceId];
    }
}

#pragma mark -- textField
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    self.tskID = textField.text;
    if ([self.tskID trimmingCharacters].length == 6) {
        if ([_delegate respondsToSelector:@selector(getDeviceInfoWithTskID:)]) {
            [_delegate getDeviceInfoWithTskID:self.tskID];
        }
    }
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5+5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4+5) {
        return 60;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell) {
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
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"设备ID";
        
        UIButton *scanBtn = [[UIButton alloc] init];
        [scanBtn setImage:[UIImage imageNamed:@"ic_device_scan"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:scanBtn];
        [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView).offset(-SCALE_SIZE(15));
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(18);
        }];
        
        UITextField *deviceIDTF = [[UITextField alloc] init];
        if (self.tskID != nil) {
            deviceIDTF.text = [NSString stringWithFormat:@"%@",self.tskID];
        } else {
            if (self.deviceId != nil) {
                deviceIDTF.text = [NSString stringWithFormat:@"%@",self.deviceId];
            }
        }
        deviceIDTF.textColor = kBlackColor;
        deviceIDTF.textAlignment = NSTextAlignmentCenter;
        deviceIDTF.font = JKFont(14);
        deviceIDTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        deviceIDTF.layer.borderColor = RGBHex(0xdddddd).CGColor;
        deviceIDTF.layer.borderWidth = 1;
        deviceIDTF.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:deviceIDTF];
        [deviceIDTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:deviceIDTF];
        [deviceIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(scanBtn.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        self.deviceIDTF = deviceIDTF;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"设备类型";
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKDeviceModel *model = self.dataSource[0];
        cell.detailTextLabel.text = model.type;
        cell.detailTextLabel.textColor = RGBHex(0x333333);
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"鱼塘";
        if (self.pondName == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.detailTextLabel.text = self.pondName;
            cell.detailTextLabel.textColor = RGBHex(0x333333);
            if (!self.isFromRepairVC) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }

    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"鱼塘地址";
        if (self.addrStr == nil) {
            cell.detailTextLabel.text = @"请选择";
        } else {
            cell.detailTextLabel.text = self.addrStr;
            cell.detailTextLabel.textColor = RGBHex(0x333333);
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"白班鱼塘联系人/电话";
        if (self.dayContact == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.detailTextLabel.text = self.dayContact;
            cell.detailTextLabel.textColor = RGBHex(0x333333);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"晚班鱼塘联系人/电话";
        if (self.nightContact == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.detailTextLabel.text = self.nightContact;
            cell.detailTextLabel.textColor = RGBHex(0x333333);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"白班鱼塘备用联系人/电话";
        if (self.secondDayContact == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.detailTextLabel.text = self.secondDayContact;
            cell.detailTextLabel.textColor = RGBHex(0x333333);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if (indexPath.row == 7) {
        cell.textLabel.text = @"晚班鱼塘备用联系人/电话";
        if (self.secondNightContact == nil) {
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.detailTextLabel.text = self.secondNightContact;
            cell.detailTextLabel.textColor = RGBHex(0x333333);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if (indexPath.row == 8) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"+ 添加联系人" forState:UIControlStateNormal];
        btn.titleLabel.font = JKFont(15);
        btn.tag = 1000+8;
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addContactClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.centerX.equalTo(cell.contentView.mas_centerX);
        }];
    }else {
        if (self.equipmentType == JKEquipmentType_New) {
            for (NSInteger i = 0; i < 2; i++) {
                UIView *bgView = [[UIView alloc] init];
                bgView.backgroundColor = kWhiteColor;
                [cell.contentView addSubview:bgView];
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(SCREEN_WIDTH / 4 * i);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, 60));
                }];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (i == 0) {
                    [btn setTitle:@"测试连接" forState:UIControlStateNormal];
                } else if (i == 1) {
                    [btn setTitle:@"校准" forState:UIControlStateNormal];
                }
                [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                btn.titleLabel.font = JKFont(14);
                btn.layer.cornerRadius = 4;
                btn.layer.masksToBounds = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
                if (i == 0) {
                    btn.tag = i;
                } else if (i == 1) {
                    btn.tag =3;
                }
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bgView.mas_centerY);
                    make.centerX.equalTo(bgView.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4 * 0.8, 30));
                }];
            }
        }else{
            for (NSInteger i = 0; i < 4; i++) {
                UIView *bgView = [[UIView alloc] init];
                bgView.backgroundColor = kWhiteColor;
                [cell.contentView addSubview:bgView];
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(SCREEN_WIDTH / 4 * i);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, 60));
                }];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (i == 0) {
                    [btn setTitle:@"测试连接" forState:UIControlStateNormal];
                } else if (i == 1) {
                    [btn setTitle:@"开" forState:UIControlStateNormal];
                } else if (i == 2) {
                    [btn setTitle:@"关" forState:UIControlStateNormal];
                } else if (i == 3) {
                    [btn setTitle:@"校准" forState:UIControlStateNormal];
                }
                [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                btn.titleLabel.font = JKFont(14);
                btn.layer.cornerRadius = 4;
                btn.layer.masksToBounds = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
                btn.tag = i;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bgView.mas_centerY);
                    make.centerX.equalTo(bgView.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4 * 0.8, 30));
                }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isFromRepairVC) {
        if (indexPath.row == 2) {
            if ([_delegate respondsToSelector:@selector(choosePond)]) {
                [_delegate choosePond];
            }
        }
    }
    
    if (indexPath.row == 3) {
        if ([_delegate respondsToSelector:@selector(locationAddr)]) {
            [_delegate locationAddr];
        }
    }
    
    if (indexPath.row == 4||indexPath.row == 5||indexPath.row == 6||indexPath.row == 7) {
        if ([_delegate respondsToSelector:@selector(chooseContact:)]) {
            [_delegate chooseContact:indexPath.row - 3];
        }
    }
}

#pragma mark -- 监听UITextField
- (void)textFieldChanged {
    if ([self.deviceIDTF.text trimmingCharacters].length > 6) {
        NSString *str = [self.deviceIDTF.text substringToIndex:6];
        self.deviceIDTF.text = str;
        return;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

@end
