//
//  JKMaintainOrderCell.m
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMaintainOrderCell.h"
#import "JKMaintainInfoModel.h"

@implementation JKMaintainOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(JKMaintainInfoModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *maintainNoLb = [[UILabel alloc] init];
    maintainNoLb.text = @"维护工单";
    maintainNoLb.textColor = RGBHex(0x333333);
    maintainNoLb.textAlignment = NSTextAlignmentLeft;
    maintainNoLb.font = JKFont(16);
    [bgView addSubview:maintainNoLb];
    [maintainNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.maintainType == JKMaintainWait) {
        stateLb.text = @"待接单";
    } else if (self.maintainType == JKMaintainIng) {
        stateLb.text = @"进行中";
    } else if (self.maintainType == JKMaintainEd) {
        stateLb.text = @"已完成";
    }
    stateLb.textColor = kRedColor;
    stateLb.textAlignment = NSTextAlignmentRight;
    stateLb.font = JKFont(16);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(48);
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(maintainNoLb.mas_bottom);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];
    
    CGFloat width = SCREEN_WIDTH - 50;
    
    UILabel *pondAddrLb = [[UILabel alloc] init];
    pondAddrLb.text = [NSString stringWithFormat:@"鱼塘位置：%@", model.txtPondAddr];
    pondAddrLb.textColor = RGBHex(0x333333);
    pondAddrLb.textAlignment = NSTextAlignmentLeft;
    pondAddrLb.numberOfLines = 2;
    pondAddrLb.font = JKFont(15);
    pondAddrLb.lineBreakMode = NSLineBreakByTruncatingTail;
    pondAddrLb.userInteractionEnabled = YES;
    [bgView addSubview:pondAddrLb];
    NSDictionary *pondAddrAttribute = @{NSFontAttributeName: JKFont(15)};
    CGSize pondAddrtTextSize = [pondAddrLb.text boundingRectWithSize:CGSizeMake(width, 45) options:NSStringDrawingTruncatesLastVisibleLine attributes:pondAddrAttribute context:nil].size;
    [pondAddrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineLb.mas_bottom);
        make.left.equalTo(bgView).offset(15);
        make.width.mas_equalTo(pondAddrtTextSize.width + 5);
        make.height.mas_equalTo(45);
    }];
    
    UIButton *addrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addrBtn addTarget:self action:@selector(addrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pondAddrLb addSubview:addrBtn];
    [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(pondAddrLb);
        make.right.equalTo(bgView);
    }];
    
    UIImageView *addrImgV = [[UIImageView alloc] init];
    addrImgV.image = [UIImage imageNamed:@"ic_installation_record_addr"];
    addrImgV.contentMode = UIViewContentModeCenter;
    [bgView addSubview:addrImgV];
    [addrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pondAddrLb.mas_centerY);
        make.left.equalTo(pondAddrLb.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(12, 15));
    }];
    
    UILabel *bottomLineLb = [[UILabel alloc] init];
    bottomLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:bottomLineLb];
    [bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondAddrLb.mas_bottom).offset(5);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(0.5);
    }];

    UILabel *orderNoLb = [[UILabel alloc] init];
    orderNoLb.text = [NSString stringWithFormat:@"工单号：%@",model.txtFormNo];
    orderNoLb.textColor = RGBHex(0x333333);
    orderNoLb.textAlignment = NSTextAlignmentLeft;
    orderNoLb.font = JKFont(14);
    [bgView addSubview:orderNoLb];
    [orderNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLineLb.mas_bottom).offset(5);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];

    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = [NSString stringWithFormat:@"鱼塘名称：%@",model.txtPondsName];
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(14);
    [bgView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNoLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];

    UILabel *deviceIDLb = [[UILabel alloc] init];
    deviceIDLb.text = [NSString stringWithFormat:@"设备类型: %@",model.txtRepairEqpKind];
    deviceIDLb.textColor = RGBHex(0x333333);
    deviceIDLb.textAlignment = NSTextAlignmentLeft;
    deviceIDLb.font = JKFont(14);
    [bgView addSubview:deviceIDLb];
    [deviceIDLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];

    UILabel *operationPeopleLb = [[UILabel alloc] init];
    if ([model.txtFormNo hasPrefix:@"SM"]) {
        operationPeopleLb.text = [NSString stringWithFormat:@"监控人员：%@",model.txtMonMembName];
    } else {
        operationPeopleLb.text = [NSString stringWithFormat:@"养殖管家：%@",model.txtHKName];
    }
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [bgView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceIDLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
}

- (void)addrBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(showOtherMap)]) {
        [_delegate showOtherMap];
    }
}

@end
