//
//  JKEquipmentInfoCell.m
//  OperationsManager
//
//  Created by    on 2018/7/20.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentInfoCell.h"
#import "JKEquipmentPondCell.h"
#import "JKEquipmentControllerCell.h"
#import "JKEquipmentControllerAInfoCell.h"
#import "JKEquipmentControllerBInfoCell.h"
#import "JKEquipmentModel.h"

@interface JKEquipmentInfoCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JKEquipmentInfoCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
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
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        return 65;
    } else if (indexPath.row == 1) {
        return 190;
    } else if (indexPath.row == 2) {
        if (self.dataSource.count == 0) {
            return 120;
        }
        JKEquipmentModel *model = self.dataSource[0];
        if ([[NSString stringWithFormat:@"%@",model.hasAmmeterA] isEqualToString:@"true"]) {
            return 270;
        } else {
            return 120;
        }
    } else {
        if (self.dataSource.count == 0) {
            return 120;
        }
        JKEquipmentModel *model = self.dataSource[0];
        if ([[NSString stringWithFormat:@"%@",model.hasAmmeterB] isEqualToString:@"true"]) {
            return 270;
        } else {
            return 120;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *cellIdentifier =@"JKEquipmentPondCell";
        JKEquipmentPondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKEquipmentPondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    } else if (indexPath.row == 1) {
        NSString *cellIdentifier =@"JKEquipmentControllerCell";
        JKEquipmentControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKEquipmentControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    } else if (indexPath.row == 2){
        NSString *cellIdentifier =@"JKEquipmentControllerAInfoCell";
        JKEquipmentControllerAInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKEquipmentControllerAInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    } else {
        NSString *cellIdentifier =@"JKEquipmentControllerBInfoCell";
        JKEquipmentControllerBInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKEquipmentControllerBInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
