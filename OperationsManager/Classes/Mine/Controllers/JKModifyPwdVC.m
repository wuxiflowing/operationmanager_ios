//
//  JKModifyPwdVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKModifyPwdVC.h"

@interface JKModifyPwdVC ()
@property (nonatomic, strong) UITextField *oldPwdTF;
@property (nonatomic, strong) UITextField *nPwdTF;
@property (nonatomic, strong) UITextField *againPwdTF;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation JKModifyPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    [self createUI];
}

#pragma mark -- 忘记密码界面
- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UITextField *oldPwdTF = [[UITextField alloc] init];
    oldPwdTF.placeholder = @"请输入原密码";
    oldPwdTF.textColor = kBlackColor;
    oldPwdTF.textAlignment = NSTextAlignmentLeft;
    oldPwdTF.secureTextEntry = YES;
    oldPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [oldPwdTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:oldPwdTF];
    [oldPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(SCALE_SIZE(20));
        make.left.equalTo(bgView).offset(SCALE_SIZE(34));
        make.right.equalTo(bgView).offset(SCALE_SIZE(-34));
        make.height.mas_equalTo(SCALE_SIZE(20));
    }];
    self.oldPwdTF = oldPwdTF;
    
    UILabel *onLineLb = [[UILabel alloc] init];
    onLineLb.backgroundColor = RGBHex(0xdfdfdf);
    [bgView addSubview:onLineLb];
    [onLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPwdTF.mas_bottom).offset(14);
        make.left.equalTo(oldPwdTF.mas_left);
        make.right.equalTo(oldPwdTF.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UITextField *nPwdTF = [[UITextField alloc] init];
    nPwdTF.placeholder = @"请输入新密码";
    nPwdTF.textColor = kBlackColor;
    nPwdTF.textAlignment = NSTextAlignmentLeft;
    nPwdTF.secureTextEntry = YES;
    nPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nPwdTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:nPwdTF];
    [nPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(onLineLb.mas_bottom).offset(SCALE_SIZE(20));
        make.left.equalTo(onLineLb.mas_left);
        make.right.equalTo(onLineLb.mas_right);
        make.height.mas_equalTo(SCALE_SIZE(20));
    }];
    self.nPwdTF = nPwdTF;
    
    UILabel *naLineLb = [[UILabel alloc] init];
    naLineLb.backgroundColor = RGBHex(0xdfdfdf);
    [bgView addSubview:naLineLb];
    [naLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nPwdTF.mas_bottom).offset(14);
        make.left.equalTo(nPwdTF.mas_left);
        make.right.equalTo(bgView).offset(SCALE_SIZE(-34));
        make.height.mas_equalTo(1);
    }];
    
    UITextField *againPwdTF = [[UITextField alloc] init];
    againPwdTF.placeholder = @"请再次输入新密码";
    againPwdTF.textColor = kBlackColor;
    againPwdTF.textAlignment = NSTextAlignmentLeft;
    againPwdTF.secureTextEntry = YES;
    againPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [againPwdTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:againPwdTF];
    [againPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(naLineLb.mas_bottom).offset(SCALE_SIZE(20));
        make.left.equalTo(naLineLb.mas_left);
        make.right.equalTo(naLineLb.mas_right);
        make.height.mas_equalTo(SCALE_SIZE(20));
    }];
    self.againPwdTF = againPwdTF;
    
    UILabel *asLineLb = [[UILabel alloc] init];
    asLineLb.backgroundColor = RGBHex(0xdfdfdf);
    [bgView addSubview:asLineLb];
    [asLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(againPwdTF.mas_bottom).offset(14);
        make.left.equalTo(againPwdTF.mas_left);
        make.right.equalTo(bgView).offset(SCALE_SIZE(-34));
        make.height.mas_equalTo(1);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = JKFont(16);
    submitBtn.layer.cornerRadius = 4.0f;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.alpha = 0.5;
    submitBtn.userInteractionEnabled = NO;
    [bgView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(asLineLb.mas_bottom).offset(SCALE_SIZE(40));
        make.left.equalTo(bgView).offset(SCALE_SIZE(34));
        make.right.equalTo(bgView).offset(SCALE_SIZE(-34));
        make.height.mas_equalTo(SCALE_SIZE(44));
    }];
    self.submitBtn = submitBtn;
}

#pragma mark -- 提交的点击事件
- (void)submitBtnClick:(UIButton *)btn {
    if ([self.oldPwdTF.text isEqualToString:self.nPwdTF.text]) {
        [YJProgressHUD showMessage:@"原密码和新密码不能一样" inView:self.view afterDelayTime:2];
        return;
    }
    
    if (![self.nPwdTF.text isEqualToString:self.againPwdTF.text]) {
        [YJProgressHUD showMessage:@"请输入相同的新密码" inView:self.view afterDelayTime:2];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[JKUserDefaults objectForKey:@"loginid"] forKey:@"loginid"];
    [params setObject:self.oldPwdTF.text forKey:@"oldPW"];
    [params setObject:self.nPwdTF.text forKey:@"newPW"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", kUrl_ModifyPwd];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([responseObject[@"message"] isEqualToString:@"OK"]) {
            [YJProgressHUD showMessage:@"修改成功" inView:self.view afterDelayTime:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [YJProgressHUD showMsgWithImage:responseObject[@"message"] imageName:iFailPath inview:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark --  监听UITextField
- (void)textFieldChanged {
    if ([self.oldPwdTF.text trimmingCharacters].length > 20) {
        NSString *str = [self.oldPwdTF.text substringToIndex:20];
        self.oldPwdTF.text = str;
        return;
    }
    
    if ([self.nPwdTF.text trimmingCharacters].length > 20) {
        NSString *str = [self.nPwdTF.text substringToIndex:20];
        self.nPwdTF.text = str;
        return;
    }
    
    if ([self.againPwdTF.text trimmingCharacters].length > 20) {
        NSString *str = [self.againPwdTF.text substringToIndex:20];
        self.againPwdTF.text = str;
        return;
    }
    
    if ([self.oldPwdTF.text trimmingCharacters].length > 0 && [self.nPwdTF.text trimmingCharacters].length > 0 && [self.againPwdTF.text trimmingCharacters].length > 0) {
        self.submitBtn.alpha = 1;
        self.submitBtn.userInteractionEnabled = YES;
    } else {
        self.submitBtn.alpha = 0.5;
        self.submitBtn.userInteractionEnabled = NO;
    }
}

@end
