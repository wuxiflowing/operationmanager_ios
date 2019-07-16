//
//  JKNewEquipmentInfoCell.m
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/12.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKNewEquipmentInfoCell.h"
#import "JKNewEquipmentPondCell.h"
#import "JKNewEquipmentControllerCell.h"
#import "JKNewEquipmentControllerAInfoCell.h"
#import "JKNewEquipmentControllerBInfoCell.h"
#import "JKNewEquipmentControllerCInfoCell.h"
#import "JKNewEquipmentControllerDInfoCell.h"
#import "JKNewEquipmentModel.h"

@interface JKNewEquipmentInfoCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JKNewEquipmentInfoCell

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
    if (self.dataSource.count > 0) {
        JKNewEquipmentModel *model = self.dataSource[0];
        if ([model.open3 isKindOfClass:[NSNull class]]) {
            return 4;
        }
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        return 65;
    } else if (indexPath.row == 1) {
        return 115;
    } else {
        if (self.dataSource.count == 0) {
            return 120;
        }
        return 165;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *cellIdentifier =@"JKNewEquipmentPondCell";
        JKNewEquipmentPondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKNewEquipmentPondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKNewEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    } else if (indexPath.row == 1) {
        NSString *cellIdentifier =@"JKNewEquipmentControllerCell";
        JKNewEquipmentControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKNewEquipmentControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKNewEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    } else if (indexPath.row == 2){
        NSString *cellIdentifier =@"JKNewEquipmentControllerAInfoCell";
        JKNewEquipmentControllerAInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKNewEquipmentControllerAInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKNewEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    } else if (indexPath.row == 3){
        NSString *cellIdentifier =@"JKNewEquipmentControllerBInfoCell";
        JKNewEquipmentControllerBInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKNewEquipmentControllerBInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKNewEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    }else if (indexPath.row == 4){
        NSString *cellIdentifier =@"JKNewEquipmentControllerCInfoCell";
        JKNewEquipmentControllerCInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKNewEquipmentControllerCInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKNewEquipmentModel *model = self.dataSource[0];
        [cell createUI:model];
        return cell;
    }else {
        NSString *cellIdentifier =@"JKNewEquipmentControllerDInfoCell";
        JKNewEquipmentControllerDInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JKNewEquipmentControllerDInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.dataSource.count == 0) {
            return cell;
        }
        JKNewEquipmentModel *model = self.dataSource[0];
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
