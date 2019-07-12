//
//  JKResultCell.m
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKInstallationResultCell.h"
#import "TZImagePickerHelper.h"
#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKInstallationResultCell () <UITableViewDelegate, UITableViewDataSource,TZImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIScrollView *paymentScrollView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISwitch *serviceSwitch;
@property (nonatomic, strong) UISwitch *depositSwitch;
@property (nonatomic, strong) UILabel *serviceLb;
@property (nonatomic, strong) UILabel *depositLb;
@property (nonatomic, strong) UIView *serviceV;
@property (nonatomic, strong) UILabel *serverFreeLb;
@property (nonatomic, strong) UILabel *serverUnitLb;
@property (nonatomic, strong) UITextField *serverFreeTF;
@property (nonatomic, strong) UILabel *lineOneLb;
@property (nonatomic, strong) UITextField *serverRemarkTF;
@property (nonatomic, strong) UILabel *lineTwoLb;
@property (nonatomic, strong) UILabel *serverFreeReceiptLb;
@property (nonatomic, strong) UIView *depositV;
@property (nonatomic, strong) UILabel *depositFreeLb;
@property (nonatomic, strong) UILabel *depositUnitLb;
@property (nonatomic, strong) UITextField *depositFreeTF;
@property (nonatomic, strong) UILabel *lineThreeLb;
@property (nonatomic, strong) UITextField *depositRemarkTF;
@property (nonatomic, strong) UILabel *lineFourLb;
@property (nonatomic, strong) UILabel *depositFreeReceiptLb;
@property (nonatomic, strong) TZImagePickerHelper *orderHelper;
@property (nonatomic, strong) TZImagePickerHelper *serviceHelper;
@property (nonatomic, strong) TZImagePickerHelper *depositHelper;
@property (nonatomic, strong) NSMutableArray *imageOrderURL;
@property (nonatomic, strong) NSMutableArray *imageServiceURL;
@property (nonatomic, strong) NSMutableArray *imageDepositURL;
@property (nonatomic, strong) UIScrollView *orderScrollView;
@property (nonatomic, strong) UIScrollView *serviceScrollView;
@property (nonatomic, strong) UIScrollView *depositScrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *depositFreePaymentLb;
@property (nonatomic, strong) UILabel *serverFreePaymentLb;
@property (nonatomic, strong) UILabel *lineFiveLb;
@property (nonatomic, strong) UILabel *lineTopLb;
@property (nonatomic, strong) UILabel *resultLb;
@property (nonatomic, strong) UILabel *orderLb;
@property (nonatomic, strong) UIButton *serverRemitBtn;
@property (nonatomic, strong) UIButton *serverCashBtn;
@property (nonatomic, strong) UIButton *depositRemitBtn;
@property (nonatomic, strong) UIButton *depositCashBtn;

@end

@implementation JKInstallationResultCell

- (NSMutableArray *)imageOrderURL {
    if (!_imageOrderURL) {
        _imageOrderURL = [NSMutableArray array];
    }
    return _imageOrderURL;
}

- (NSMutableArray *)imageServiceURL {
    if (!_imageServiceURL) {
        _imageServiceURL = [NSMutableArray array];
    }
    return _imageServiceURL;
}

- (NSMutableArray *)imageDepositURL {
    if (!_imageDepositURL) {
        _imageDepositURL = [NSMutableArray array];
    }
    return _imageDepositURL;
}

- (NSMutableArray *)imageOrderArr {
    if (!_imageOrderArr) {
        _imageOrderArr = [NSMutableArray array];
    }
    return _imageOrderArr;
}

- (NSMutableArray *)imageServiceArr {
    if (!_imageServiceArr) {
        _imageServiceArr = [NSMutableArray array];
    }
    return _imageServiceArr;
}

- (NSMutableArray *)imageDepositArr {
    if (!_imageDepositArr) {
        _imageDepositArr = [NSMutableArray array];
    }
    return _imageDepositArr;
}

- (UIScrollView *)paymentScrollView {
    if (!_paymentScrollView) {
        _paymentScrollView = [[UIScrollView alloc] init];
        _paymentScrollView.showsHorizontalScrollIndicator = NO;
        _paymentScrollView.backgroundColor = kWhiteColor;
    }
    return _paymentScrollView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
}

