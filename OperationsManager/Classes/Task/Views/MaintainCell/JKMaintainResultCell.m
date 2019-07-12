//
//  JKMaintainResultCell.m
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMaintainResultCell.h"
#import "TZImagePickerHelper.h"
#import "JKMaintainInfoModel.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKMaintainResultCell () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *btnTitleArr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *punchBtn;
@property (nonatomic, strong) NSMutableArray *contentBtnTitleArr;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) NSMutableArray *imageURL;
@property (nonatomic, strong) TZImagePickerHelper *helper;

@property (nonatomic, strong) NSString *tarMonRemarks;
@property (nonatomic, strong) NSString *tarMaintainCon;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *txtEndDate;
@property (nonatomic, strong) UILabel *annexLb;

@end

@implementation JKMaintainResultCell

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = kWhiteColor;
    }
    return _scrollView;
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

- (NSMutableArray *)imageURL {
    if (!_imageURL) {
        _imageURL = [NSMutableArray array];
    }
    return _imageURL;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)contentBtnTitleArr {
    if (!_contentBtnTitleArr) {
        _contentBtnTitleArr = [[NSMutableArray alloc] init];
    }
    return _contentBtnTitleArr;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc] init];
    }
    return _selectArr;
}

- (TZImagePickerHelper *)helper {
    if (!_helper) {
        _helper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _helper.imageType = JKImageTypeMaintain;
        _helper.finishMaintain = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _helper;
}

- (void)dealloc {
    self.locationManager = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        
    }
    return self;
}

