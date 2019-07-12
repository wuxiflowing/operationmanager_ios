//
//  JKAlarmMessageCell.m
//  BusinessManager
//
//  Created by    on 2018/6/15.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKAlarmMessageCell.h"
#import "JKTaskMessageModel.h"

@interface JKAlarmMessageCell()
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *timeLb;
@end

@implementation JKAlarmMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
    }
    return self;
}

- (void)taskMessgeWithModel:(JKTaskMessageModel *)model {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    bgView.layer.cornerRadius = 12;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(SCALE_SIZE(15));
        make.right.equalTo(self).offset(-SCALE_SIZE(15));
        make.top.equalTo(self).offset(15);
    }];
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = model.keyword;
    titleLb.textColor = RGBHex(0x333333);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(16);
    [bgView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(20);
    }];
    self.titleLb = titleLb;
    
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.text = model.createDate;
    timeLb.textColor = RGBHex(0x999999);
    timeLb.textAlignment = NSTextAlignmentLeft;
    timeLb.font = JKFont(14);
    [bgView addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(5);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.height.mas_equalTo(20);
    }];
    self.timeLb = timeLb;
    
    //    UILabel *viewLb = [[UILabel alloc] init];
    //    viewLb.text = @"点击查看";
    //    viewLb.textColor = RGBHex(0x333333);
    //    viewLb.textAlignment = NSTextAlignmentLeft;
    //    viewLb.font = JKFont(14);
    //    [bgView addSubview:viewLb];
    //    [viewLb mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(bgView.mas_bottom);
    //        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
    //        make.size.mas_equalTo(CGSizeMake(100, 44));
    //    }];
    //
    //    UIImageView *arrowImgV = [[UIImageView alloc] init];
    //    arrowImgV.image = [UIImage imageNamed:@"ic_arrow"];
    //    [bgView addSubview:arrowImgV];
    //    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(viewLb.mas_centerY);
    //        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
    //        make.size.mas_equalTo(CGSizeMake(9, 16));
    //    }];
    //
    //    UILabel *lineLb = [[UILabel alloc] init];
    //    lineLb.backgroundColor = RGBHex(0xdddddd);
    //    [bgView addSubview:lineLb];
    //    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(viewLb.mas_top);
    //        make.left.equalTo(bgView.mas_left);
    //        make.right.equalTo(bgView.mas_right);
    //        make.height.mas_equalTo(1);
    //    }];
    //
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.text = model.msgContent;
    contentLb.textColor = RGBHex(0x888888);
    contentLb.textAlignment = NSTextAlignmentLeft;
    contentLb.font = JKFont(14);
    contentLb.numberOfLines = 2;
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:contentLb.text];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentLb.text length])];
    [contentLb setAttributedText:setString];
    [bgView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom);
        make.left.equalTo(bgView.mas_left).offset(SCALE_SIZE(15));
        make.right.equalTo(bgView.mas_right).offset(-SCALE_SIZE(15));
        make.top.mas_equalTo(timeLb.mas_bottom);
    }];
    self.contentLb = contentLb;
    //
    //    UIImageView *readImgV = [[UIImageView alloc] init];
    //    if ([model.isRead isEqualToString:@"N"]) {
    //        readImgV.image = [UIImage imageNamed:@"ic_message_unread"];
    //    } else {
    //        readImgV.image = [UIImage imageNamed:@"ic_message_read"];
    //    }
    //    [bgView addSubview:readImgV];
    //    [readImgV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(timeLb.mas_bottom);
    //        make.right.equalTo(timeLb.mas_right);
    //        make.size.mas_equalTo(CGSizeMake(52, 41));
    //    }];
}

@end