- (TZImagePickerHelper *)orderHelper {
    if (!_orderHelper) {
        _orderHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _orderHelper.imageType = JKImageTypeInstallOrder;
        _orderHelper.finishInstallOrder = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageOrderURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageOrderArr addObject:str];
            }
            //            [weakSelf saveImage:imageArr withImageType:JKImageTypeAccount];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _orderHelper;
}

- (TZImagePickerHelper *)serviceHelper {
    if (!_serviceHelper) {
        _serviceHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _serviceHelper.imageType = JKImageTypeInstallService;
        _serviceHelper.finishInstallService = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageServiceURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageServiceArr addObject:str];
            }
            //            [weakSelf saveImage:imageArr withImageType:JKImageTypeAccount];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.isServiceFree) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                    [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
                }
            });
        };
    }
    return _serviceHelper;
}

- (TZImagePickerHelper *)depositHelper {
    if (!_depositHelper) {
        _depositHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _depositHelper.imageType = JKImageTypeInstallDeposit;
        _depositHelper.finishInstallDeposit = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageDepositURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageDepositArr addObject:str];
            }
            //            [weakSelf saveImage:imageArr withImageType:JKImageTypeAccount];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.isDepositFree) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                    [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
                }
            });
        };
    }
    return _depositHelper;
}

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

        self.isChooseServerRemit = NO;
        self.isChooseDepositRemit = NO;
        
        [self.bgView removeFromSuperview];
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kWhiteColor;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.right.bottom.equalTo(self);
        }];
        self.bgView = bgView;
        
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        [bgView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(bgView);
        }];
    }
    return self;
}

#pragma mark -- textField
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *textField = (UITextField *)[notification object];
    if (textField.tag == 0) {
        self.serverFreeStr = textField.text;
    } else if (textField.tag == 1) {
        self.serverRemarkStr = textField.text;
    } else if (textField.tag == 2) {
        self.depositFreeStr = textField.text;
    } else if (textField.tag == 3) {
        self.depositRemarkStr = textField.text;
    }
}

- (void)serverPaymentMethodSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.serverCashBtn.selected = NO;
        } else {
            self.serverRemitBtn.selected = NO;
        }
        self.isChooseServerRemit = !self.isChooseServerRemit;
    }
    [self.tableView reloadData];
    [self.tableView endUpdates];
}

- (void)depositPaymentMethodSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.depositCashBtn.selected = NO;
        } else {
            self.depositRemitBtn.selected = NO;
        }
        self.isChooseDepositRemit = !self.isChooseDepositRemit;
    }

    [self.tableView reloadData];
    [self.tableView endUpdates];
}

#pragma mark -- 服务费
- (void)serviceSwitch:(UISwitch *)sender {
    if (sender.isOn) {
        self.isServiceFree = YES;
        [self.tableView reloadData];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadServiceCellHeight" object:nil userInfo:@{@"serviceHeight":@"348"}]];
        
    } else {
        self.isServiceFree = NO;
        [self.tableView reloadData];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadServiceCellHeight" object:nil userInfo:@{@"serviceHeight":@"48"}]];
    }
}

