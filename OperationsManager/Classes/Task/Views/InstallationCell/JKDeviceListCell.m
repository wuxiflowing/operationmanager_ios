//
//  JKDeviceListCell.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKDeviceListCell.h"
#import "JKInstallInfoModel.h"

@interface JKDeviceListCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *valueArr;
@property (nonatomic, strong) JKInstallInfoModel *model;
@end

@implementation JKDeviceListCell

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

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc] init];
    }
    return _titleArr;
}

- (NSMutableArray *)valueArr {
    if (!_valueArr) {
        _valueArr = [[NSMutableArray alloc] init];
    }
    return _valueArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
    }
    return self;
}

- (void)createUI:(JKInstallInfoModel *)model {
    self.model = model;
    
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
    
    [self.titleArr addObject:@"设备清单"];
    if (self.type == JKInstallationIng || self.type == JKInstallationWait) {
        for (NSDictionary *dict in model.tabEquipmentList) {
            [self.titleArr addObject:dict[@"ITEM2"]];
        }
        [self.valueArr addObject:@""];
        for (NSDictionary *dict in model.tabEquipmentList) {
            [self.valueArr addObject:dict[@"ITEM3"]];
        }
    } else {
        for (NSDictionary *dict in model.tabEquipmentBindPond) {
            [self.titleArr addObject:dict[@"ITEM2"]];
        }
        [self.valueArr addObject:@""];
        for (NSDictionary *dict in model.tabEquipmentBindPond) {
            [self.valueArr addObject:dict[@"ITEM1"]];
        }
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
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
    
    CGFloat width = (SCREEN_WIDTH - SCALE_SIZE(30)) / 3;
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = self.titleArr[indexPath.row];
    titleLb.textColor = RGBHex(0x333333);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(14);
    [cell addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cell);
        make.left.equalTo(cell).offset(SCALE_SIZE(15));
        make.width.mas_equalTo(width + 20);
    }];
    
//    cell.textLabel.text = self.titleArr[indexPath.row];
//    cell.textLabel.textColor = RGBHex(0x333333);
//    cell.textLabel.textAlignment = NSTextAlignmentLeft;
//    cell.textLabel.font = JKFont(14);
    
    if (self.type == JKInstallationIng || self.type == JKInstallationWait) {
        if (indexPath.row == 0) {
            cell.textLabel.font = JKFont(16);
        } else {
            UILabel *countsLb = [[UILabel alloc] init];
            countsLb.text = [NSString stringWithFormat:@"%@套",self.valueArr[indexPath.row]];
            countsLb.textColor = RGBHex(0x333333);
            countsLb.textAlignment = NSTextAlignmentRight;
            countsLb.font = JKFont(14);
            [cell addSubview:countsLb];
            [countsLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(cell);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.width.mas_equalTo(width);
            }];
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.font = JKFont(16);
        } else {
            UILabel *detailLb = [[UILabel alloc] init];
            detailLb.text = @"设备详情";
            detailLb.textColor = kThemeColor;
            detailLb.textAlignment = NSTextAlignmentCenter;
            detailLb.font = JKFont(14);
            detailLb.layer.cornerRadius = 4;
            detailLb.layer.masksToBounds = YES;
            detailLb.layer.borderColor = kThemeColor.CGColor;
            detailLb.layer.borderWidth = 1;
            [cell addSubview:detailLb];
            [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).offset(10);
                make.bottom.equalTo(cell).offset(-10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.width.mas_equalTo(80);
            }];
            
            UILabel *countsLb = [[UILabel alloc] init];
            countsLb.text = self.valueArr[indexPath.row];
            countsLb.textColor = RGBHex(0x333333);
            countsLb.textAlignment = NSTextAlignmentCenter;
            countsLb.font = JKFont(14);
            [cell addSubview:countsLb];
            [countsLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(cell);
                make.right.equalTo(detailLb.mas_left);
                make.width.mas_equalTo(width);
            }];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == JKInstallationEd) {
        if ([_delegate respondsToSelector:@selector(checkEquipmentInfo:withTag:)]) {
            [_delegate checkEquipmentInfo:self.model withTag:indexPath.row];
        }
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
