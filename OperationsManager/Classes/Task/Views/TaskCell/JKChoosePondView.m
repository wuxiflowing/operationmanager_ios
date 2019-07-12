//
//  JKChoosePondView.m
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKChoosePondView.h"
#import "JKPondModel.h"

@interface JKChoosePondView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSMutableArray *rowNumberArr;
@property (nonatomic, strong) NSMutableArray *sectionTitileArr;
@property (nonatomic, strong) UITextField *pondTF;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *pondNameLb;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation JKChoosePondView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        _tableView.layer.cornerRadius = 4;
        _tableView.layer.masksToBounds = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)rowNumberArr {
    if (!_rowNumberArr) {
        _rowNumberArr = [[NSMutableArray alloc] init];
    }
    return _rowNumberArr;
}

- (NSMutableArray *)sectionTitileArr {
    if (!_sectionTitileArr) {
        _sectionTitileArr = [[NSMutableArray alloc] init];
    }
    return _sectionTitileArr;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _coverView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.coverView]; //蒙版
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kWhiteColor;
        [self.coverView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.coverView);
            make.centerY.equalTo(self.coverView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH *0.8, 48 * 3));
        }];
        self.bgView = bgView;
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = @"选择鱼塘";
        titleLb.textColor = RGBHex(0x333333);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(16);
        [self.bgView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(5);
            make.centerX.equalTo(self.bgView);
            make.size.mas_equalTo(CGSizeMake(100, 48));
        }];
        self.titleLb = titleLb;
        
        UILabel *lineLb2 = [[UILabel alloc] init];
        lineLb2.backgroundColor = RGBHex(0xdddddd);
        [self.bgView addSubview:lineLb2];
        [lineLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(0.5);
        }];
        
        UITextField *pondTF = [[UITextField alloc] init];
        [pondTF setValue:JKFont(14) forKeyPath:@"_placeholderLabel.font"];
        pondTF.font = JKFont(14);
        pondTF.textColor = kBlackColor;
        pondTF.returnKeyType = UIReturnKeyDone;
        pondTF.delegate = self;
        pondTF.textAlignment = NSTextAlignmentCenter;
        pondTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.bgView addSubview:pondTF];
        [pondTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom);
            make.centerX.equalTo(self.bgView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 48));
        }];
        self.pondTF = pondTF;
        
        UILabel *lineLb3 = [[UILabel alloc] init];
        lineLb3.backgroundColor = RGBHex(0xdddddd);
        [self.bgView addSubview:lineLb3];
        [lineLb3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pondTF.mas_bottom).offset(-1);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.titleLabel.font = JKFont(14);
        [self.bgView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView.mas_centerX);
            make.height.mas_equalTo(48);
        }];

        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = JKFont(14);
        [cancleBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.bgView);
            make.right.equalTo(self.bgView.mas_centerX);
            make.height.mas_equalTo(48);
        }];

        UILabel *lineLb = [[UILabel alloc] init];
        lineLb.backgroundColor = RGBHex(0xdddddd);
        [self.bgView addSubview:lineLb];
        [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView.mas_centerX);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(45);
        }];
    }
    return self;
}

- (void)setCustomerId:(NSString *)customerId {
    _customerId = customerId;
    [self getFishRawData:_customerId];
}

- (void)setFarmerName:(NSString *)farmerName {
    _farmerName = farmerName;
}

#pragma mark -- 鱼塘设备状态列表
- (void)getFishRawData:(NSString *)customerIdStr {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"0" forKey:@"startTime"];
    [params setObject:@"0" forKey:@"endTime"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/mytask/%@/pondData",kUrl_Base,self.customerId];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self];
    [[JKHttpTool shareInstance] GetReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.sectionTitileArr removeAllObjects];
            [self.rowNumberArr removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                JKPondModel *pModel = [[JKPondModel alloc] init];
                pModel.farmerId = dict[@"farmerId"];
                pModel.area = dict[@"area"];
                pModel.fishVariety = dict[@"fishVariety"];
                pModel.fryNumber = dict[@"fryNumber"];
                pModel.name = dict[@"name"];
                pModel.phoneNumber = dict[@"phoneNumber"];
                pModel.pondAddress = dict[@"pondAddress"];
                pModel.pondId = dict[@"pondId"];
                pModel.putInDate = dict[@"putInDate"];
                pModel.reckonSaleDate = dict[@"reckonSaleDate"];
                pModel.region = dict[@"region"];
                pModel.childDeviceList = dict[@"childDeviceList"];
                [self.sectionTitileArr addObject:pModel];
                
                if ([self.farmerName isEqualToString:pModel.name]) {
                    self.farmerName = @"";
                }
            }
        }
        
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.coverView);
            make.centerY.equalTo(self.coverView);
            if (self.sectionTitileArr.count > 7) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 10 * 48));
            } else {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, (self.sectionTitileArr.count + 3) * 48));
            }
        }];
        
        [self.bgView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pondTF.mas_bottom);
            make.centerX.equalTo(self.bgView);
            if (self.sectionTitileArr.count > 7) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 7 * 48));
            } else {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, self.sectionTitileArr.count * 48));
            }
        }];
        if (self.sectionTitileArr.count > 7) {
            self.tableView.scrollEnabled = YES;
        } else {
            self.tableView.scrollEnabled = NO;
        }
        
        if (self.farmerName.length == 0) {
            self.pondTF.placeholder = @"请输入鱼塘名称";
        } else {
            self.pondTF.text = self.farmerName;
        }
     
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)sureBtnClick:(UIButton *)btn {
    if ([self.pondTF.text trimmingCharacters].length == 0) {
        [YJProgressHUD showMessage:@"请输入鱼塘名称" inView:self];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(showPondName:withPondId:)]) {
        [_delegate showPondName:self.pondTF.text withPondId:@""];
    }
    
    [self cancleView];
}

