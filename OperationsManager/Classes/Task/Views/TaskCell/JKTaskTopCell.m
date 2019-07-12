//
//  JKTaskTopCell.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKTaskTopCell.h"

@implementation JKTaskTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *headImgV = [[UIImageView alloc] init];
    headImgV.layer.cornerRadius = 20;
    headImgV.layer.masksToBounds = YES;
    [self addSubview:headImgV];
    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(SCALE_SIZE(15));
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.headImgV = headImgV;
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setImage:[UIImage imageNamed:@"ic_call_blue"] forState: UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = RGBHex(0xdddddd);
    [self addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(phoneBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    
    UILabel *nameLb = [[UILabel alloc] init];
    nameLb.textColor = RGBHex(0x333333);
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.font = JKFont(16);
    [self addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(7);
        make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(lineLb.mas_left).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(20);
    }];
    self.nameLb = nameLb;
    
    UILabel *addrLb = [[UILabel alloc] init];
    addrLb.textColor = RGBHex(0x888888);
    addrLb.textAlignment = NSTextAlignmentLeft;
    addrLb.font = JKFont(14);
    addrLb.numberOfLines = 0;
    [self addSubview:addrLb];
    [addrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLb.mas_bottom).offset(3);
        make.left.equalTo(headImgV.mas_right).offset(SCALE_SIZE(15));
        make.right.equalTo(lineLb.mas_left).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(35);
    }];
    self.addrLb = addrLb;
}

- (void)setHeadImgStr:(NSString *)headImgStr {
    _headImgStr = headImgStr;
    if ([_headImgStr isEqualToString:@""]) {
        self.headImgV.image = [UIImage imageNamed:@"ic_head_default"];
    } else {
        self.headImgV.yy_imageURL = [NSURL URLWithString:_headImgStr];
    }
}

- (void)setNameLb:(UILabel *)nameLb {
    _nameLb = nameLb;
}

- (void)setAddrLb:(UILabel *)addrLb {
    _addrLb = addrLb;
}

- (void)phoneBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(callFarmerPhone:)]) {
        [_delegate callFarmerPhone:self.telStr];
    }
}


@end
