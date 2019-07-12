//
//  JKRecyceDeviceCell.m
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceDeviceCell.h"
#import "JKRecyceInfoModel.h"

@interface JKRecyceDeviceCell() <UITableViewDelegate, UITableViewDataSource>
{
//    BOOL _isUnitied;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *untiedBtn;
@property (nonatomic, strong) UILabel *deviceIDLb;
//@property (nonatomic, strong) NSMutableArray *deciceArr;
@end

@implementation JKRecyceDeviceCell

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

//- (NSMutableArray *)deciceArr {
//    if (!_deciceArr) {
//        _deciceArr = [[NSMutableArray alloc] init];
//    }
//    return _deciceArr;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitiedState:)name:@"unitiedState" object:nil];
        
//        _isUnitied = NO;
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
        make.top.equalTo(bgView.mas_top);
        make.left.right.bottom.equalTo(bgView);
    }];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
//    [self.deciceArr removeAllObjects];
//    for (NSDictionary *dict in _dataSource) {
//        JKRecyceInfoModel *model = [[JKRecyceInfoModel alloc] init];
//        model.ident = dict[@"ITEM2"];
//        model.name = dict[@"ITEM5"];
//        model.isSelect = NO;
//        [self.deciceArr addObject:model];
//    }
    [self.tableView reloadData];
}

#pragma mark -- 解绑设备
- (void)untiedBtnClick:(UIButton *)btn {
    if (!btn.selected) {
        JKRecyceInfoModel *model = self.dataSource[btn.tag - 1];
        NSString *ident = model.ident;
        NSString *name = model.name;
        model.isSelect = YES;
        if ([_delegate respondsToSelector:@selector(untiedDeviceWithIdent:withPondName:withIsSelected:withBtnTag:)]) {
            [_delegate untiedDeviceWithIdent:ident withPondName:name withIsSelected:btn.selected withBtnTag:btn.tag];
        }
    }
}

- (void)unitiedState:(NSNotification *)noti {
//    if (!_isUnitied) {
//        self.untiedBtn.backgroundColor = kWhiteColor;
//        self.untiedBtn.layer.borderColor = RGBHex(0xdddddd).CGColor;
//        self.untiedBtn.layer.borderWidth = 1;
//        self.untiedBtn.selected = YES;
//
//        _isUnitied = YES;
//    }
    NSInteger index = [noti.userInfo[@"index"] integerValue];

//    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }

    cell.textLabel.font = JKFont(14);
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x333333);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"回收设备";
        cell.textLabel.font = JKFont(16);
    } else {
        JKRecyceInfoModel *model = self.dataSource[indexPath.row - 1];
        
        cell.textLabel.text = model.name;
        
        if (self.recyceType == JKRecyceWait) {
            cell.detailTextLabel.text = model.ident;
        } else {
//            [self.deviceIDLb removeFromSuperview];
            if (self.recyceType == JKRecyceIng) {
                
                UILabel *deviceIDLb = [[UILabel alloc] init];
                deviceIDLb.text = model.ident;
                deviceIDLb.textAlignment = NSTextAlignmentCenter;
                deviceIDLb.font = JKFont(14);
                [cell.contentView addSubview:deviceIDLb];
                [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView);
                    make.bottom.equalTo(cell.contentView);
                    make.centerX.equalTo(cell.contentView.mas_centerX);
                    make.width.mas_offset(90);
                }];
                self.deviceIDLb = deviceIDLb;
                
                UIButton *untiedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [untiedBtn setTitle:@"解绑设备" forState:UIControlStateNormal];
                [untiedBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                [untiedBtn setTitle:@"已解绑" forState:UIControlStateSelected];
                [untiedBtn setTitleColor:RGBHex(0xaaaaaa) forState:UIControlStateSelected];
               
                NSLog(@"%d",model.isSelect);
                if (!model.isSelect) {
                    [untiedBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
                    [untiedBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
                    [untiedBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
                } else {
                    untiedBtn.backgroundColor = kWhiteColor;
                    untiedBtn.layer.borderColor = RGBHex(0xdddddd).CGColor;
                    untiedBtn.layer.borderWidth = 1;
                }
                untiedBtn.titleLabel.font = JKFont(14);
                untiedBtn.layer.cornerRadius = 4;
                untiedBtn.layer.masksToBounds = YES;
                untiedBtn.tag = indexPath.row;
                untiedBtn.selected = model.isSelect;
                [untiedBtn addTarget:self action:@selector(untiedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:untiedBtn];
                [untiedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.right.equalTo(cell.contentView.mas_right).offset(-SCALE_SIZE(15));
                    make.size.mas_equalTo(CGSizeMake(80, 30));
                }];
                self.untiedBtn = untiedBtn;
            } else {
                cell.detailTextLabel.text = model.ident;
            }
            cell.detailTextLabel.font = JKFont(14);
        }
    }
    
    return cell;
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}


@end
