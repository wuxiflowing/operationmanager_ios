//
//  JKRepairResultCell.m
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRepairResultCell.h"
#import "TZImagePickerHelper.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKRepairResultCell () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *farmerBtn;
@property (nonatomic, strong) UIButton *staffMemberBtn;
@property (nonatomic, strong) NSMutableArray *resultBtnTitleArr;
@property (nonatomic, strong) NSMutableArray *contentBtnTitleArr;
//@property (nonatomic, strong) UIScrollView *repairOrderScrollView;
//@property (nonatomic, strong) UIScrollView *receiptScrollView;
@property (nonatomic, strong) UILabel *fixContentLb;
@property (nonatomic, strong) UIView *fixBgView;
@property (nonatomic, strong) UILabel *issueResultLb;
@property (nonatomic, strong) UIView *issueBgView;
@property (nonatomic, strong) TZImagePickerHelper *fixOrderHelper;
@property (nonatomic, strong) TZImagePickerHelper *receiptHelper;
@property (nonatomic, strong) NSMutableArray *imageFixOrderURL;
@property (nonatomic, strong) NSMutableArray *imageReceiptURL;
@property (nonatomic, strong) UILabel *orderRemarkLb;
@property (nonatomic, strong) UILabel *receiptRemarkLb;
@property (nonatomic, strong) UIScrollView *orderScrollView;
@property (nonatomic, strong) UIScrollView *receiptScrollView;

@end

@implementation JKRepairResultCell

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

- (NSMutableArray *)selectResultArr {
    if (!_selectResultArr) {
        _selectResultArr = [[NSMutableArray alloc] init];
    }
    return _selectResultArr;
}

- (NSMutableArray *)selectContentArr {
    if (!_selectContentArr) {
        _selectContentArr = [[NSMutableArray alloc] init];
    }
    return _selectContentArr;
}

- (NSMutableArray *)resultBtnTitleArr {
    if (!_resultBtnTitleArr) {
        _resultBtnTitleArr = [[NSMutableArray alloc] init];
    }
    return _resultBtnTitleArr;
}

- (NSMutableArray *)contentBtnTitleArr {
    if (!_contentBtnTitleArr) {
        _contentBtnTitleArr = [[NSMutableArray alloc] init];
    }
    return _contentBtnTitleArr;
}

//- (UIScrollView *)repairOrderScrollView {
//    if (!_repairOrderScrollView) {
//        _repairOrderScrollView = [[UIScrollView alloc] init];
//        _repairOrderScrollView.showsHorizontalScrollIndicator = NO;
//        _repairOrderScrollView.backgroundColor = kWhiteColor;
//    }
//    return _repairOrderScrollView;
//}
//
//- (UIScrollView *)receiptScrollView {
//    if (!_receiptScrollView) {
//        _receiptScrollView = [[UIScrollView alloc] init];
//        _receiptScrollView.showsHorizontalScrollIndicator = NO;
//        _receiptScrollView.backgroundColor = kWhiteColor;
//    }
//    return _receiptScrollView;
//}

- (TZImagePickerHelper *)fixOrderHelper {
    if (!_fixOrderHelper) {
        _fixOrderHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _fixOrderHelper.imageType = JKImageTypeRepaireFixOrder;
        _fixOrderHelper.finishRepaireFixOrder = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageFixOrderURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageFixOrderArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _fixOrderHelper;
}

- (TZImagePickerHelper *)receiptHelper {
    if (!_receiptHelper) {
        _receiptHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _receiptHelper.imageType = JKImageTypeRepaireReceipt;
        _receiptHelper.finishRepaireReceipt = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageReceiptURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageReceiptArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _receiptHelper;
}

- (NSMutableArray *)imageFixOrderURL {
    if (!_imageFixOrderURL) {
        _imageFixOrderURL = [NSMutableArray array];
    }
    return _imageFixOrderURL;
}

- (NSMutableArray *)imageReceiptURL {
    if (!_imageReceiptURL) {
        _imageReceiptURL = [NSMutableArray array];
    }
    return _imageReceiptURL;
}

- (NSMutableArray *)imageFixOrderArr {
    if (!_imageFixOrderArr) {
        _imageFixOrderArr = [NSMutableArray array];
    }
    return _imageFixOrderArr;
}

- (NSMutableArray *)imageReceiptArr {
    if (!_imageReceiptArr) {
        _imageReceiptArr = [NSMutableArray array];
    }
    return _imageReceiptArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        self.chooseSingleTreatment = NO;
        
        [self getIssueList];
        [self getRepairList];
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

#pragma mark -- 获取故障原因多选项
- (void)getIssueList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/formData/issueList/repair",kUrl_Base];
    
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            for (NSString *reason in responseObject[@"data"]) {
                [self.resultBtnTitleArr addObject:[NSString stringWithFormat:@"  %@",reason]];
            }
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 获取维修内容多选项
- (void)getRepairList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/formData/repairList/repair",kUrl_Base];
    
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            for (NSString *reason in responseObject[@"data"]) {
                [self.contentBtnTitleArr addObject:[NSString stringWithFormat:@"  %@",reason]];
            }
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 处理方式
- (void)singleTreatmentSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.farmerBtn.selected = NO;
        } else {
            self.staffMemberBtn.selected = NO;
        }
        self.chooseSingleTreatment = !self.chooseSingleTreatment;
    }
    NSLog(@"%d",self.chooseSingleTreatment);
}