#pragma mark -- 押金费
- (void)depositSwitch:(UISwitch *)sender {
    if (sender.isOn) {
        self.isDepositFree = YES;
        [self.tableView reloadData];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadDepositCellHeight" object:nil userInfo:@{@"depositHeight":@"348"}]];
    } else {
        self.isDepositFree = NO;
        [self.tableView reloadData];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadDepositCellHeight" object:nil userInfo:@{@"depositHeight":@"48"}]];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 48;
    } else if (indexPath.row == 1) {
        return 125;
    } else {
        if (indexPath.row == 3) {
            if (!self.isServiceFree) {
                return 48;
            } else {
                return 348;
            }
        } else {
            if (!self.isDepositFree) {
                return 48;
            } else {
                return 348;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        [self.resultLb removeFromSuperview];
        UILabel *resultLb = [[UILabel alloc] init];
        resultLb.text = @"处理结果";
        resultLb.textColor = RGBHex(0x333333);
        resultLb.textAlignment = NSTextAlignmentLeft;
        resultLb.font = JKFont(16);
        [cell addSubview:resultLb];
        [resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(10);
            make.left.equalTo(cell).offset(15);
            make.right.equalTo(cell).offset(-15);
            make.height.mas_equalTo(20);
        }];
        self.resultLb = resultLb;
    } else if (indexPath.row == 1) {
        [self.orderLb removeFromSuperview];
        UILabel *orderLb = [[UILabel alloc] init];
        orderLb.text = @"上传确认单";
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
        self.orderLb = orderLb;
        
        [self createScrollImageUI:orderLb withCell:cell withImageType:JKImageTypeInstallOrder withImageArr:self.imageOrderURL];
    
    } else {
        if (indexPath.row == 3) {
            [self.serviceSwitch removeFromSuperview];
            UISwitch *serviceSwitch = [[UISwitch alloc] init];
            serviceSwitch.transform = CGAffineTransformMakeScale( 0.7, 0.7);
            if (!self.isServiceFree) {
                [serviceSwitch setOn:NO];
            } else {
                [serviceSwitch setOn:YES];
            }
            [serviceSwitch addTarget:self action:@selector(serviceSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:serviceSwitch];
            [serviceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(9);
                make.right.equalTo(cell).mas_offset(-15);
            }];
            self.serviceSwitch = serviceSwitch;
            
            [self.serviceLb removeFromSuperview];
            UILabel *serviceLb = [[UILabel alloc] init];
            serviceLb.text = @"是否收取服务费";
            serviceLb.textColor = RGBHex(0x333333);
            serviceLb.textAlignment = NSTextAlignmentLeft;
            serviceLb.font = JKFont(14);
            [cell addSubview:serviceLb];
            [serviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(serviceSwitch.mas_centerY);
                make.left.equalTo(cell).offset(15);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(20);
            }];
            self.serviceLb = serviceLb;
            
            if (self.isServiceFree) {
                [self.serviceV removeFromSuperview];
                UIView *serviceV = [[UIView alloc] init];
                [cell addSubview:serviceV];
                [serviceV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).offset(48);
                    make.left.right.equalTo(cell);
                    make.bottom.equalTo(cell);
                }];
                [self.serviceV addSubview:serviceV];

                UILabel *lineLb = [[UILabel alloc] init];
                lineLb.backgroundColor = RGBHex(0xdddddd);
                [cell addSubview:lineLb];
                [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(serviceV.mas_top).offset(-0.5);
                    make.left.equalTo(cell).offset(15);
                    make.right.equalTo(cell).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];

                [self.serverFreePaymentLb removeFromSuperview];
                UILabel *serverFreePaymentLb = [[UILabel alloc] init];
                serverFreePaymentLb.text = @"收款方式";
                serverFreePaymentLb.textColor = RGBHex(0x333333);
                serverFreePaymentLb.textAlignment = NSTextAlignmentLeft;
                serverFreePaymentLb.font = JKFont(14);
                [serviceV addSubview:serverFreePaymentLb];
                [serverFreePaymentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(serviceV.mas_top).offset(12);
                    make.left.equalTo(serviceV).offset(15);
                    make.right.equalTo(serviceV).offset(-15);
                    make.height.mas_equalTo(20);
                }];
                self.serverFreePaymentLb = serverFreePaymentLb;

                [self.serverRemitBtn removeFromSuperview];
                UIButton *serverRemitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [serverRemitBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
                [serverRemitBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
                [serverRemitBtn setTitle:@"  银行汇款" forState:UIControlStateNormal];
                [serverRemitBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
                [serverRemitBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
                serverRemitBtn.titleLabel.font = JKFont(14);
                serverRemitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                serverRemitBtn.tag = 1;
                if (self.isChooseServerRemit) {
                    serverRemitBtn.selected = YES;
                } else {
                    serverRemitBtn.selected = NO;
                }
                [serverRemitBtn addTarget:self action:@selector(serverPaymentMethodSelected:) forControlEvents:UIControlEventTouchUpInside];
                [serviceV addSubview:serverRemitBtn];
                [serverRemitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(serverFreePaymentLb.mas_centerY);
                    make.right.equalTo(serviceV.mas_right).offset(-15);
                    make.size.mas_equalTo(CGSizeMake(100, 30));
                }];
                self.serverRemitBtn = serverRemitBtn;
                
                [self.serverCashBtn removeFromSuperview];
                UIButton *serverCashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [serverCashBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
                [serverCashBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
                [serverCashBtn setTitle:@"  现金" forState:UIControlStateNormal];
                [serverCashBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
                [serverCashBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
                serverCashBtn.titleLabel.font = JKFont(14);
                serverCashBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                serverCashBtn.tag = 0;
                if (self.isChooseServerRemit) {
                    serverCashBtn.selected = NO;
                } else {
                    serverCashBtn.selected = YES;
                }
                [serverCashBtn addTarget:self action:@selector(serverPaymentMethodSelected:) forControlEvents:UIControlEventTouchUpInside];
                [serviceV addSubview:serverCashBtn];
                [serverCashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(serverFreePaymentLb.mas_centerY);
                    make.right.equalTo(serverRemitBtn.mas_left).offset(-5);
                    make.size.mas_equalTo(CGSizeMake(60, 30));
                }];
                self.serverCashBtn = serverCashBtn;

                [self.lineTopLb removeFromSuperview];
                UILabel *lineTopLb = [[UILabel alloc] init];
                lineTopLb.backgroundColor = RGBHex(0xdddddd);
                [serviceV addSubview:lineTopLb];
                [lineTopLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(serverFreePaymentLb.mas_bottom).offset(12);
                    make.left.equalTo(cell).offset(15);
                    make.right.equalTo(cell).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];
                self.lineTopLb = lineTopLb;

                [self.serverFreeLb removeFromSuperview];
                UILabel *serverFreeLb = [[UILabel alloc] init];
                serverFreeLb.text = @"实收金额";
                serverFreeLb.textColor = RGBHex(0x333333);
                serverFreeLb.textAlignment = NSTextAlignmentLeft;
                serverFreeLb.font = JKFont(14);
                [serviceV addSubview:serverFreeLb];
                [serverFreeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lineTopLb.mas_bottom).offset(10);
                    make.left.equalTo(serviceV).offset(15);
                    make.right.equalTo(serviceV).offset(-15);
                    make.height.mas_equalTo(20);
                }];
                self.serverFreeLb = serverFreeLb;

                [self.serverUnitLb removeFromSuperview];
                UILabel *unitLb = [[UILabel alloc] init];
                unitLb.text = @"￥";
                unitLb.textColor = RGBHex(0x333333);
                unitLb.textAlignment = NSTextAlignmentLeft;
                unitLb.font = JKFont(18);
                [serviceV addSubview:unitLb];
                [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(serverFreeLb.mas_bottom).offset(20);
                    make.left.equalTo(serviceV).offset(15);
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                self.serverUnitLb = unitLb;

                [self.serverFreeTF removeFromSuperview];
                UITextField *serverFreeTF = [[UITextField alloc] init];
                if (self.serverFreeStr != nil) {
                    serverFreeTF.text= self.serverFreeStr;
                }
                serverFreeTF.textAlignment = NSTextAlignmentLeft;
                serverFreeTF.textColor = RGBHex(0x333333);
                serverFreeTF.keyboardType = UIKeyboardTypeDecimalPad;
                serverFreeTF.font = JKFont(20);
                serverFreeTF.tag = 0;
                serverFreeTF.delegate = self;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldDidChangeValue:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:serverFreeTF];
                [serviceV addSubview:serverFreeTF];
                [serverFreeTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(unitLb.mas_bottom).offset(2);
                    make.left.equalTo(unitLb.mas_right).offset(5);
                    make.right.equalTo(serviceV.mas_right).offset(-15);
                    make.height.mas_equalTo(25);
                }];
                self.serverFreeTF = serverFreeTF;

                [self.lineOneLb removeFromSuperview];
                UILabel *lineOneLb = [[UILabel alloc] init];
                lineOneLb.backgroundColor = RGBHex(0xdddddd);
                [serviceV addSubview:lineOneLb];
                [lineOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(unitLb.mas_bottom).offset(5);
                    make.left.equalTo(serviceV.mas_left).offset(15);
                    make.right.equalTo(serviceV.mas_right).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];
                self.lineOneLb = lineOneLb;

                [self.serverRemarkTF removeFromSuperview];
                UITextField *serverRemarkTF = [[UITextField alloc] init];
                if (self.serverRemarkStr != nil) {
                    serverRemarkTF.text= self.serverRemarkStr;
                }
                serverRemarkTF.placeholder = @"添加备注";
                serverRemarkTF.textColor = RGBHex(0x333333);
                serverRemarkTF.textAlignment = NSTextAlignmentLeft;
                serverRemarkTF.font = JKFont(14);
                serverRemarkTF.tag = 1;
                serverRemarkTF.delegate = self;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldDidChangeValue:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:serverRemarkTF];
                [serviceV addSubview:serverRemarkTF];
                [serverRemarkTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lineOneLb.mas_bottom).offset(5);
                    make.left.equalTo(serviceV.mas_left).offset(15);
                    make.right.equalTo(serviceV.mas_right).offset(-15);
                    make.height.mas_equalTo(25);
                }];
                self.serverRemarkTF = serverRemarkTF;

                [self.lineTwoLb removeFromSuperview];
                UILabel *lineTwoLb = [[UILabel alloc] init];
                lineTwoLb.backgroundColor = RGBHex(0xdddddd);
                [serviceV addSubview:lineTwoLb];
                [lineTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(serverRemarkTF.mas_bottom).offset(5);
                    make.left.equalTo(serviceV.mas_left).offset(15);
                    make.right.equalTo(serviceV.mas_right).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];
                self.lineTwoLb = lineTwoLb;

                [self.serverFreeReceiptLb removeFromSuperview];
                UILabel *serverFreeReceiptLb = [[UILabel alloc] init];
                serverFreeReceiptLb.text = @"上传服务费用收据";
                serverFreeReceiptLb.textColor = RGBHex(0x333333);
                serverFreeReceiptLb.textAlignment = NSTextAlignmentLeft;
                serverFreeReceiptLb.font = JKFont(14);
                [serviceV addSubview:serverFreeReceiptLb];
                [serverFreeReceiptLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lineTwoLb.mas_top).offset(10);
                    make.left.equalTo(serviceV).offset(15);
                    make.right.equalTo(serviceV).offset(-15);
                    make.height.mas_equalTo(20);
                }];
                self.serverFreeReceiptLb = serverFreeReceiptLb;

                [self createScrollImageUI:serverFreeReceiptLb withCell:cell withImageType:JKImageTypeInstallService withImageArr:self.imageServiceURL];
            } else {
                [self.serviceV removeFromSuperview];
                [self.serverFreePaymentLb removeFromSuperview];
                [self.lineTopLb removeFromSuperview];
                [self.serverRemitBtn removeFromSuperview];
                [self.serverCashBtn removeFromSuperview];
                [self.serverFreeLb removeFromSuperview];
                [self.serverUnitLb removeFromSuperview];
                [self.serverFreeTF removeFromSuperview];
                [self.lineOneLb removeFromSuperview];
                [self.serverRemarkTF removeFromSuperview];
                [self.lineTwoLb removeFromSuperview];
                [self.serverFreeReceiptLb removeFromSuperview];
                [self.serviceScrollView removeFromSuperview];
            }

        } else {
            [self.depositSwitch removeFromSuperview];
            UISwitch *depositSwitch = [[UISwitch alloc] init];
            depositSwitch.transform = CGAffineTransformMakeScale( 0.7, 0.7);
            if (!self.isDepositFree) {
                [depositSwitch setOn:NO];
            } else {
                [depositSwitch setOn:YES];
            }
            [depositSwitch addTarget:self action:@selector(depositSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:depositSwitch];
            [depositSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(9);
                make.right.equalTo(cell).mas_offset(-15);
            }];
            self.depositSwitch = depositSwitch;
            
            [self.depositLb removeFromSuperview];
            UILabel *depositLb = [[UILabel alloc] init];
            depositLb.text = @"是否收取押金费";
            depositLb.textColor = RGBHex(0x333333);
            depositLb.textAlignment = NSTextAlignmentLeft;
            depositLb.font = JKFont(14);
            [cell addSubview:depositLb];
            [depositLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(depositSwitch.mas_centerY);
                make.left.equalTo(cell).offset(15);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(20);
            }];
            self.depositLb = depositLb;
            
            if (self.isDepositFree) {
                [self.depositV removeFromSuperview];
                UIView *depositV = [[UIView alloc] init];
                [cell addSubview:depositV];
                [depositV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).offset(48);
                    make.left.right.equalTo(cell);
                    make.bottom.equalTo(cell);
                }];
                [self.depositV addSubview:depositV];
                
                UILabel *lineLb = [[UILabel alloc] init];
                lineLb.backgroundColor = RGBHex(0xdddddd);
                [cell addSubview:lineLb];
                [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(depositV.mas_top).offset(-0.5);
                    make.left.equalTo(cell).offset(15);
                    make.right.equalTo(cell).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];
                
                [self.depositFreePaymentLb removeFromSuperview];
                UILabel *depositFreePaymentLb = [[UILabel alloc] init];
                depositFreePaymentLb.text = @"收款方式";
                depositFreePaymentLb.textColor = RGBHex(0x333333);
                depositFreePaymentLb.textAlignment = NSTextAlignmentLeft;
                depositFreePaymentLb.font = JKFont(14);
                [depositV addSubview:depositFreePaymentLb];
                [depositFreePaymentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(depositV.mas_top).offset(12);
                    make.left.equalTo(depositV).offset(15);
                    make.right.equalTo(depositV).offset(-15);
                    make.height.mas_equalTo(20);
                }];
                self.depositFreePaymentLb = depositFreePaymentLb;
                
                [self.depositRemitBtn removeFromSuperview];
                UIButton *depositRemitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [depositRemitBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
                [depositRemitBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
                [depositRemitBtn setTitle:@"  银行汇款" forState:UIControlStateNormal];
                [depositRemitBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
                [depositRemitBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
                depositRemitBtn.titleLabel.font = JKFont(14);
                depositRemitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                depositRemitBtn.tag = 1;
                if (self.isChooseDepositRemit) {
                    depositRemitBtn.selected = YES;
                } else {
                    depositRemitBtn.selected = NO;
                }
                [depositRemitBtn addTarget:self action:@selector(depositPaymentMethodSelected:) forControlEvents:UIControlEventTouchUpInside];
                [depositV addSubview:depositRemitBtn];
                [depositRemitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(depositFreePaymentLb.mas_centerY);
                    make.right.equalTo(depositV.mas_right).offset(-15);
                    make.size.mas_equalTo(CGSizeMake(100, 30));
                }];
                self.depositRemitBtn = depositRemitBtn;
                
                [self.depositCashBtn removeFromSuperview];
                UIButton *depositCashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [depositCashBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
                [depositCashBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
                [depositCashBtn setTitle:@"  现金" forState:UIControlStateNormal];
                [depositCashBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
                [depositCashBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
                depositCashBtn.titleLabel.font = JKFont(14);
                depositCashBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                depositCashBtn.tag = 0;
                if (self.isChooseDepositRemit) {
                    depositCashBtn.selected = NO;
                } else {
                    depositCashBtn.selected = YES;
                }
                [depositCashBtn addTarget:self action:@selector(depositPaymentMethodSelected:) forControlEvents:UIControlEventTouchUpInside];
                [depositV addSubview:depositCashBtn];
                [depositCashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(depositFreePaymentLb.mas_centerY);
                    make.right.equalTo(depositRemitBtn.mas_left).offset(-5);
                    make.size.mas_equalTo(CGSizeMake(60, 30));
                }];
                self.depositCashBtn = depositCashBtn;
                
                [self.lineFiveLb removeFromSuperview];
                UILabel *lineFiveLb = [[UILabel alloc] init];
                lineFiveLb.backgroundColor = RGBHex(0xdddddd);
                [depositV addSubview:lineFiveLb];
                [lineFiveLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(depositFreePaymentLb.mas_bottom).offset(12);
                    make.left.equalTo(cell).offset(15);
                    make.right.equalTo(cell).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];
                self.lineFiveLb = lineFiveLb;
                
                [self.depositFreeLb removeFromSuperview];
                UILabel *depositFreeLb = [[UILabel alloc] init];
                depositFreeLb.text = @"实收金额";
                depositFreeLb.textColor = RGBHex(0x333333);
                depositFreeLb.textAlignment = NSTextAlignmentLeft;
                depositFreeLb.font = JKFont(14);
                [depositV addSubview:depositFreeLb];
                [depositFreeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lineFiveLb.mas_bottom).offset(10);
                    make.left.equalTo(depositV).offset(15);
                    make.right.equalTo(depositV).offset(-15);
                    make.height.mas_equalTo(20);
                }];
                self.depositFreeLb = depositFreeLb;
                
                [self.depositUnitLb removeFromSuperview];
                UILabel *unitLb = [[UILabel alloc] init];
                unitLb.text = @"￥";
                unitLb.textColor = RGBHex(0x333333);
                unitLb.textAlignment = NSTextAlignmentLeft;
                unitLb.font = JKFont(18);
                [depositV addSubview:unitLb];
                [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(depositFreeLb.mas_bottom).offset(20);
                    make.left.equalTo(depositV).offset(15);
                    make.size.mas_equalTo(CGSizeMake(20, 20));
                }];
                self.depositUnitLb = unitLb;
                
                [self.depositFreeTF removeFromSuperview];
                UITextField *depositFreeTF = [[UITextField alloc] init];
                if (self.depositFreeStr != nil) {
                    depositFreeTF.text= self.depositFreeStr;
                }
                depositFreeTF.textAlignment = NSTextAlignmentLeft;
                depositFreeTF.textColor = RGBHex(0x333333);
                depositFreeTF.font = JKFont(20);
                depositFreeTF.tag = 2;
                depositFreeTF.delegate = self;
                depositFreeTF.keyboardType = UIKeyboardTypeDecimalPad;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldDidChangeValue:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:depositFreeTF];
                [depositV addSubview:depositFreeTF];
                [depositFreeTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(unitLb.mas_bottom).offset(2);
                    make.left.equalTo(unitLb.mas_right).offset(5);
                    make.right.equalTo(depositV.mas_right).offset(-15);
                    make.height.mas_equalTo(25);
                }];
                self.depositFreeTF = depositFreeTF;
                
                [self.lineThreeLb removeFromSuperview];
                UILabel *lineOneLb = [[UILabel alloc] init];
                lineOneLb.backgroundColor = RGBHex(0xdddddd);
                [depositV addSubview:lineOneLb];
                [lineOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(unitLb.mas_bottom).offset(5);
                    make.left.equalTo(depositV.mas_left).offset(15);
                    make.right.equalTo(depositV.mas_right).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];
                self.lineThreeLb = lineOneLb;
                
                [self.depositRemarkTF removeFromSuperview];
                UITextField *depositRemarkTF = [[UITextField alloc] init];
                if (self.depositRemarkStr != nil) {
                    depositRemarkTF.text= self.depositRemarkStr;
                }
                depositRemarkTF.placeholder = @"添加备注";
                depositRemarkTF.textColor = RGBHex(0x333333);
                depositRemarkTF.textAlignment = NSTextAlignmentLeft;
                depositRemarkTF.font = JKFont(14);
                depositRemarkTF.tag = 3;
                depositRemarkTF.delegate = self;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldDidChangeValue:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:depositRemarkTF];
                [depositV addSubview:depositRemarkTF];
                [depositRemarkTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lineOneLb.mas_bottom).offset(5);
                    make.left.equalTo(depositV.mas_left).offset(15);
                    make.right.equalTo(depositV.mas_right).offset(-15);
                    make.height.mas_equalTo(25);
                }];
                self.depositRemarkTF = depositRemarkTF;
                
                [self.lineFourLb removeFromSuperview];
                UILabel *lineTwoLb = [[UILabel alloc] init];
                lineTwoLb.backgroundColor = RGBHex(0xdddddd);
                [depositV addSubview:lineTwoLb];
                [lineTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(depositRemarkTF.mas_bottom).offset(5);
                    make.left.equalTo(depositV.mas_left).offset(15);
                    make.right.equalTo(depositV.mas_right).offset(-15);
                    make.height.mas_equalTo(0.5);
                }];
                self.lineFourLb = lineTwoLb;
                
                [self.depositFreeReceiptLb removeFromSuperview];
                UILabel *depositFreeReceiptLb = [[UILabel alloc] init];
                depositFreeReceiptLb.text = @"上传押金费用收据";
                depositFreeReceiptLb.textColor = RGBHex(0x333333);
                depositFreeReceiptLb.textAlignment = NSTextAlignmentLeft;
                depositFreeReceiptLb.font = JKFont(14);
                [depositV addSubview:depositFreeReceiptLb];
                [depositFreeReceiptLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lineTwoLb.mas_top).offset(10);
                    make.left.equalTo(depositV).offset(15);
                    make.right.equalTo(depositV).offset(-15);
                    make.height.mas_equalTo(20);
                }];
                self.depositFreeReceiptLb = depositFreeReceiptLb;
                
                [self createScrollImageUI:depositFreeReceiptLb withCell:cell withImageType:JKImageTypeInstallDeposit withImageArr:self.imageDepositURL];

            } else {
                [self.depositV removeFromSuperview];
                [self.depositFreePaymentLb removeFromSuperview];
                [self.lineFiveLb removeFromSuperview];
                [self.depositRemitBtn removeFromSuperview];
                [self.depositCashBtn removeFromSuperview];
                [self.depositFreeLb removeFromSuperview];
                [self.depositUnitLb removeFromSuperview];
                [self.depositFreeTF removeFromSuperview];
                [self.lineThreeLb removeFromSuperview];
                [self.depositRemarkTF removeFromSuperview];
                [self.lineFourLb removeFromSuperview];
                [self.depositFreeReceiptLb removeFromSuperview];
                [self.depositScrollView removeFromSuperview];
            }
        }
    }
    
    return cell;
}

