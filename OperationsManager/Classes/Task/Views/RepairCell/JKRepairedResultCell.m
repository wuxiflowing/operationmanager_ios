//
//  JKRepairedResultCell.m
//  OperationsManager
//
//  Created by    on 2018/8/27.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRepairedResultCell.h"
#import "JKRepaireInfoModel.h"

@interface JKRepairedResultCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *resultBtnTitleArr;
@property (nonatomic, strong) NSMutableArray *contentBtnTitleArr;

@property (nonatomic, assign) BOOL rdoSelfYes;
@property (nonatomic, strong) NSString *txtResMulti;
@property (nonatomic, strong) NSString *tarResOth;
@property (nonatomic, strong) NSString *txtConMulti;
@property (nonatomic, strong) NSString *tarConOth;
@property (nonatomic, strong) NSString *tarRemarks;
@property (nonatomic, strong) NSString *txtRepairFormImg;
@property (nonatomic, strong) NSString *txtReceiptImg;
@property (nonatomic, strong) NSString *txtEndDate;
@property (nonatomic, strong) NSString *txtStartDate;
@property (nonatomic, assign) BOOL isNew;

@end

@implementation JKRepairedResultCell

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


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        [self getIssueList];
        [self getRepairList];
    }
    return self;
}

- (void)createUI:(JKRepaireInfoModel *)model {
    self.rdoSelfYes = model.rdoSelfYes;
    self.txtResMulti = model.txtResMulti;
    self.tarResOth = model.tarResOth;
    self.txtConMulti = model.txtConMulti;
    self.tarConOth = model.tarConOth;
    self.tarRemarks = model.tarRemarks;
    self.txtRepairFormImg = model.txtRepairFormImg;
    self.txtReceiptImg = model.txtReceiptImg;
    self.txtEndDate = model.txtEndDate;
    self.txtStartDate = model.txtStartDate;
    if ([model.txtNewID isEqualToString:@""]) {
        self.isNew = NO;
    } else {
        self.isNew = YES;
    }
    
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        return 50;
    } else if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6) {
        return 50;
    } else if (indexPath.row == 8 || indexPath.row == 9) {
        return 140;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
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
        cell.textLabel.text = @"接单时间";
        cell.detailTextLabel.text = self.txtStartDate;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"完成时间";
        cell.detailTextLabel.text = self.txtEndDate;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"处理方式";
        if (!self.rdoSelfYes) {
            cell.detailTextLabel.text = @"现场解决";
        } else {
            cell.detailTextLabel.text = @"养殖户自行解决";
        }
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"是否更换设备";
        if (self.isNew) {
            cell.detailTextLabel.text = @"是";
        } else {
            cell.detailTextLabel.text = @"否";
        }
    } else if (indexPath.row == 5) {
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
            make.height.mas_equalTo(50);
        }];

        UILabel *resultLb = [[UILabel alloc] init];
        resultLb.text = [NSString stringWithFormat:@"%@\n%@",self.txtResMulti, self.tarResOth];
        resultLb.textColor = RGBHex(0x888888);
        resultLb.textAlignment = NSTextAlignmentRight;
        resultLb.numberOfLines = 0;
//        resultLb.adjustsFontSizeToFitWidth = YES;
        resultLb.font = JKFont(14);
        [cell addSubview:resultLb];
        [resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(issueResultLb.mas_top);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(issueResultLb.mas_right).offset(10);
            make.height.mas_equalTo(50);
        }];
        
    } else if (indexPath.row == 6) {
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
            make.height.mas_equalTo(50);
        }];
        
        UILabel *contentLb = [[UILabel alloc] init];
        contentLb.text = [NSString stringWithFormat:@"%@\n%@",self.txtConMulti, self.tarConOth];
        contentLb.textColor = RGBHex(0x888888);
        contentLb.textAlignment = NSTextAlignmentRight;
        contentLb.numberOfLines = 0;
//        contentLb.adjustsFontSizeToFitWidth = YES;
        contentLb.font = JKFont(14);
        [cell addSubview:contentLb];
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fixContentLb.mas_top);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(fixContentLb.mas_right).offset(10);
            make.height.mas_equalTo(50);
        }];
        
    } else if (indexPath.row == 7) {
        cell.textLabel.text = @"备注";
        
        UILabel *remarkLb = [[UILabel alloc] init];
        remarkLb.text = self.tarRemarks;
        remarkLb.textColor = RGBHex(0x888888);
        remarkLb.textAlignment = NSTextAlignmentRight;
        remarkLb.numberOfLines = 0;
//        remarkLb.adjustsFontSizeToFitWidth = YES;
        remarkLb.font = JKFont(14);
        [cell addSubview:remarkLb];
        [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.right.equalTo(cell).offset(-SCALE_SIZE(15));
            make.left.equalTo(cell.mas_left).offset(15 + 70);
            make.bottom.equalTo(cell);
        }];
        
    } else if (indexPath.row == 8) {
        UILabel *remarkLb = [[UILabel alloc] init];
        remarkLb.text = @"维修单";
        remarkLb.textColor = RGBHex(0x333333);
        remarkLb.textAlignment = NSTextAlignmentLeft;
        remarkLb.font = JKFont(14);
        [cell addSubview:remarkLb];
        [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(50);
        }];
        
        if (self.txtRepairFormImg.length != 0) {
            self.txtRepairFormImg = [self.txtRepairFormImg stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *orderPicArr = [self.txtRepairFormImg componentsSeparatedByString:@","];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.backgroundColor = kWhiteColor;
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(remarkLb.mas_bottom);
                make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(80);
            }];
            
            scrollView.contentSize = CGSizeMake(90 * orderPicArr.count, 80);
            
            for (NSInteger i = 0; i < orderPicArr.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(90 * i , 0, 80, 80);
                imgV.userInteractionEnabled = YES;
                imgV.yy_imageURL = [NSURL URLWithString:orderPicArr[i]];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [scrollView addSubview:imgV];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                btn.tag = i;
                [btn addTarget:self action:@selector(txtRepairFormImgClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }
    } else if (indexPath.row == 9) {
        UILabel *remarkLb = [[UILabel alloc] init];
        remarkLb.text = @"收款数据";
        remarkLb.textColor = RGBHex(0x333333);
        remarkLb.textAlignment = NSTextAlignmentLeft;
        remarkLb.font = JKFont(14);
        [cell addSubview:remarkLb];
        [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(50);
        }];
        
        if (self.txtReceiptImg.length != 0) {
            self.txtReceiptImg = [self.txtReceiptImg stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *orderPicArr = [self.txtReceiptImg componentsSeparatedByString:@","];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.backgroundColor = kWhiteColor;
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(remarkLb.mas_bottom);
                make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(80);
            }];
            
            scrollView.contentSize = CGSizeMake(90 * orderPicArr.count, 80);
            
            for (NSInteger i = 0; i < orderPicArr.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(90 * i , 0, 80, 80);
                imgV.userInteractionEnabled = YES;
                imgV.yy_imageURL = [NSURL URLWithString:orderPicArr[i]];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [scrollView addSubview:imgV];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                btn.tag = i;
                [btn addTarget:self action:@selector(txtReceiptImgClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }
    }
    return cell;
}

- (void)txtReceiptImgClick:(UIButton *)btn {
    self.txtReceiptImg = [self.txtReceiptImg stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *orderPicArr = [self.txtReceiptImg componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:orderPicArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)txtRepairFormImgClick:(UIButton *)btn {
    self.txtRepairFormImg = [self.txtRepairFormImg stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *orderPicArr = [self.txtRepairFormImg componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:orderPicArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}


@end