#pragma mark -- 故障原因
- (void)moreResultSelected:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSString *tagStr = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
    
    if (btn.selected) {
        [self.selectResultArr addObject:tagStr];
    } else {
        [self.selectResultArr removeObject:tagStr];
    }
    
    NSLog(@"%@",self.selectResultArr);
}

#pragma mark -- 维修内容
- (void)moreContentSelected:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSString *tagStr = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
    
    if (btn.selected) {
        [self.selectContentArr addObject:tagStr];
    } else {
        [self.selectContentArr removeObject:tagStr];
    }
    
    NSLog(@"%@",self.selectContentArr);
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 48;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        if (indexPath.row == 2) {
            return 140 + (self.resultBtnTitleArr.count / 2  + self.resultBtnTitleArr.count % 2) * 30;
        } else {
            return 140 + (self.contentBtnTitleArr.count / 2  + self.contentBtnTitleArr.count % 2) * 30;
        }
    } else if (indexPath.row == 5 || indexPath.row == 6) {
        return 140;
    } else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
 
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = JKFont(14);
    cell.detailTextLabel.font = JKFont(14);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"处理结果";
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"处理方式";
        if (self.repaireType == JKRepaireIng) {
            UIButton *farmerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [farmerBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
            [farmerBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
            [farmerBtn setTitle:@"  养殖户自行解决" forState:UIControlStateNormal];
            [farmerBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
            [farmerBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
            farmerBtn.titleLabel.font = JKFont(14);
            farmerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            farmerBtn.tag = 1;
            farmerBtn.selected = NO;
            [farmerBtn addTarget:self action:@selector(singleTreatmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:farmerBtn];
            [farmerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(130, 30));
            }];
            self.farmerBtn = farmerBtn;
            
            UIButton *staffMemberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [staffMemberBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
            [staffMemberBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
            [staffMemberBtn setTitle:@"  现场解决" forState:UIControlStateNormal];
            [staffMemberBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
            [staffMemberBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
            staffMemberBtn.titleLabel.font = JKFont(14);
            staffMemberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            staffMemberBtn.tag = 0;
            staffMemberBtn.selected = YES;
            [staffMemberBtn addTarget:self action:@selector(singleTreatmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:staffMemberBtn];
            [staffMemberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(farmerBtn.mas_left).offset(-5);
                make.size.mas_equalTo(CGSizeMake(90, 30));
            }];
            self.staffMemberBtn = staffMemberBtn;

        } else {
            cell.detailTextLabel.text = @"养殖户自行解决";
        }
        
    } else if (indexPath.row == 2) {
        [self.issueResultLb removeFromSuperview];
        UILabel *issueResultLb = [[UILabel alloc] init];
        issueResultLb.text = @"故障原因";
        issueResultLb.textColor = RGBHex(0x333333);
        issueResultLb.textAlignment = NSTextAlignmentLeft;
        issueResultLb.font = JKFont(14);
        [cell addSubview:issueResultLb];
        [issueResultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(70);
            make.height.mas_equalTo(48);
        }];
        self.issueResultLb = issueResultLb;
        
        [self.issueBgView removeFromSuperview];
        UIView *bgView = [[UIView alloc] init];
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(10);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(issueResultLb.mas_right);
            make.height.mas_equalTo((self.resultBtnTitleArr.count / 2 + self.resultBtnTitleArr.count % 2) *30);
        }];
        self.issueBgView = bgView;
        
        CGFloat width = (SCREEN_WIDTH - SCALE_SIZE(30) - 70) / 2;
        
        for (NSInteger i = 0; i < self.resultBtnTitleArr.count; i++) {
            NSInteger col = i / 2;
            NSInteger row = i % 2;
            
            UIButton *resultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_off"] forState:UIControlStateNormal];
            if (self.repaireType == JKRepaireIng) {
                [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_on"] forState:UIControlStateSelected];
                [resultBtn addTarget:self action:@selector(moreResultSelected:) forControlEvents:UIControlEventTouchUpInside];
                resultBtn.selected = NO;
            } else {
                [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_unable"] forState:UIControlStateSelected];
                resultBtn.selected = YES;
            }
            NSString *title = self.resultBtnTitleArr[i];
            if ([title containsString:@"无法"]) {
                [resultBtn setTitle:@" 无法开启\n 增氧设备" forState:UIControlStateNormal];
                resultBtn.titleLabel.numberOfLines = 2;
            } else if ([title containsString:@"泄露"]) {
                [resultBtn setTitle:@" 电解液泄露\n 或失效" forState:UIControlStateNormal];
                resultBtn.titleLabel.numberOfLines = 2;
            } else {
                [resultBtn setTitle:title forState:UIControlStateNormal];
            }
            [resultBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
            if (IS_IPHONE_SE) {
                resultBtn.titleLabel.font = JKFont(14);
            } else {
                resultBtn.titleLabel.font = JKFont(14);
            }
            
            resultBtn.tag = i;
            resultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
            [bgView addSubview:resultBtn];
            [resultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(30 * col);
                make.left.equalTo(bgView.mas_left).offset((width + 10) * row);
                make.size.mas_equalTo(CGSizeMake(width, 30));
            }];
        }
        if (self.repaireType == JKRepaireIng) {
            [self.resultTV removeFromSuperview];
            UITextView *resultTV = [[UITextView alloc] init];
            resultTV.font = JKFont(14);
            resultTV.textColor = RGBHex(0x666666);
            resultTV.layer.borderColor = RGBHex(0xdddddd).CGColor;
            resultTV.layer.borderWidth = 1;
            [resultTV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
            resultTV.delegate = self;
            [cell addSubview:resultTV];
            [resultTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_bottom).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(bgView.mas_left);
                make.bottom.equalTo(cell).offset(-10);
            }];
            self.resultTV = resultTV;
        } else {
            UILabel *resultLb = [[UILabel alloc] init];
            resultLb.text = @"由于机器突然宕机导致,数据检测出现问题重启设备后";
            resultLb.textColor = RGBHex(0x333333);
            resultLb.textAlignment = NSTextAlignmentLeft;
            resultLb.numberOfLines = 0;
//            resultLb.adjustsFontSizeToFitWidth = YES;
            resultLb.font = JKFont(14);
            [cell addSubview:resultLb];
            [resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_bottom).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(bgView.mas_left);
                make.bottom.equalTo(cell).offset(-10);
            }];
        }

    } else if (indexPath.row == 3) {
        [self.fixContentLb removeFromSuperview];
        UILabel *fixContentLb = [[UILabel alloc] init];
        fixContentLb.text = @"维修内容";
        fixContentLb.textColor = RGBHex(0x333333);
        fixContentLb.textAlignment = NSTextAlignmentLeft;
        fixContentLb.font = JKFont(14);
        [cell addSubview:fixContentLb];
        [fixContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(70);
            make.height.mas_equalTo(48);
        }];
        self.fixContentLb = fixContentLb;
        
        [self.fixBgView removeFromSuperview];
        UIView *bgView = [[UIView alloc] init];
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(10);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(fixContentLb.mas_right);
            make.height.mas_equalTo((self.contentBtnTitleArr.count / 2 + self.contentBtnTitleArr.count % 2) * 30);
        }];
        self.fixBgView = bgView;
        
        CGFloat width = (SCREEN_WIDTH - SCALE_SIZE(30) - 70) / 2;
        
        for (NSInteger i = 0; i < self.contentBtnTitleArr.count; i++) {
            NSInteger col = i / 2;
            NSInteger row = i % 2;
            
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [contentBtn setImage:[UIImage imageNamed:@"ic_device_more_select_off"] forState:UIControlStateNormal];
            if (self.repaireType == JKRepaireIng) {
                [contentBtn setImage:[UIImage imageNamed:@"ic_device_more_select_on"] forState:UIControlStateSelected];
                [contentBtn addTarget:self action:@selector(moreContentSelected:) forControlEvents:UIControlEventTouchUpInside];
                contentBtn.selected = NO;
            } else {
                [contentBtn setImage:[UIImage imageNamed:@"ic_device_more_select_unable"] forState:UIControlStateSelected];
                contentBtn.selected = YES;
            }
            [contentBtn setTitle:self.contentBtnTitleArr[i] forState:UIControlStateNormal];
            [contentBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
            if (IS_IPHONE_SE) {
                contentBtn.titleLabel.font = JKFont(14);
            } else {
                contentBtn.titleLabel.font = JKFont(14);
            }
            contentBtn.tag = i;
            contentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
            [bgView addSubview:contentBtn];
            [contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(30 * col);
                make.left.equalTo(bgView.mas_left).offset((width + 10) * row);
                make.size.mas_equalTo(CGSizeMake(width, 30));
            }];
        }
        
        if (self.repaireType == JKRepaireIng) {
            [self.contentTV removeFromSuperview];
            UITextView *contentTV = [[UITextView alloc] init];
            contentTV.font = JKFont(14);
            contentTV.textColor = RGBHex(0x666666);
            contentTV.layer.borderColor = RGBHex(0xdddddd).CGColor;
            contentTV.layer.borderWidth = 1;
            contentTV.delegate = self;
            [contentTV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
            [cell addSubview:contentTV];
            [contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_bottom).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(bgView.mas_left);
                make.bottom.equalTo(cell).offset(-10);
            }];
            self.contentTV = contentTV;
        } else {
            UILabel *contentLb = [[UILabel alloc] init];
            contentLb.text = @"由于机器突然宕机导致,数据检测出现问题重启设备后";
            contentLb.textColor = RGBHex(0x333333);
            contentLb.textAlignment = NSTextAlignmentLeft;
            contentLb.numberOfLines = 0;
            contentLb.font = JKFont(14);
            [cell addSubview:contentLb];
            [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_bottom).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(bgView.mas_left);
                make.bottom.equalTo(cell).offset(-10);
            }];
        }
        
    } else if (indexPath.row == 4) {
        if (self.repaireType == JKRepaireIng) {
            
            UILabel *remarkLb = [[UILabel alloc] init];
            remarkLb.text = @"备注";
            remarkLb.textColor = RGBHex(0x333333);
            remarkLb.textAlignment = NSTextAlignmentLeft;
            remarkLb.font = JKFont(14);
            [cell addSubview:remarkLb];
            [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.left.equalTo(cell).offset(15);
                make.width.mas_offset(70);
                make.height.mas_equalTo(48);
            }];
            
            [self.remarkTV removeFromSuperview];
            UITextView *remarkTV = [[UITextView alloc] init];
            remarkTV.font = JKFont(14);
            remarkTV.textColor = RGBHex(0x666666);
            remarkTV.layer.borderColor = RGBHex(0xdddddd).CGColor;
            remarkTV.layer.borderWidth = 1;
            [remarkTV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
            remarkTV.delegate = self;
            [cell addSubview:remarkTV];
            [remarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(remarkLb.mas_right);
                make.bottom.equalTo(cell).offset(-10);
            }];
            self.remarkTV = remarkTV;
            
        } else {
            cell.textLabel.text = @"备注";
            
            UILabel *remarkLb = [[UILabel alloc] init];
            remarkLb.text = @"由于机器突然宕机导致,数据检测出现问题重启设备后";
            remarkLb.textColor = RGBHex(0x333333);
            remarkLb.textAlignment = NSTextAlignmentLeft;
            remarkLb.numberOfLines = 0;
            remarkLb.font = JKFont(14);
            [cell addSubview:remarkLb];
            [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.right.equalTo(cell).offset(-SCALE_SIZE(15));
                make.left.equalTo(cell.mas_left).offset(15 + 70);
                make.bottom.equalTo(cell);
            }];
        }
        
    } else if (indexPath.row == 5) {
        [self.orderRemarkLb removeFromSuperview];
        [self.orderScrollView removeFromSuperview];
        UILabel *remarkLb = [[UILabel alloc] init];
        if (self.repaireType == JKRepaireIng) {
            remarkLb.text = @"上传维修单";
        } else {
            remarkLb.text = @"维修单";
        }
        remarkLb.textColor = RGBHex(0x333333);
        remarkLb.textAlignment = NSTextAlignmentLeft;
        remarkLb.font = JKFont(14);
        [cell addSubview:remarkLb];
        [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(48);
        }];
        self.orderRemarkLb = remarkLb;
        
        if (self.repaireType == JKRepaireIng) {
            [self createScrollImageUI:remarkLb withCell:cell withImageType:JKImageTypeRepaireFixOrder withImageArr:self.imageFixOrderURL];
        } else {
            
        }
        
    } else if (indexPath.row == 6) {
        [self.receiptRemarkLb removeFromSuperview];
        [self.receiptScrollView removeFromSuperview];
        UILabel *remarkLb = [[UILabel alloc] init];
        if (self.repaireType == JKRepaireIng) {
            remarkLb.text = @"上传收款数据";
        } else {
            remarkLb.text = @"收款数据";
        }
        remarkLb.textColor = RGBHex(0x333333);
        remarkLb.textAlignment = NSTextAlignmentLeft;
        remarkLb.font = JKFont(14);
        [cell addSubview:remarkLb];
        [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(48);
        }];
        self.receiptRemarkLb = remarkLb;
        
        if (self.repaireType == JKRepaireIng) {
            [self createScrollImageUI:remarkLb withCell:cell withImageType:JKImageTypeRepaireReceipt withImageArr:self.imageReceiptURL];
        } else {
            
        }
    }
    return cell;
}

