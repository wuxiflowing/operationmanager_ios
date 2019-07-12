//
//  JKRecyceOrderCell.m
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceOrderCell.h"
#import "JKRecyceInfoModel.h"

@implementation JKRecyceOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(JKRecyceInfoModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.right.bottom.equalTo(self.contentView);
    }];

    UILabel *recyceLb = [[UILabel alloc] init];
    recyceLb.text = @"回收工单";
    recyceLb.textColor = RGBHex(0x333333);
    recyceLb.textAlignment = NSTextAlignmentLeft;
    recyceLb.font = JKFont(16);
    [bgView addSubview:recyceLb];
    [recyceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.recyceType == JKRecyceWait) {
        stateLb.text = @"待接单";
    } else if (self.recyceType == JKRecyceIng) {
        stateLb.text = @"进行中";
    } else if (self.recyceType == JKRecyceEd) {
        stateLb.text = @"已完成";
    }
    stateLb.textColor = kRedColor;
    stateLb.textAlignment = NSTextAlignmentRight;
    stateLb.font = JKFont(16);
    [bgView addSubview:stateLb];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recyceLb.mas_bottom);
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

    UILabel *pondNameLb = [[UILabel alloc] init];
    pondNameLb.text = [NSString stringWithFormat:@"鱼塘名称：%@", model.txtPondName];
    pondNameLb.textColor = RGBHex(0x333333);
    pondNameLb.textAlignment = NSTextAlignmentLeft;
    pondNameLb.font = JKFont(14);
    [bgView addSubview:pondNameLb];
    [pondNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLineLb.mas_bottom).offset(5);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];

    UILabel *phoneLb = [[UILabel alloc] init];
    phoneLb.text = [NSString stringWithFormat:@"联系方式：%@",model.txtPondPhone];
    phoneLb.textColor = RGBHex(0x333333);
    phoneLb.textAlignment = NSTextAlignmentLeft;
    phoneLb.font = JKFont(14);
    [bgView addSubview:phoneLb];
    [phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];

    UILabel *resMultiLb = [[UILabel alloc] init];
    resMultiLb.text = [NSString stringWithFormat:@"回收原因：%@",model.txtResMulti];
    resMultiLb.textColor = RGBHex(0x333333);
    resMultiLb.textAlignment = NSTextAlignmentLeft;
    resMultiLb.font = JKFont(14);
    resMultiLb.numberOfLines = 2;
    [bgView addSubview:resMultiLb];
    [resMultiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];

    UILabel *remarkLb = [[UILabel alloc] init];
    remarkLb.text = [NSString stringWithFormat:@"备注信息：%@",model.tarRemarks];
    remarkLb.textColor = RGBHex(0x333333);
    remarkLb.textAlignment = NSTextAlignmentLeft;
    remarkLb.font = JKFont(14);
    remarkLb.numberOfLines = 2;
    [bgView addSubview:remarkLb];
    [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resMultiLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];

    UILabel *operationPeopleLb = [[UILabel alloc] init];
    operationPeopleLb.text = [NSString stringWithFormat:@"养殖管家：%@",model.txtHK];
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [bgView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkLb.mas_bottom);
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
