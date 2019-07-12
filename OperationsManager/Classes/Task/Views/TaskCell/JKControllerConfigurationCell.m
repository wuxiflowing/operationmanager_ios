//
//  JKControllerConfigurationCell.m
//  OperationsManager
//
//  Created by 周家康 on 2018/7/10.
//  Copyright © 2018年 周家康. All rights reserved.
//

#import "JKControllerConfigurationCell.h"

@interface JKControllerConfigurationCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placeholderArr;

@end

@implementation JKControllerConfigurationCell

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
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        self.titleArr = @[@"",@"通道名称",@"是否有电流表",@"电流表编号",@"功率",@"电压上限",@"电压下限",@"电流上限",@"电流下限"];
        self.placeholderArr = @[@"",@"",@"",@"请输入编号",@"输入功率",@"请输入电压上限",@"请输入电压下限",@"请输入电流上限",@"请输入电流下限"];
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
    
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(bgView);
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tag == 1) {
        return 3;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
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
    cell.detailTextLabel.textColor = RGBHex(0xcccccc);
    if (self.tag == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"控制器1配置";
            cell.textLabel.font = JKFont(16);
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"控制器2配置";
            cell.textLabel.font = JKFont(16);
        }
    }
    
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"鱼塘名字+设备类型+编号";
    } else if (indexPath.row == 2) {
        UISwitch *ammeterSwitch = [[UISwitch alloc] init];
        ammeterSwitch.transform = CGAffineTransformMakeScale( 0.7, 0.7);
        [ammeterSwitch setOn:YES];
        [ammeterSwitch addTarget:self action:@selector(ammeterSwitchTouch:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:ammeterSwitch];
        [ammeterSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell).mas_offset(-15);
        }];
    } else if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 ||
               indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8) {
        
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = RGBHex(0x333333);
        textField.placeholder = self.placeholderArr[indexPath.row];
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = JKFont(14);
        textField.tag = indexPath.row;
        [cell addSubview:textField];
        
        if (indexPath.row == 3) {
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.bottom.equalTo(cell);
                make.right.equalTo(cell).offset(-15);
                make.width.mas_offset(100);
            }];
        } else {
            if (indexPath.row == 4) {
                cell.detailTextLabel.text = @"KW";
            } else if (indexPath.row == 5 || indexPath.row == 6) {
                cell.detailTextLabel.text = @"V";
            } else if (indexPath.row == 7 || indexPath.row == 8) {
                cell.detailTextLabel.text = @"A";
            }
            
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.bottom.equalTo(cell);
                make.right.equalTo(cell.detailTextLabel.mas_left).offset(-5);
                make.width.mas_offset(100);
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


@end
