//
//  JKLoginVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKLoginVC.h"

@interface JKLoginVC ()
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation JKLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    
    [self createUI];
}

#pragma mark -- 登录UI
- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIImageView *accountImgV = [[UIImageView alloc] init];
    accountImgV.image = [UIImage imageNamed:@"ic_account"];
    accountImgV.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:accountImgV];
    [accountImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(SCALE_SIZE(24));
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(34));
        make.size.mas_equalTo(CGSizeMake(SCALE_SIZE(25), SCALE_SIZE(25)));
    }];
    
    UITextField *accountTF = [[UITextField alloc] init];
    NSString *account = [JKUserDefaults objectForKey:@"loginid"];
    if (account != nil) {
        accountTF.text = account;
    }
    accountTF.placeholder = @"请输入账号";
    accountTF.textColor = kBlackColor;
    accountTF.textAlignment = NSTextAlignmentLeft;
    accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [accountTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:accountTF];
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(accountImgV.mas_centerY);
        make.left.equalTo(accountImgV.mas_right).offset(SCALE_SIZE(10));
        make.right.equalTo(bgView.mas_right).offset(SCALE_SIZE(-34));
        make.height.mas_equalTo(SCALE_SIZE(30));
    }];
    self.accountTF = accountTF;
    
    UILabel *apLineLb = [[UILabel alloc] init];
    apLineLb.backgroundColor = kBgColor;
    [bgView addSubview:apLineLb];
    [apLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountImgV.mas_bottom).offset(14);
        make.left.equalTo(accountImgV.mas_left);
        make.right.equalTo(bgView.mas_right).offset(SCALE_SIZE(-34));
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *pwdImgV = [[UIImageView alloc] init];
    pwdImgV.image = [UIImage imageNamed:@"ic_password"];
    pwdImgV.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:pwdImgV];
    [pwdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(apLineLb.mas_bottom).offset(SCALE_SIZE(24));
        make.left.equalTo(accountImgV.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCALE_SIZE(25), SCALE_SIZE(25)));
    }];
    
    UITextField *pwdTF = [[UITextField alloc] init];
    pwdTF.placeholder = @"请输入密码";
    pwdTF.textColor = kBlackColor;
    pwdTF.textAlignment = NSTextAlignmentLeft;
    pwdTF.secureTextEntry = YES;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pwdTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pwdImgV.mas_centerY);
        make.left.equalTo(accountTF.mas_left);
        make.right.equalTo(accountTF.mas_right);
        make.height.mas_equalTo(SCALE_SIZE(30));
    }];
    self.pwdTF = pwdTF;
    
    UILabel *plLineLb = [[UILabel alloc] init];
    plLineLb.backgroundColor = kBgColor;
    [bgView addSubview:plLineLb];
    [plLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdImgV.mas_bottom).offset(14);
        make.left.equalTo(pwdImgV.mas_left);
        make.right.equalTo(bgView.mas_right).offset(SCALE_SIZE(-34));
        make.height.mas_equalTo(1);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    loginBtn.layer.cornerRadius = 6;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.alpha = 0.5;
    loginBtn.userInteractionEnabled = NO;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_s"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"bg_login_n"] forState:UIControlStateSelected];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plLineLb.mas_bottom).offset(SCALE_SIZE(40));
        make.left.right.equalTo(plLineLb);
        make.height.mas_equalTo(SCALE_SIZE(44));
    }];
    self.loginBtn = loginBtn;
}

#pragma mark -- 登录点击事件
- (void)loginBtnClick:(UIButton *)btn {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.accountTF.text forKey:@"loginid"];
    [params setObject:self.pwdTF.text forKey:@"password"];
    [params setObject:[JKUserDefaults objectForKey:@"gtToken"] forKey:@"device"];

    [params setObject:@"Operation" forKey:@"queryType"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", kUrl_Login];

    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self.view];
    [[JKHttpTool shareInstance] PostReceiveInfo:params url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"success"]] isEqualToString:@"1"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                NSString *photoUrl = JKStringWithFormat(dict[@"photoUrl"]);
                if(![photoUrl isKindOfClass:[NSNull class]]) {
                    [JKUserDefaults setObject:photoUrl forKey:@"photoUrl"];
                }
                
                NSString *phone = JKStringWithFormat(dict[@"phone"]);
                if(![phone isKindOfClass:[NSNull class]]) {
                    [JKUserDefaults setObject:phone forKey:@"phone"];
                }
                
                NSString *userName = JKStringWithFormat(dict[@"userName"]);
                if(![userName isKindOfClass:[NSNull class]]) {
                    [JKUserDefaults setObject:userName forKey:@"userName"];
                }
                
                NSString *dep = JKStringWithFormat(dict[@"dep"]);
                if(![dep isKindOfClass:[NSNull class]])  {
                    [JKUserDefaults setObject:dep forKey:@"dep"];
                }
            }
            
            [JKUserDefaults setObject:self.accountTF.text forKey:@"loginid"];
            
            JKTabBarVC *tabBar = [[JKTabBarVC alloc] init];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            [window setRootViewController:tabBar];
            
        } else {
            [YJProgressHUD showMsgWithImage:@"登录失败" imageName:iFailPath inview:self.view];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

#pragma mark -- 监听UITextField
- (void)textFieldChanged {
    if ([self.accountTF.text trimmingCharacters].length > 0 && [self.pwdTF.text trimmingCharacters].length > 0) {
        self.loginBtn.alpha = 1;
        self.loginBtn.userInteractionEnabled = YES;
    } else {
        self.loginBtn.alpha = 0.5;
        self.loginBtn.userInteractionEnabled = NO;
    }
}


@end
