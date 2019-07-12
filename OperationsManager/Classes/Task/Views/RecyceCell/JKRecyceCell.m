//
//  JKRecyceCell.m
//  OperationsManager
//
//  Created by    on 2018/7/5.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceCell.h"
#import "JKTaskModel.h"

@implementation JKRecyceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(JKTaskModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGBHex(0x79c4ff);
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = kWhiteColor;
    [bgView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(40);
        make.left.right.bottom.equalTo(bgView);
    }];
    
    UILabel *farmerNameLb = [[UILabel alloc] init];
    farmerNameLb.text = [NSString stringWithFormat:@"%@", model.farmerName];
    farmerNameLb.textColor = kWhiteColor;
    farmerNameLb.textAlignment = NSTextAlignmentCenter;
    farmerNameLb.font = JKFont(17);
    farmerNameLb.numberOfLines = 1;
    [bgView addSubview:farmerNameLb];
    NSDictionary *attribute = @{NSFontAttributeName: JKFont(17)};
    CGSize textSize = [farmerNameLb.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 270, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    [farmerNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView).offset(5);
        make.size.mas_equalTo(CGSizeMake(textSize.width + 20, 40));
    }];
    
    UIImageView *callImgV = [[UIImageView alloc] init];
    callImgV.image = [UIImage imageNamed:@"ic_installation_record_call"];
    callImgV.contentMode = UIViewContentModeCenter;
    [bgView addSubview:callImgV];
    [callImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(farmerNameLb.mas_centerY);
        make.left.equalTo(farmerNameLb.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(13, 14));
    }];
    
    UILabel *phoneLb = [[UILabel alloc] init];
    phoneLb.text = [NSString stringWithFormat:@"%@",model.farmerPhone];
    phoneLb.textColor = kWhiteColor;
    phoneLb.textAlignment = NSTextAlignmentLeft;
    phoneLb.font = JKFont(17);
    [bgView addSubview:phoneLb];
    [phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(callImgV.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    self.telStr = model.farmerPhone;
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(callImgV.mas_left);
        make.right.equalTo(phoneLb.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *arrowImgV = [[UIImageView alloc] init];
    arrowImgV.image = [UIImage imageNamed:@"ic_white_arrow"];
    arrowImgV.contentMode = UIViewContentModeCenter;
    [bgView addSubview:arrowImgV];
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(farmerNameLb.mas_centerY);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecyceWait) {
        stateLb.text = @"待接单";
    } else if (self.recyceType == JKRecyceIng) {
        stateLb.text = @"进行中";
    } else if (self.recyceType == JKRecyceEd) {
        stateLb.text = @"已完成";
    }
    stateLb.textColor = kWhiteColor;
    stateLb.textAlignment = NSTextAlignmentRight;
    stateLb.font = JKFont(17);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.right.equalTo(arrowImgV.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    CGFloat width = SCREEN_WIDTH - 20 - 22 - 22 - 20;
    UILabel *pondAddrValueLb = [[UILabel alloc] init];
    pondAddrValueLb.text = [NSString stringWithFormat:@"%@",model.pondAddr];
    pondAddrValueLb.textColor = RGBHex(0x333333);
    pondAddrValueLb.textAlignment = NSTextAlignmentLeft;
    pondAddrValueLb.font = JKFont(15);
    pondAddrValueLb.numberOfLines = 2;
    pondAddrValueLb.lineBreakMode = NSLineBreakByTruncatingTail;
    [contentView addSubview:pondAddrValueLb];
    NSDictionary *pondAddrAttribute = @{NSFontAttributeName: JKFont(15)};
    CGSize pondAddrtTextSize = [pondAddrValueLb.text boundingRectWithSize:CGSizeMake(width, 45) options:NSStringDrawingTruncatesLastVisibleLine attributes:pondAddrAttribute context:nil].size;
    [pondAddrValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView).offset(10);
        make.width.mas_equalTo(pondAddrtTextSize.width + 5);
        make.height.mas_equalTo(45);
    }];
    
    UIImageView *addrImgV = [[UIImageView alloc] init];
    addrImgV.image = [UIImage imageNamed:@"ic_installation_record_addr"];
    addrImgV.contentMode = UIViewContentModeCenter;
    [contentView addSubview:addrImgV];
    [addrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pondAddrValueLb.mas_centerY);
        make.left.equalTo(pondAddrValueLb.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(12, 15));
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [contentView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondAddrValueLb.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
//    UIButton *addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addrBtn addTarget:self action:@selector(addrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:addrBtn];
//    [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentView);
//        make.left.right.equalTo(contentView);
//        make.bottom.equalTo(topLineLb.mas_top);
//    }];
    
    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = [NSString stringWithFormat:@"鱼塘名称：%@", model.pondsName];
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(14);
    [contentView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineLb.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *deviceRecyceLb = [[UILabel alloc] init];
    deviceRecyceLb.text = [NSString stringWithFormat:@"设备ID：%@", model.deviceID];
    deviceRecyceLb.textColor = RGBHex(0x333333);
    deviceRecyceLb.textAlignment = NSTextAlignmentLeft;
    deviceRecyceLb.font = JKFont(14);
    [contentView addSubview:deviceRecyceLb];
    [deviceRecyceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom).offset(5);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *operationPeopleLb = [[UILabel alloc] init];
    operationPeopleLb.text = [NSString stringWithFormat:@"养殖管家：%@", model.matnerMembName];
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [contentView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceRecyceLb.mas_bottom).offset(5);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *realTimeLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecyceEd) {
        realTimeLb.text = [NSString stringWithFormat:@"完成时间：%@",model.calCT];
    } else if (self.recyceType == JKRecyceIng) {
        realTimeLb.text = [NSString stringWithFormat:@"接单时间：%@",model.calOT];
    } else {
        realTimeLb.text = [NSString stringWithFormat:@"派单时间：%@",model.calDT];
    }
    realTimeLb.textColor = RGBHex(0x333333);
    realTimeLb.textAlignment = NSTextAlignmentLeft;
    realTimeLb.font = JKFont(14);
    [contentView addSubview:realTimeLb];
    [realTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationPeopleLb.mas_bottom).offset(5);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *bottomLineLb = [[UILabel alloc] init];
    bottomLineLb.backgroundColor = RGBHex(0xdddddd);
    [contentView addSubview:bottomLineLb];
    [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realTimeLb.mas_bottom).offset(10);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *detailLb = [[UILabel alloc] init];
    detailLb.text = @"查看详情";
    detailLb.textColor = RGBHex(0x666666);
    detailLb.textAlignment = NSTextAlignmentLeft;
    detailLb.font = JKFont(15);
    [contentView addSubview:detailLb];
    [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLineLb.mas_bottom);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    UIImageView *infoArrowImgV = [[UIImageView alloc] init];
    infoArrowImgV.image = [UIImage imageNamed:@"ic_arrow"];
    [contentView addSubview:infoArrowImgV];
    [infoArrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(detailLb.mas_centerY);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
}

- (void)phoneBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(callFarmerPhone:)]) {
        [_delegate callFarmerPhone:self.telStr];
    }
}

@end