- (void)createScrollImageUI:(UILabel *)titleLb withCell:(UITableViewCell *)cell withImageType:(JKImageType)imageType withImageArr:(NSMutableArray *)imgArr {
    if (imageType == JKImageTypeInstallOrder) {
        [self.orderScrollView removeFromSuperview];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(5);
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
                    [btn addTarget:self action:@selector(showOrderImgClick:) forControlEvents:UIControlEventTouchUpInside];
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
                    [btn addTarget:self action:@selector(showOrderImgClick:) forControlEvents:UIControlEventTouchUpInside];
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
        
    } else if (imageType == JKImageTypeInstallService) {
        [self.serviceScrollView removeFromSuperview];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(10);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.serviceScrollView = scrollView;
        
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
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(showServiceImgClick:) forControlEvents:UIControlEventTouchUpInside];
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
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(showServiceImgClick:) forControlEvents:UIControlEventTouchUpInside];
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
    } else if (imageType == JKImageTypeInstallDeposit) {
        [self.depositScrollView removeFromSuperview];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = kWhiteColor;
        [cell addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(10);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.height.mas_equalTo(80);
        }];
        
        scrollView.contentSize = CGSizeMake(90 *(imgArr.count +1), 80);
        self.depositScrollView = scrollView;
        
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
                    btn.tag = i;
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    [btn addTarget:self action:@selector(showDepositImgClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 20;
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                }
            } else {
                for (NSInteger i = 0; i < imgArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(90 * i , 0, 80, 80);
                    btn.tag = i;
                    [btn addTarget:self action:@selector(showDepositImgClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setImage:[UIImage imageWithContentsOfFile:imgArr[i]] forState:UIControlStateNormal];
                    [scrollView addSubview:btn];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                    deleteBtn.tag = i + 20;
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
    if (btn.tag == JKImageTypeInstallOrder) {
        [self.orderHelper showImagePickerControllerWithMaxCount:(9 - self.imageOrderArr.count) WithViewController:[self View:self]];
    } else if (btn.tag == JKImageTypeInstallService) {
        [self.serviceHelper showImagePickerControllerWithMaxCount:(9 - self.imageServiceArr.count) WithViewController:[self View:self]];
    } else if (btn.tag == JKImageTypeInstallDeposit) {
        [self.depositHelper showImagePickerControllerWithMaxCount:(9 - self.imageDepositArr.count) WithViewController:[self View:self]];
    }
}

- (void)showDepositImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageDepositURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)showServiceImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageServiceURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)showOrderImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageOrderURL withTag:btn.tag];
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
        [self.imageOrderURL removeObjectAtIndex:btn.tag];
        [self.imageOrderArr removeObjectAtIndex:btn.tag];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if (btn.tag <= 19) {
        [self.imageServiceURL removeObjectAtIndex:(btn.tag - 10)];
        [self.imageServiceArr removeObjectAtIndex:(btn.tag - 10)];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    } else if (btn.tag <= 29) {
        [self.imageDepositURL removeObjectAtIndex:(btn.tag - 20)];
        [self.imageDepositArr removeObjectAtIndex:(btn.tag - 20)];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
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

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        return NO;
//    }
//    
//    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
//    if (![text isEqualToString:tem]) {
//        return NO;
//    }
//    
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

@end