- (void)cancelBtnClick:(UIButton *)btn {
    [self cancleView];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sectionTitileArr.count;
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
    
    JKPondModel *model = self.sectionTitileArr[indexPath.row];
    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = model.name;
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentCenter;
    pondNameLb.font = JKFont(14);
    [cell.contentView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.centerX.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 30));
    }];
    
//    if (indexPath.row == 0) {
//        [self.titleLb removeFromSuperview];
//        UILabel *titleLb = [[UILabel alloc] init];
//        titleLb.text = @"选择鱼塘";
//        titleLb.textColor = RGBHex(0x333333);
//        titleLb.textAlignment = NSTextAlignmentCenter;
//        titleLb.font = JKFont(16);
//        [cell.contentView addSubview:titleLb];
//        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(cell.contentView);
//            make.centerX.equalTo(cell.contentView);
//            make.size.mas_equalTo(CGSizeMake(100, 30));
//        }];
//        self.titleLb = titleLb;
//
//    } else if (indexPath.row == 1) {
//        [self.pondTF removeFromSuperview];
//        UITextField *pondTF = [[UITextField alloc] init];
//        if (self.farmerName.length == 0) {
//            pondTF.placeholder = @"请输入鱼塘名称";
//        } else {
//            pondTF.text = self.farmerName;
//        }
//        [pondTF setValue:JKFont(14) forKeyPath:@"_placeholderLabel.font"];
//        pondTF.font = JKFont(14);
//        pondTF.textColor = kBlackColor;
//        pondTF.returnKeyType = UIReturnKeyDone;
//        pondTF.delegate = self;
//        pondTF.textAlignment = NSTextAlignmentCenter;
//        pondTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [cell.contentView addSubview:pondTF];
//        [pondTF mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(cell.contentView);
//            make.centerX.equalTo(cell.contentView);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 30));
//        }];
//        self.pondTF = pondTF;
//    } else if (indexPath.row == (self.sectionTitileArr.count + 3) - 1) {
//        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
//        [sureBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
//        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        sureBtn.titleLabel.font = JKFont(14);
//        [cell.contentView addSubview:sureBtn];
//        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.bottom.equalTo(cell.contentView);
//            make.left.equalTo(cell.mas_centerX);
//        }];
//
//        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [cancleBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
//        cancleBtn.titleLabel.font = JKFont(14);
//        [cancleBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:cancleBtn];
//        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.equalTo(cell.contentView);
//            make.right.equalTo(cell.mas_centerX);
//        }];
//
//        UILabel *lineLb = [[UILabel alloc] init];
//        lineLb.backgroundColor = RGBHex(0xdddddd);
//        [cell.contentView addSubview:lineLb];
//        [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(cell.contentView);
//            make.left.equalTo(cell.mas_centerX);
//            make.width.mas_equalTo(0.5);
//        }];
//
//    } else {
//        if (self.sectionTitileArr.count != 0) {
//            JKPondModel *model = self.sectionTitileArr[indexPath.row - 2];
//            UILabel *pondNameLb = [[UILabel alloc] init];
//            pondNameLb.text = model.name;
//            pondNameLb.textColor = RGBHex(0x333333);
//            pondNameLb.textAlignment = NSTextAlignmentCenter;
//            pondNameLb.font = JKFont(14);
//            [cell.contentView addSubview:pondNameLb];
//            [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(cell.contentView);
//                make.centerX.equalTo(cell.contentView);
//                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 30));
//            }];
//        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == (self.sectionTitileArr.count + 3) - 1){
        return;
    }
    JKPondModel *model = self.sectionTitileArr[indexPath.row - 2];
    if ([_delegate respondsToSelector:@selector(showPondName:withPondId:)]) {
        [_delegate showPondName:model.name withPondId:model.pondId];
    }
    [self cancleView];
}

- (void)cancleView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
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