- (void)createUI:(JKMaintainInfoModel *)model {
    
    self.tarMonRemarks = model.tarRemarks;
    self.tarMaintainCon = model.tarMaintainCon;
    self.picture = model.txtMaintainImgSrc;
    self.txtEndDate = model.txtEndDate;
    
    if (self.maintainType == JKMaintainIng) {
        [self getMaintainResultList];
    }
    if (self.maintainType == JKMaintainIng) {
        self.titleArr = @[@"处理结果", @"下次维护时间", @"", @"", @""];
    } else {
        self.titleArr = @[@"处理结果", @"下次维护时间", @"", @"完成时间", @"", @""];
    }

    self.btnTitleArr = @[@"  清洗", @"  检查线路", @"  更换电解液", @"  更换膜头", @"  检查零配件", @"  更换零部件"];
    
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

#pragma mark -- 获取维修内容多选项
- (void)getMaintainResultList {
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/app/formData/repairList/maintain",kUrl_Base];
    
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            for (NSString *reason in responseObject[@"data"]) {
                [self.contentBtnTitleArr addObject:[NSString stringWithFormat:@"  %@",reason]];
            }
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 打卡
- (void)punchBtnClick:(UIButton *)btn {
    [self.punchBtn setTitle:@"已打卡" forState:UIControlStateNormal];
    [self.punchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.punchBtn.backgroundColor = kWhiteColor;
    self.punchBtn.titleLabel.font = JKFont(15);
    self.punchBtn.layer.cornerRadius = 4;
    self.punchBtn.layer.masksToBounds = YES;
//    self.punchBtn.layer.borderColor = RGBHex(0xdddddd).CGColor;
//    self.punchBtn.layer.borderWidth = 1;
    if ([_delegate respondsToSelector:@selector(getLocationLatAndLngAndTime)]) {
        [_delegate getLocationLatAndLngAndTime];
    }
}

#pragma mark -- 多选
- (void)moreSelected:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSString *tagStr = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
    
    if (btn.selected) {
        [self.selectArr addObject:tagStr];
    } else {
        [self.selectArr removeObject:tagStr];
    }
    
    NSLog(@"%@",self.selectArr);
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.maintainType == JKMaintainIng) {
        if (indexPath.row == 2) {
            if (self.contentBtnTitleArr.count == 0) {
                return 48;
            }
            return (self.contentBtnTitleArr.count / 2  + self.contentBtnTitleArr.count % 2) * 30 + 20;
        } else if (indexPath.row == 3) {
            return 100;
        } else if (indexPath.row == 4) {
            return 148;
        } else {
            return 48;
        }
    } else {
        if (indexPath.row == 5) {
            return 148;
        } else {
            return 48;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.maintainType == JKMaintainIng) {
        NSString *ID = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
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
        
        if (indexPath.row == 0) {
            cell.textLabel.font = JKFont(16);
            
            if (self.maintainType == JKMaintainIng) {
                UIButton *punchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [punchBtn setTitle:@"打卡" forState:UIControlStateNormal];
                [punchBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                [punchBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
                [punchBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
                [punchBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
                punchBtn.titleLabel.font = JKFont(15);
                punchBtn.layer.cornerRadius = 4;
                punchBtn.layer.masksToBounds = YES;
                [punchBtn addTarget:self action:@selector(punchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:punchBtn];
                [punchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                    make.size.mas_equalTo(CGSizeMake(60, 30));
                }];
                self.punchBtn = punchBtn;
            }
            
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"";
        } else if (indexPath.row == 2) {
            UILabel *contentLb = [[UILabel alloc] init];
            contentLb.text = @"维护内容";
            contentLb.textColor = RGBHex(0x333333);
            contentLb.textAlignment = NSTextAlignmentLeft;
            contentLb.font = JKFont(14);
            [cell addSubview:contentLb];
            [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.left.equalTo(cell).offset(15);
                make.width.mas_offset(80);
                make.height.mas_equalTo(48);
            }];
            
            UIView *bgView = [[UIView alloc] init];
            [cell addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(contentLb.mas_right).offset(10);
                make.bottom.equalTo(cell);
            }];
            
            CGFloat width = (SCREEN_WIDTH - SCALE_SIZE(30) - 90) / 2;
            
            for (NSInteger i = 0; i < self.contentBtnTitleArr.count; i++) {
                NSInteger col = i / 2;
                NSInteger row = i % 2;
                
                UIButton *resultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_off"] forState:UIControlStateNormal];
                if (self.maintainType == JKMaintainIng) {
                    [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_on"] forState:UIControlStateSelected];
                    [resultBtn addTarget:self action:@selector(moreSelected:) forControlEvents:UIControlEventTouchUpInside];
                    resultBtn.selected = NO;
                } else if (self.maintainType == JKMaintainEd) {
                    [resultBtn setImage:[UIImage imageNamed:@"ic_device_more_select_unable"] forState:UIControlStateSelected];
                    resultBtn.selected = YES;
                }
                [resultBtn setTitle:self.contentBtnTitleArr[i] forState:UIControlStateNormal];
                [resultBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
                resultBtn.titleLabel.font = JKFont(14);
                resultBtn.tag = i;
                resultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
                [bgView addSubview:resultBtn];
                [resultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView.mas_top).offset(30 * col);
                    make.left.equalTo(bgView.mas_left).offset((width + 10) * row);
                    make.size.mas_equalTo(CGSizeMake(width, 30));
                }];
            }
        } else if (indexPath.row == 3) {
            UILabel *remarkLb = [[UILabel alloc] init];
            remarkLb.text = @"备注";
            remarkLb.textColor = RGBHex(0x333333);
            remarkLb.textAlignment = NSTextAlignmentLeft;
            remarkLb.font = JKFont(14);
            [cell addSubview:remarkLb];
            [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.left.equalTo(cell).offset(15);
                make.width.mas_offset(80);
                make.height.mas_equalTo(48);
            }];
            
            UITextView *textV = [[UITextView alloc] init];
            textV.font = JKFont(13);
            textV.textColor = RGBHex(0x666666);
            textV.layer.borderColor = RGBHex(0xdddddd).CGColor;
            textV.layer.borderWidth = 1;
            [textV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
            textV.delegate = self;
            [cell addSubview:textV];
            [textV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(remarkLb.mas_right).offset(10);
                make.bottom.equalTo(cell).offset(-10);
            }];
            self.textV = textV;
            
        } else if (indexPath.row == 4) {
            
            [self.annexLb removeFromSuperview];
            UILabel *annexLb = [[UILabel alloc] init];
            annexLb.text = @"附件图片";
            annexLb.textColor = RGBHex(0x333333);
            annexLb.textAlignment = NSTextAlignmentLeft;
            annexLb.font = JKFont(14);
            [cell addSubview:annexLb];
            [annexLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top);
                make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(48);
            }];
            self.annexLb = annexLb;
            
            [self.scrollView removeFromSuperview];
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.backgroundColor = kWhiteColor;
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(annexLb.mas_bottom).offset(5);
                make.left.equalTo(cell.mas_left).offset(15);
                make.right.equalTo(cell.mas_right).offset(-15);
                make.height.mas_equalTo(80);
            }];
            
            scrollView.contentSize = CGSizeMake(90 *(self.imageURL.count +1), 80);
            self.scrollView = scrollView;
            
            if (self.imageURL.count == 0) {
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(0, 0, 80, 80);
                addBtn.tag = JKImageTypeMaintain;
                [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:addBtn];
            } else {
                if (self.imageURL.count == 9) {
                    for (NSInteger i = 0; i < self.imageURL.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(90 * i , 0, 80, 80);
                        btn.tag = i;
                        [btn addTarget:self action:@selector(showImgClick:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setImage:[UIImage imageWithContentsOfFile:self.imageURL[i]] forState:UIControlStateNormal];
                        [scrollView addSubview:btn];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                        deleteBtn.tag = i;
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                    }
                } else {
                    for (NSInteger i = 0; i < self.imageURL.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(90 * i , 0, 80, 80);
                        btn.tag = i;
                        [btn addTarget:self action:@selector(showImgClick:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setImage:[UIImage imageWithContentsOfFile:self.imageURL[i]] forState:UIControlStateNormal];
                        [scrollView addSubview:btn];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                        deleteBtn.tag = i;
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        
                        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                        addBtn.tag = JKImageTypeMaintain;
                        [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                        [addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:addBtn];
                    }
                }
            }
        }
        
        return cell;
    } else {
        NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
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
        
        if (indexPath.row == 0) {
            cell.textLabel.font = JKFont(16);
            
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = @"";
        } else if (indexPath.row == 2) {
            UILabel *contentLb = [[UILabel alloc] init];
            contentLb.text = @"维护内容";
            contentLb.textColor = RGBHex(0x333333);
            contentLb.textAlignment = NSTextAlignmentLeft;
            contentLb.font = JKFont(14);
            [cell addSubview:contentLb];
            [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.left.equalTo(cell).offset(15);
                make.width.mas_offset(80);
                make.height.mas_equalTo(48);
            }];
            
            UILabel *remarkValueLb = [[UILabel alloc] init];
            remarkValueLb.text = self.tarMaintainCon;
            remarkValueLb.textColor = RGBHex(0x999999);
            remarkValueLb.textAlignment = NSTextAlignmentRight;
            remarkValueLb.numberOfLines = 0;
//            remarkValueLb.adjustsFontSizeToFitWidth = YES;
            remarkValueLb.font = JKFont(14);
            [cell addSubview:remarkValueLb];
            [remarkValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.right.equalTo(cell).offset(-SCALE_SIZE(15));
                make.left.equalTo(contentLb.mas_right).offset(5);
                make.bottom.equalTo(cell);
            }];
            
        } else if (indexPath.row == 3) {
            cell.detailTextLabel.text = self.txtEndDate;
            cell.detailTextLabel.textColor = RGBHex(0x999999);
            cell.detailTextLabel.font = JKFont(14);
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"备注";
            
            UILabel *remarkValueLb = [[UILabel alloc] init];
            remarkValueLb.text = self.tarMonRemarks;
            remarkValueLb.textColor = RGBHex(0x999999);
            remarkValueLb.textAlignment = NSTextAlignmentRight;
            remarkValueLb.numberOfLines = 0;
//            remarkValueLb.adjustsFontSizeToFitWidth = YES;
            remarkValueLb.font = JKFont(14);
            [cell addSubview:remarkValueLb];
            [remarkValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.right.equalTo(cell).offset(-SCALE_SIZE(15));
                make.left.equalTo(cell.mas_centerX);
                make.bottom.equalTo(cell);
            }];
            
        } else if (indexPath.row == 5) {
            
            [self.annexLb removeFromSuperview];
            UILabel *annexLb = [[UILabel alloc] init];
            annexLb.text = @"附件图片";
            annexLb.textColor = RGBHex(0x333333);
            annexLb.textAlignment = NSTextAlignmentLeft;
            annexLb.font = JKFont(14);
            [cell addSubview:annexLb];
            [annexLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top);
                make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(48);
            }];
            self.annexLb = annexLb;
            
            self.picture = [self.picture stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *imgArr = [self.picture componentsSeparatedByString:@","];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.backgroundColor = kWhiteColor;
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(annexLb.mas_bottom);
                make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(80);
            }];
            
            scrollView.contentSize = CGSizeMake(90 * imgArr.count, 80);
            
            for (NSInteger i = 0; i < imgArr.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(90 * i , 0, 80, 80);
                imgV.userInteractionEnabled = YES;
                //            imgV.backgroundColor = kRedColor;
                imgV.yy_imageURL = [NSURL URLWithString:imgArr[i]];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [scrollView addSubview:imgV];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                btn.tag = i;
                [btn addTarget:self action:@selector(imgArrClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }
        
        return cell;
    }
}

- (void)btnClick:(UIButton *)btn {
    [self.helper showImagePickerControllerWithMaxCount:(9 - self.imageArr.count) WithViewController:[self View:self]];
}

- (void)imgArrClick:(UIButton *)btn {
    self.picture = [self.picture stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *imgArr = [self.picture componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:imgArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)showImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)deleteBtnClick:(UIButton *)btn {
    [self.imageURL removeObjectAtIndex:btn.tag];
    [self.imageArr removeObjectAtIndex:btn.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
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
