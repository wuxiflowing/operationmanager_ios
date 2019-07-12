//
//  JKFeedbackVC.m
//  OperationsManager
//
//  Created by    on 2018/10/31.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKFeedbackVC.h"
#import "TZImagePickerHelper.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKFeedbackVC () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    NSInteger _forCount;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *otherBtn;
@property (nonatomic, strong) UIButton *complaintBtn;
@property (nonatomic, strong) UIButton *opinionBtn;
@property (nonatomic, strong) UIButton *suggestBtn;
@property (nonatomic, strong) NSString *feedBackTypeStr;
@property (nonatomic, strong) UITextView *titleV;
@property (nonatomic, strong) UITextView *contentV;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TZImagePickerHelper *helper;
@property (nonatomic, strong) NSMutableArray *imageURL;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation JKFeedbackVC

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
        _tableView.separatorColor = kClearColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (TZImagePickerHelper *)helper {
    if (!_helper) {
        _helper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _helper.imageType = JKImageTypeAttachFile;
        _helper.finishAttachFile = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _helper;
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

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"意见反馈";
    
    self.feedBackTypeStr = @"建议";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)submitBtnClick:(UIButton *)btn {
    if ([self.titleV.text trimmingCharacters].length == 0) {
        [YJProgressHUD showMessage:@"请输入标题" inView:self.view];
        return;
    }
    
    if ([self.contentV.text trimmingCharacters].length == 0) {
        [YJProgressHUD showMessage:@"请输入内容" inView:self.view];
        return;
    }
    
    [YJProgressHUD showProgressCircleNoValue:@"提交中..." inView:self.view];
    if (self.imageArr.count == 0) {
        [self submitInfo];
    } else {
        [self getImgUrl];
    }
}

- (void)getImgUrl {
    [self.imgArr removeAllObjects];
    [self saveImage:self.imageArr];
}

- (void)saveImage:(NSArray *)imgArr {
    _forCount = 0;
    [self getImgArr:imgArr withIndex:_forCount];
}

- (void)getImgArr:(NSArray *)imgArr withIndex:(NSInteger)tag {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"csm" forKey:@"type"];
    [params setObject:[NSString stringWithFormat:@"%ld.jpg",[JKToolKit getNowTimestamp]] forKey:@"imageName"];
    [params setObject:[JKToolKit imageToString:imgArr[tag]] forKey:@"imageData"];
    NSString *loginId = [JKUserDefaults objectForKey:@"loginid"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/RESTAdapter/%@/uploadImage", kUrl_Base, loginId];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [self.imgArr addObject:responseObject[@"data"]];
        _forCount++;
        if (_forCount == self.imageArr.count) {
            [self submitInfo];
        } else {
            [self getImgArr:imgArr withIndex:_forCount];
        }
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)submitInfo {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.feedBackTypeStr forKey:@"type"];
    [params setObject:self.titleV.text forKey:@"title"];
    [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginId"];
    [params setObject:self.contentV.text forKey:@"context"];
    if (self.imgArr.count == 0) {
        [params setObject:@"" forKey:@"attachfile"];
    } else {
        [params setObject:self.imgArr forKey:@"attachfile"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", kUrl_AppCSM];
    
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            [YJProgressHUD showMessage:responseObject[@"message"] inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

- (void)singleTypeSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 1) {
            self.otherBtn.selected = NO;
            self.complaintBtn.selected = NO;
            self.opinionBtn.selected = NO;
            self.feedBackTypeStr = @"建议";
        } else if (btn.tag == 2) {
            self.otherBtn.selected = NO;
            self.complaintBtn.selected = NO;
            self.suggestBtn.selected = NO;
            self.feedBackTypeStr = @"意见";
        } else if (btn.tag == 3) {
            self.otherBtn.selected = NO;
            self.suggestBtn.selected = NO;
            self.opinionBtn.selected = NO;
            self.feedBackTypeStr = @"投诉";
        } else {
            self.suggestBtn.selected = NO;
            self.complaintBtn.selected = NO;
            self.opinionBtn.selected = NO;
            self.feedBackTypeStr = @"其他";
        }
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 48;
    } else if (indexPath.row == 1) {
        return 50;
    } else if (indexPath.row == 2) {
        return 100;
    } else if (indexPath.row == 3) {
        return 150;
    } else {
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"反馈类型";
        cell.textLabel.textColor = RGBHex(0x333333);
        cell.textLabel.font = JKFont(14);
        
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [otherBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [otherBtn setTitle:@"  其他" forState:UIControlStateNormal];
        [otherBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [otherBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        otherBtn.titleLabel.font = JKFont(14);
        otherBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        otherBtn.tag = 4;
        otherBtn.selected = NO;
        [otherBtn addTarget:self action:@selector(singleTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:otherBtn];
        [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        self.otherBtn = otherBtn;
        
        UIButton *complaintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [complaintBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [complaintBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [complaintBtn setTitle:@"  投诉" forState:UIControlStateNormal];
        [complaintBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [complaintBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        complaintBtn.titleLabel.font = JKFont(14);
        complaintBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        complaintBtn.tag = 3;
        complaintBtn.selected = NO;
        [complaintBtn addTarget:self action:@selector(singleTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:complaintBtn];
        [complaintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(otherBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        self.complaintBtn = complaintBtn;
        
        UIButton *opinionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [opinionBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [opinionBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [opinionBtn setTitle:@"  意见" forState:UIControlStateNormal];
        [opinionBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [opinionBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        opinionBtn.titleLabel.font = JKFont(14);
        opinionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        opinionBtn.tag = 2;
        opinionBtn.selected = NO;
        [opinionBtn addTarget:self action:@selector(singleTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:opinionBtn];
        [opinionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(complaintBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        self.opinionBtn = opinionBtn;
        
        UIButton *suggestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [suggestBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
        [suggestBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
        [suggestBtn setTitle:@"  建议" forState:UIControlStateNormal];
        [suggestBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
        [suggestBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
        suggestBtn.titleLabel.font = JKFont(14);
        suggestBtn.tag = 1;
        suggestBtn.selected = YES;
        [suggestBtn addTarget:self action:@selector(singleTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:suggestBtn];
        [suggestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(opinionBtn.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        self.suggestBtn = suggestBtn;
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *remarkLb = [[UILabel alloc] init];
        remarkLb.text = @"标题";
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
        
        UITextView *textV = [[UITextView alloc] init];
        textV.font = JKFont(14);
        [textV setPlaceholder:@"标题" placeholdColor: RGBHex(0xdddddd)];
        textV.textColor = RGBHex(0x666666);
        textV.layer.borderColor = RGBHex(0xdddddd).CGColor;
        textV.layer.borderWidth = 1;
        textV.delegate = self;
        [cell addSubview:textV];
        [textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(remarkLb.mas_right);
            make.bottom.equalTo(cell).offset(-10);
        }];
        self.titleV = textV;
        
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *ID = @"cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *remarkLb = [[UILabel alloc] init];
        remarkLb.text = @"内容";
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
        
        UITextView *textV = [[UITextView alloc] init];
        textV.font = JKFont(14);
        textV.textColor = RGBHex(0x666666);
        textV.layer.borderColor = RGBHex(0xdddddd).CGColor;
        textV.layer.borderWidth = 1;
        [textV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
        [cell addSubview:textV];
        [textV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
            make.left.equalTo(remarkLb.mas_right);
            make.bottom.equalTo(cell).offset(-10);
        }];
        self.contentV = textV;
        
        return cell;
    } else if (indexPath.row == 3) {
        static NSString *ID = @"cell4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *annexLb = [[UILabel alloc] init];
        annexLb.text = @"附件";
        annexLb.textColor = RGBHex(0x333333);
        annexLb.textAlignment = NSTextAlignmentLeft;
        annexLb.font = JKFont(14);
        [cell addSubview:annexLb];
        [annexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(70);
            make.height.mas_equalTo(48);
        }];
        
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
        
        return cell;
    } else {
        static NSString *ID = @"cell5";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = kBgColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kBgColor;
        [cell addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(5);
            make.left.right.bottom.equalTo(cell);
        }];
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
        submitBtn.titleLabel.font = JKFont(15);
        submitBtn.layer.cornerRadius = 4;
        submitBtn.layer.masksToBounds = YES;
        [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
            make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
            make.height.mas_equalTo(44);
        }];
        
        return cell;
    }
}

- (void)btnClick:(UIButton *)btn {
    [self.helper showImagePickerControllerWithMaxCount:(9 - self.imageArr.count) WithViewController:[self View:self.view]];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
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
