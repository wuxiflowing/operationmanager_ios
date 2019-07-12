//
//  JKMineVC.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMineVC.h"
#import "JKModifyPwdVC.h"
#import "JKPersonalVC.h"
#import "JKAboutUsVC.h"
#import "JKFeedbackVC.h"

@interface JKMineVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) NSArray *imgsArr;
@end

@implementation JKMineVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorColor = kBgColor;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgsArr = @[@[@""],@[@"ic_modifyPwd", @"ic_about", @"ic_feedback", @"ic_version"],@[@""]];
    self.titlesArr = @[@[@""],@[@"修改密码", @"关于庆渔堂", @"意见反馈", @"当前版本"],@[@""]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
    }];
}

#pragma mark -- 退出登录
- (void)loginOut {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [YJProgressHUD showProgressCircleNoValue:@"退出中..." inView:self.view];
        // 清空
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [defaults dictionaryRepresentation];
        for (id key in dict) {
            if (![key isEqualToString:@"gtToken"] && ![key isEqualToString:@"isFirst"] && ![key isEqualToString:@"loginid"]) {
                [defaults removeObjectForKey:key];
            }
        }
        [defaults synchronize];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YJProgressHUD hide];
            JKLoginVC *lVC = [[JKLoginVC alloc] init];
            JKNavigationVC *navi = [[JKNavigationVC alloc] initWithRootViewController:lVC];
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            [window setRootViewController:navi];
        });
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerV = [[UIView alloc] init];
    footerV.backgroundColor = kBgColor;
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCALE_SIZE(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCALE_SIZE(75);
    } else {
        return SCALE_SIZE(50);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.imageView.image = [UIImage imageNamed:self.imgsArr[indexPath.section][indexPath.row]];
    cell.textLabel.text = self.titlesArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = kBlackColor;
    cell.textLabel.font = JKFont(17);
    
    if (indexPath.section == 0) {
        UIImageView *headImgV = [[UIImageView alloc] init];
        [headImgV yy_setImageWithURL:[NSURL URLWithString:[JKUserDefaults objectForKey:@"photoUrl"]] placeholder:[UIImage imageNamed:@"ic_head_default"]];
        headImgV.layer.cornerRadius = SCALE_SIZE(28);
        headImgV.contentMode = UIViewContentModeScaleAspectFit;
        headImgV.layer.masksToBounds = YES;
        [cell.contentView addSubview:headImgV];
        [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView.mas_left).offset(SCALE_SIZE(15));
            make.size.mas_equalTo(CGSizeMake(SCALE_SIZE(56), SCALE_SIZE(56)));
        }];
        
        UILabel *nickNameLb = [[UILabel alloc] init];
        nickNameLb.text = [JKUserDefaults objectForKey:@"userName"];
        nickNameLb.textColor = kBlackColor;
        nickNameLb.textAlignment = NSTextAlignmentLeft;
        nickNameLb.font = JKFont(18);
        [cell.contentView addSubview:nickNameLb];
        [nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(SCALE_SIZE(28));
        }];
        
        UILabel *accountLb = [[UILabel alloc] init];
        accountLb.text = [JKUserDefaults objectForKey:@"phone"];
        accountLb.textColor = kGrayColor;
        accountLb.textAlignment = NSTextAlignmentLeft;
        accountLb.font = JKFont(15);
        [cell.contentView addSubview:accountLb];
        [accountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(SCALE_SIZE(28));
        }];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"v %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
            cell.detailTextLabel.textColor = kLightGrayColor;
            cell.detailTextLabel.font = JKFont(17);
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 2) {
        UILabel *loginOutLb = [[UILabel alloc] init];
        loginOutLb.text = @"退出登录";
        loginOutLb.textColor = kRedColor;
        loginOutLb.textAlignment = NSTextAlignmentCenter;
        loginOutLb.font = JKFont(18);
        [cell.contentView addSubview:loginOutLb];
        [loginOutLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JKPersonalVC *pVC = [[JKPersonalVC alloc] init];
        [self.navigationController pushViewController:pVC animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            JKModifyPwdVC *mpVC = [[JKModifyPwdVC alloc] init];
            [self.navigationController pushViewController:mpVC animated:YES];
        } else if (indexPath.row == 1) {
            JKAboutUsVC *auVC = [[JKAboutUsVC alloc] init];
            [self.navigationController pushViewController:auVC animated:YES];
        } else if (indexPath.row == 2) {
            JKFeedbackVC *fbVC = [[JKFeedbackVC alloc] init];
            [self.navigationController pushViewController:fbVC animated:YES];
        }
    } else {
        [self loginOut];
    }
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}


@end
