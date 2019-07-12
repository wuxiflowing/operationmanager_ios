//
//  JKMessgaCell.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMessgaCell.h"
#import "JKMessageModel.h"

@interface JKMessgaCell()
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *detailLb;
@property (nonatomic, strong) UIButton *redDotBtn;
@property (nonatomic, strong) JKMessageModel *mModel;
@end

@implementation JKMessgaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *imgV = [[UIImageView alloc] init];
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    self.imgV = imgV;
    
    UIButton *redDotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redDotBtn.frame = CGRectMake(SCALE_SIZE(10), (70 - 45) / 2, 40, 45);
    redDotBtn.badgeBGColor = kRedColor;
    [self addSubview:redDotBtn];
    self.redDotBtn = redDotBtn;
    
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.textColor = RGBHex(0x999999);
    timeLb.textAlignment = NSTextAlignmentRight;
    timeLb.font = JKFont(12);
    [self addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(23);
    }];
    self.timeLb = timeLb;
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.textColor = kBlackColor;
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(17);
    [self addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(imgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(timeLb.mas_left).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(23);
    }];
    self.titleLb = titleLb;
    
    UILabel *detailLb = [[UILabel alloc] init];
    detailLb.textColor = RGBHex(0x999999);
    detailLb.textAlignment = NSTextAlignmentLeft;
    detailLb.font = JKFont(15);
    [self addSubview:detailLb];
    [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(imgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(self.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(22);
    }];
    self.detailLb = detailLb;
}

- (void)messgeInfoWithModel:(JKMessageModel *)model {
    if ([model.messageType isEqualToString:@"install"]) {
        self.imgV.image = [UIImage imageNamed:@"ic_device_installation"];
        self.titleLb.text = @"设备安装";
    } else if ([model.messageType isEqualToString:@"repair"]) {
        self.imgV.image = [UIImage imageNamed:@"ic_ault_warranty"];
        self.titleLb.text = @"故障报修";
    } else if ([model.messageType isEqualToString:@"maintain"]) {
        self.imgV.image = [UIImage imageNamed:@"ic_regular_maintenance"];
        self.titleLb.text = @"定期维护";
    } else if ([model.messageType isEqualToString:@"recycling"]) {
        self.imgV.image = [UIImage imageNamed:@"ic_quipment_recycling"];
        self.titleLb.text = @"设备回收";
    } else if ([model.messageType isEqualToString:@"sys"]) {
        self.imgV.image = [UIImage imageNamed:@"ic_system_message"];
        self.titleLb.text = @"系统消息";
    }
    self.timeLb.text = model.createDate;
    self.detailLb.text = model.keyword;
    if (![model.count isEqualToString:@"0"]) {
        if ([model.count integerValue] > 99) {
            self.redDotBtn.badgeValue = @"99+";
        } else {
            self.redDotBtn.badgeValue = [NSString stringWithFormat:@"%@",model.count];
        }
    } else {
        self.redDotBtn.badgeValue = nil;
    }
    self.mModel = model;
}

@end
