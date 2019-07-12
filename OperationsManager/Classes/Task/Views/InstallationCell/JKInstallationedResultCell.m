//
//  JKInstallationedResultCell.m
//  OperationsManager
//
//  Created by    on 2018/8/27.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKInstallationedResultCell.h"
#import "JKInstallInfoModel.h"

@interface JKInstallationedResultCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *orderStr;
@property (nonatomic, strong) NSString *finishStr;
@property (nonatomic, strong) NSString *txtUrls;
@property (nonatomic, strong) NSString *txtPaymentMethodS;
@property (nonatomic, strong) NSString *txtNoteS;
@property (nonatomic, strong) NSString *txtPaymentUrlS;
@property (nonatomic, strong) NSString *txtPaymentMethodD;
@property (nonatomic, strong) NSString *txtNoteD;
@property (nonatomic, strong) NSString *txtPaymentUrlD;
@property (nonatomic, strong) NSString *txtRelaceAmoutD;
@property (nonatomic, strong) NSString *txtRelaceAmoutS;
@end

@implementation JKInstallationedResultCell

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
        
        self.titleArr = @[@"处理结果", @"接单时间", @"实际完成时间", @"", @"", @""];
    }
    return self;
}

- (void)getModel:(JKInstallInfoModel *)model {
    
    self.orderStr = model.txtReciptTime;
    self.finishStr = model.calInstallationTime;
    self.txtUrls = model.txtUrls;
    self.txtPaymentMethodS = model.txtPaymentMethodS;
    self.txtNoteS = model.txtServiceRemark;
    self.txtPaymentUrlS = model.txtPaymentUrlS;
    self.txtPaymentMethodD = model.txtPaymentMethodD;
    self.txtNoteD = model.txtDepositRemark;
    self.txtPaymentUrlD = model.txtPaymentUrlD;
    self.txtRelaceAmoutD = model.txtRelaceAmoutD;
    self.txtRelaceAmoutS = model.txtRelaceAmoutS;
    
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
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 180;
    } else if (indexPath.row == 4) {
        if (self.hasPayServiceFree) {
            return 188;
        } else {
            return 48;
        }
    } else if (indexPath.row == 3) {
        if (self.hasPayDepositFree) {
            return 188;
        } else {
            return 48;
        }
    } else {
        return 48;
    }
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
    cell.detailTextLabel.textColor = RGBHex(0x666666);
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.font = JKFont(14);

    if (indexPath.row == 0) {
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.orderStr];
    } else if (indexPath.row == 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.finishStr];
    } else if (indexPath.row == 4) {
//        UISwitch *serviceSwitch = [[UISwitch alloc] init];
//        serviceSwitch.transform = CGAffineTransformMakeScale( 0.7, 0.7);
//        if (!self.hasPayServiceFree) {
//            [serviceSwitch setOn:NO];
//        } else {
//            [serviceSwitch setOn:YES];
//        }
//        serviceSwitch.enabled = NO;
//        [cell addSubview:serviceSwitch];
//        [serviceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(cell.mas_top).offset(9);
//            make.right.equalTo(cell).mas_offset(-15);
//        }];
        
        UILabel *serviceFreeLb = [[UILabel alloc] init];
        if (!self.hasPayServiceFree) {
            serviceFreeLb.text = @"否";
        } else {
            serviceFreeLb.text = @"是";
        }
        serviceFreeLb.textColor = RGBHex(0x666666);
        serviceFreeLb.textAlignment = NSTextAlignmentRight;
        serviceFreeLb.font = JKFont(14);
        [cell addSubview:serviceFreeLb];
        [serviceFreeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.right.equalTo(cell).offset(-15);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(48);
        }];
        
        UILabel *serviceLb = [[UILabel alloc] init];
        if ([self.txtRelaceAmoutS isEqualToString:@"0"]) {
            serviceLb.text = @"是否代收服务费";
        } else {
            serviceLb.text = [NSString stringWithFormat:@"是否代收服务费    ￥%@", self.txtRelaceAmoutS];
        }
        serviceLb.textColor = RGBHex(0x333333);
        serviceLb.textAlignment = NSTextAlignmentLeft;
        serviceLb.font = JKFont(14);
        [cell addSubview:serviceLb];
        [serviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(serviceFreeLb.mas_centerY);
            make.left.equalTo(cell).offset(15);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(20);
        }];
        
        if (self.hasPayServiceFree) {
            UIView *serviceV = [[UIView alloc] init];
            [cell addSubview:serviceV];
            [serviceV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(48);
                make.left.right.equalTo(cell);
                make.bottom.equalTo(cell);
            }];
            
            UILabel *lineLb = [[UILabel alloc] init];
            lineLb.backgroundColor = RGBHex(0xdddddd);
            [cell addSubview:lineLb];
            [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serviceV.mas_top).offset(-0.5);
                make.left.equalTo(cell).offset(15);
                make.right.equalTo(cell).offset(-15);
                make.height.mas_equalTo(0.5);
            }];
            
            UILabel *serverFreePaymentLb = [[UILabel alloc] init];
            serverFreePaymentLb.text = [NSString stringWithFormat:@"收款方式: %@",self.txtPaymentMethodS];
            serverFreePaymentLb.textColor = RGBHex(0x333333);
            serverFreePaymentLb.textAlignment = NSTextAlignmentLeft;
            serverFreePaymentLb.font = JKFont(13);
            [serviceV addSubview:serverFreePaymentLb];
            [serverFreePaymentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serviceV.mas_top).offset(12);
                make.left.equalTo(serviceV).offset(15);
                make.right.equalTo(serviceV).offset(-15);
                make.height.mas_equalTo(20);
            }];
            
            UILabel *serverFreeRemarkLb = [[UILabel alloc] init];
            serverFreeRemarkLb.text = [NSString stringWithFormat:@"备注: %@",self.txtNoteS];
            serverFreeRemarkLb.textColor = RGBHex(0x333333);
            serverFreeRemarkLb.textAlignment = NSTextAlignmentLeft;
            serverFreeRemarkLb.font = JKFont(13);
            [serviceV addSubview:serverFreeRemarkLb];
            [serverFreeRemarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serverFreePaymentLb.mas_bottom);
                make.left.equalTo(serviceV).offset(15);
                make.right.equalTo(serviceV).offset(-15);
                make.height.mas_equalTo(20);
            }];
            
            UILabel *serverFreeAnnxLb = [[UILabel alloc] init];
            serverFreeAnnxLb.text = @"附件:";
            serverFreeAnnxLb.textColor = RGBHex(0x333333);
            serverFreeAnnxLb.textAlignment = NSTextAlignmentLeft;
            serverFreeAnnxLb.font = JKFont(13);
            [serviceV addSubview:serverFreeAnnxLb];
            [serverFreeAnnxLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serverFreeRemarkLb.mas_bottom);
                make.left.equalTo(serviceV).offset(15);
                make.right.equalTo(serviceV).offset(-15);
                make.height.mas_equalTo(20);
            }];
            
            if (self.txtPaymentUrlS.length != 0) {
                self.txtPaymentUrlS = [self.txtPaymentUrlS stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSArray *txtPaymentUrlS = [self.txtPaymentUrlS componentsSeparatedByString:@","];
                
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.backgroundColor = kWhiteColor;
                [cell addSubview:scrollView];
                [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(serverFreeAnnxLb.mas_bottom).offset(5);
                    make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                    make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                    make.height.mas_equalTo(50);
                }];
                
                scrollView.contentSize = CGSizeMake(60 * txtPaymentUrlS.count, 50);
                
                for (NSInteger i = 0; i < txtPaymentUrlS.count; i++) {
                    UIImageView *imgV = [[UIImageView alloc] init];
                    imgV.frame = CGRectMake(60 * i , 0, 50, 50);
                    imgV.userInteractionEnabled = YES;
                    imgV.yy_imageURL = [NSURL URLWithString:txtPaymentUrlS[i]];
                    imgV.contentMode = UIViewContentModeScaleAspectFit;
                    [scrollView addSubview:imgV];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(0 , 0, 80, 80);
                    btn.tag = i;
                    [btn addTarget:self action:@selector(sBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [imgV addSubview:btn];
                }
            }
            }
            

    } else if (indexPath.row == 3) {
        UILabel *depositFreeLb = [[UILabel alloc] init];
        if (!self.hasPayDepositFree) {
            depositFreeLb.text = @"否";
        } else {
            depositFreeLb.text = @"是";
        }
        depositFreeLb.textColor = RGBHex(0x666666);
        depositFreeLb.textAlignment = NSTextAlignmentRight;
        depositFreeLb.font = JKFont(14);
        [cell addSubview:depositFreeLb];
        [depositFreeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.right.equalTo(cell).offset(-15);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(48);
        }];
        
        UILabel *depositLb = [[UILabel alloc] init];
        if ([self.txtRelaceAmoutD isEqualToString:@"0"]) {
            depositLb.text = @"是否代收押金费";
        } else {
            depositLb.text = [NSString stringWithFormat:@"是否代收押金费    ￥%@", self.txtRelaceAmoutD];
        }
        depositLb.textColor = RGBHex(0x333333);
        depositLb.textAlignment = NSTextAlignmentLeft;
        depositLb.font = JKFont(14);
        [cell addSubview:depositLb];
        [depositLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(depositFreeLb.mas_centerY);
            make.left.equalTo(cell).offset(15);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(20);
        }];
        
        if (self.hasPayDepositFree) {
            UIView *serviceV = [[UIView alloc] init];
            [cell addSubview:serviceV];
            [serviceV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(48);
                make.left.right.equalTo(cell);
                make.bottom.equalTo(cell);
            }];
            
            UILabel *lineLb = [[UILabel alloc] init];
            lineLb.backgroundColor = RGBHex(0xdddddd);
            [cell addSubview:lineLb];
            [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serviceV.mas_top).offset(-0.5);
                make.left.equalTo(cell).offset(15);
                make.right.equalTo(cell).offset(-15);
                make.height.mas_equalTo(0.5);
            }];
            
            UILabel *serverFreePaymentLb = [[UILabel alloc] init];
            serverFreePaymentLb.text = [NSString stringWithFormat:@"收款方式: %@",self.txtPaymentMethodD];
            serverFreePaymentLb.textColor = RGBHex(0x333333);
            serverFreePaymentLb.textAlignment = NSTextAlignmentLeft;
            serverFreePaymentLb.font = JKFont(13);
            [serviceV addSubview:serverFreePaymentLb];
            [serverFreePaymentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serviceV.mas_top).offset(12);
                make.left.equalTo(serviceV).offset(15);
                make.right.equalTo(serviceV).offset(-15);
                make.height.mas_equalTo(20);
            }];
            
            UILabel *serverFreeRemarkLb = [[UILabel alloc] init];
            serverFreeRemarkLb.text = [NSString stringWithFormat:@"备注: %@",self.txtNoteD];
            serverFreeRemarkLb.textColor = RGBHex(0x333333);
            serverFreeRemarkLb.textAlignment = NSTextAlignmentLeft;
            serverFreeRemarkLb.font = JKFont(13);
            [serviceV addSubview:serverFreeRemarkLb];
            [serverFreeRemarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serverFreePaymentLb.mas_bottom);
                make.left.equalTo(serviceV).offset(15);
                make.right.equalTo(serviceV).offset(-15);
                make.height.mas_equalTo(20);
            }];
            
            UILabel *serverFreeAnnxLb = [[UILabel alloc] init];
            serverFreeAnnxLb.text = @"附件:";
            serverFreeAnnxLb.textColor = RGBHex(0x333333);
            serverFreeAnnxLb.textAlignment = NSTextAlignmentLeft;
            serverFreeAnnxLb.font = JKFont(13);
            [serviceV addSubview:serverFreeAnnxLb];
            [serverFreeAnnxLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(serverFreeRemarkLb.mas_bottom);
                make.left.equalTo(serviceV).offset(15);
                make.right.equalTo(serviceV).offset(-15);
                make.height.mas_equalTo(20);
            }];
            
            if (self.txtPaymentUrlD.length != 0) {
                self.txtPaymentUrlD = [self.txtPaymentUrlD stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSArray *txtPaymentUrlD = [self.txtPaymentUrlD componentsSeparatedByString:@","];
                
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.backgroundColor = kWhiteColor;
                [cell addSubview:scrollView];
                [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(serverFreeAnnxLb.mas_bottom).offset(5);
                    make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                    make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                    make.height.mas_equalTo(50);
                }];
                
                scrollView.contentSize = CGSizeMake(60 * txtPaymentUrlD.count, 50);
                
                for (NSInteger i = 0; i < txtPaymentUrlD.count; i++) {
                    UIImageView *imgV = [[UIImageView alloc] init];
                    imgV.frame = CGRectMake(60 * i , 0, 50, 50);
                    imgV.userInteractionEnabled = YES;
                    //                imgV.backgroundColor = kRedColor;
                    imgV.yy_imageURL = [NSURL URLWithString:txtPaymentUrlD[i]];
                    imgV.contentMode = UIViewContentModeScaleAspectFit;
                    [scrollView addSubview:imgV];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(0 , 0, 80, 80);
                    btn.tag = i;
                    [btn addTarget:self action:@selector(dBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [imgV addSubview:btn];
                }
            }
            
        }

    } else {
        UILabel *orderLb = [[UILabel alloc] init];
        orderLb.text = @"附件图片";
        orderLb.textColor = RGBHex(0x333333);
        orderLb.textAlignment = NSTextAlignmentLeft;
        orderLb.font = JKFont(14);
        [cell addSubview:orderLb];
        [orderLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(20);
        }];
        
        if (self.txtUrls.length != 0) {
            self.txtUrls = [self.txtUrls stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *orderPicArr = [self.txtUrls componentsSeparatedByString:@","];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.backgroundColor = kWhiteColor;
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(orderLb.mas_bottom).offset(SCALE_SIZE(10));
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
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }

    }
    
    return cell;
}

- (void)btnClick:(UIButton *)btn {
    self.txtUrls = [self.txtUrls stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *orderPicArr = [self.txtUrls componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:orderPicArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)sBtnClick:(UIButton *)btn {
    self.txtPaymentUrlS = [self.txtPaymentUrlS stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *orderPicArr = [self.txtPaymentUrlS componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:orderPicArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)dBtnClick:(UIButton *)btn {
    self.txtPaymentUrlD = [self.txtPaymentUrlD stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *orderPicArr = [self.txtPaymentUrlD componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:orderPicArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

@end
