//
//  JKPersonalVC.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKPersonalVC.h"

@interface JKPersonalVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) NSString *nickNameStr;
@end

@implementation JKPersonalVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
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
    
    self.title = @"个人中心";
    
    self.titlesArr = @[@"头像", @"姓名", @"手机", @"分中心"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom).offset(SCALE_SIZE(10));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SCALE_SIZE(75);
    } else {
        return SCALE_SIZE(50);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        UIImageView *headImgV = [[UIImageView alloc] init];
        [headImgV yy_setImageWithURL:[NSURL URLWithString:[JKUserDefaults objectForKey:@"photoUrl"]] placeholder:[UIImage imageNamed:@"ic_head_default"]];
        headImgV.contentMode = UIViewContentModeScaleAspectFit;
        headImgV.layer.cornerRadius = 25 * SCREEN_SCALE;
        headImgV.layer.masksToBounds = YES;
        [cell.contentView addSubview:headImgV];
        [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-SCALE_SIZE(15));
            make.size.mas_equalTo(CGSizeMake(SCALE_SIZE(56), SCALE_SIZE(56)));
        }];
        self.headImgV = headImgV;
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [JKUserDefaults objectForKey:@"userName"];
    } else if (indexPath.row == 2) {
        cell.detailTextLabel.text = [JKUserDefaults objectForKey:@"phone"];
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = [JKUserDefaults objectForKey:@"dep"];
    }
    
    cell.textLabel.text = self.titlesArr[indexPath.row];
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.textLabel.font = JKFont(16);
    cell.detailTextLabel.textColor = RGBHex(0x666666);
    cell.detailTextLabel.font = JKFont(16);
    return cell;
}

@end