- (void)createScrollImageUI:(UILabel *)titleLb withCell:(UITableViewCell *)cell withImageType:(JKImageType)imageType withImageArr:(NSMutableArray *)imgArr {
    if (imageType == JKImageTypeRepaireFixOrder) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.orderScrollView = scrollView;
        
        if (imgArr.count == 0) {
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, 80, 80);
            addBtn.tag = imageType;
            [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:addBtn];
        } else {
            if (imgArr.count == 9) {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn addTarget:self action:@selector(showFixOrderImgClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                }
            } else {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn addTarget:self action:@selector(showFixOrderImgClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    
                    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                    addBtn.tag = imageType;
                    [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                    [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:addBtn];
                }
            }
        }
    } else if (imageType == JKImageTypeRepaireReceipt) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.receiptScrollView = scrollView;
        
        if (imgArr.count == 0) {
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(0, 0, 80, 80);
            addBtn.tag = imageType;
            [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:addBtn];
        } else {
            if (imgArr.count == 9) {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn addTarget:self action:@selector(showReceiptImgClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 10;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                }
            } else {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn addTarget:self action:@selector(showReceiptImgClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 10;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    
                    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                    addBtn.tag = imageType;
                    [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                    [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:addBtn];
                }
            }
        }
    }
}
               
