//
//  JKCommonTaskCell.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKCommonTaskCell.h"

@interface JKCommonTaskCell()
@property (nonatomic, strong) NSArray *taskArr;
@property (nonatomic, strong) NSArray *taskImgArr;
@end

@implementation JKCommonTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.taskArr = @[@"安装任务", @"维护任务", @"报修任务", @"回收任务", @"扫一扫"];
        self.taskImgArr = @[@"ic_installation", @"ic_maintenanceRecord", @"ic_repair", @"ic_recycling", @"ic_scan_new"];
    }
    return self;
}

- (void)createUI:(NSMutableArray *)dataSource {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"常用任务";
    titleLb.textColor = kBlackColor;
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(16);
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.left.equalTo(self.contentView).offset(SCALE_SIZE(15));
        make.right.equalTo(self.contentView).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(30);
    }];
    
    CGFloat btnWidth = SCREEN_WIDTH / 4;
    for (int i = 0; i < self.taskArr.count; i++) {
        NSInteger col = i / 4;
        NSInteger row = i % 4;
        UIView *taskView = [[UIView alloc] init];
        taskView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:taskView];
        [taskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(SCALE_SIZE(20) + 30 + btnWidth * col);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnWidth);
            make.left.mas_equalTo(btnWidth * row);
        }];
        
        UIImageView *btnImgV = [[UIImageView alloc] init];
        btnImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.taskImgArr[i]]];
        [taskView addSubview:btnImgV];
        [btnImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(taskView.mas_centerX);
            make.centerY.equalTo(taskView.mas_centerY).offset(-10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 8, SCREEN_WIDTH / 8));
        }];
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = self.taskArr[i];
        titleLb.textColor = RGBHex(0x666666);
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = JKFont(12);
        titleLb.adjustsFontSizeToFitWidth = YES;
        [taskView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(taskView.mas_centerX);
            make.bottom.equalTo(taskView.mas_bottom);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(30);
        }];
        
        UIButton *taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        taskBtn.frame = CGRectMake((btnWidth - SCREEN_WIDTH / 8 - 10) / 2, 10, SCREEN_WIDTH / 8, SCREEN_WIDTH / 8 + 30);
        if (dataSource.count != 0) {
            if ([dataSource[i] integerValue] > 99) {
                taskBtn.badgeValue = @"99+";
            } else {
                taskBtn.badgeValue = dataSource[i];
            }
        } else {
            taskBtn.badgeValue = nil;
        }
        taskBtn.backgroundColor = kClearColor;
        taskBtn.tag = i;
        [taskBtn addTarget:self action:@selector(taskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [taskView addSubview:taskBtn];
    }
}

- (void)taskBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(commonTaskBtnsClick:)]) {
        [_delegate commonTaskBtnsClick:btn];
    }
}


@end
