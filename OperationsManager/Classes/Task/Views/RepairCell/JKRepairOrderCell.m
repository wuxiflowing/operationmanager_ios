//
//  JKRepairOrderCell.m
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRepairOrderCell.h"
#import "JKRepaireInfoModel.h"

@implementation JKRepairOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)createUI:(JKRepaireInfoModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    self.bgView = bgView;
    
    UILabel *repairNoLb = [[UILabel alloc] init];
    repairNoLb.text = @"故障工单";
    repairNoLb.textColor = RGBHex(0x333333);
    repairNoLb.textAlignment = NSTextAlignmentLeft;
    repairNoLb.font = JKFont(16);
    [bgView addSubview:repairNoLb];
    [repairNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *stateLb = [[UILabel alloc] init];
    if (self.repaireType == JKRepaireWait) {
        stateLb.text = @"待接单";
    } else if (self.repaireType == JKRepaireIng) {
        stateLb.text = @"进行中";
    } else if (self.repaireType == JKRepaireEd) {
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
        make.height.mas_equalTo(40);
    }];
    
    UILabel *topLineLb = [[UILabel alloc] init];
    topLineLb.backgroundColor = RGBHex(0xdddddd);
    [bgView addSubview:topLineLb];
    [topLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repairNoLb.mas_bottom);
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
    pondNameLb.text = [NSString stringWithFormat:@"鱼塘名称：%@", model.txtPondsName];
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
    
    UILabel *operationPeopleLb = [[UILabel alloc] init];
    if ([model.txtFormNo hasPrefix:@"FM"]) {
        operationPeopleLb.text = [NSString stringWithFormat:@"监控人员：%@",model.txtMonMembName];
    } else {
        operationPeopleLb.text = [NSString stringWithFormat:@"养殖管家：%@",model.txtHKName];
    }
    operationPeopleLb.textColor = RGBHex(0x333333);
    operationPeopleLb.textAlignment = NSTextAlignmentLeft;
    operationPeopleLb.font = JKFont(14);
    [bgView addSubview:operationPeopleLb];
    [operationPeopleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pondNameLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *deviceTypeLb = [[UILabel alloc] init];
    deviceTypeLb.text = [NSString stringWithFormat:@"设备型号：%@",model.txtRepairEqpKind];
    deviceTypeLb.textColor = RGBHex(0x333333);
    deviceTypeLb.textAlignment = NSTextAlignmentLeft;
    deviceTypeLb.font = JKFont(14);
    [bgView addSubview:deviceTypeLb];
    [deviceTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationPeopleLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *faultDescriptionLb = [[UILabel alloc] init];
    faultDescriptionLb.text = [NSString stringWithFormat:@"故障描述：%@", model.txtMaintenDetail];
    faultDescriptionLb.textColor = RGBHex(0x333333);
    faultDescriptionLb.textAlignment = NSTextAlignmentLeft;
    faultDescriptionLb.numberOfLines = 2;
    faultDescriptionLb.font = JKFont(14);
    [bgView addSubview:faultDescriptionLb];
    [faultDescriptionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceTypeLb.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
    }];
    self.faultDescriptionValueLb = faultDescriptionLb;
}

- (void)setRepaireImg:(NSString *)repaireImg {
    _repaireImg = repaireImg;
    
    UILabel *pictureLb = [[UILabel alloc] init];
    pictureLb.text = @"报修图片：";
    pictureLb.textColor = RGBHex(0x333333);
    pictureLb.textAlignment = NSTextAlignmentLeft;
    pictureLb.font = JKFont(14);
    [self.bgView addSubview:pictureLb];
    [pictureLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faultDescriptionValueLb.mas_bottom);
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
    }];
    self.pictureLb = pictureLb;
    
    _repaireImg = [_repaireImg stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *repairePicArr = [_repaireImg componentsSeparatedByString:@","];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = kWhiteColor;
    [self.bgView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureLb.mas_bottom).offset(5);
        make.left.equalTo(self.bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(self.bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(80);
    }];

    scrollView.contentSize = CGSizeMake(90 * repairePicArr.count, 80);

    for (NSInteger i = 0; i < repairePicArr.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(90 * i , 0, 80, 80);
        imgV.userInteractionEnabled = YES;
        imgV.yy_imageURL = [NSURL URLWithString:repairePicArr[i]];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imgV];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 , 0, 110, 110);
        btn.tag = i;
        [btn addTarget:self action:@selector(txtReceiptImgClick:) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:btn];
    }
}

- (void)txtReceiptImgClick:(UIButton *)btn {
    self.repaireImg = [self.repaireImg stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *orderPicArr = [self.repaireImg componentsSeparatedByString:@","];
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:orderPicArr withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)addrBtnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(showOtherMap)]) {
        [_delegate showOtherMap];
    }
}

@end