- (void)btnClick:(UIButton *)btn {
   if (btn.tag == JKImageTypeRepaireFixOrder) {
       
       [self.fixOrderHelper showImagePickerControllerWithMaxCount:(9 - self.imageFixOrderArr.count) WithViewController:[self View:self]];
   } else if (btn.tag == JKImageTypeRepaireReceipt) {
       [self.receiptHelper showImagePickerControllerWithMaxCount:(9 - self.imageReceiptArr.count) WithViewController:[self View:self]];
   }
}

- (void)showFixOrderImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageFixOrderURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)showReceiptImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageReceiptURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

#pragma mark -- view对应的UIViewController
- (UIViewController *)View:(UIView *)view {
   UIResponder *responder = view;
   while ((responder = [responder nextResponder])) {
       if ([responder isKindOfClass:[UIViewController class]]) {
           return (UIViewController *)responder;
       }
   }
   return nil;
}

- (void)deleteBtnClick:(UIButton *)btn {
   if (btn.tag <= 9) {
       [self.imageFixOrderURL removeObjectAtIndex:btn.tag];
       [self.imageFixOrderArr removeObjectAtIndex:btn.tag];
       NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
       NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
       [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
   } else if (btn.tag <= 19) {
       [self.imageReceiptURL removeObjectAtIndex:(btn.tag - 10)];
       [self.imageReceiptArr removeObjectAtIndex:(btn.tag - 10)];
       NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
       NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
       [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
   }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }

    return YES;
}

@end
