//
//  JKSystemMessageCell.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKSystemMessageCell.h"
#import "JKTaskMessageModel.h"

@interface JKSystemMessageCell()
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *timeLb;
@end

@implementation JKSystemMessageCell

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
    bgView.layer.cornerRadius = 8;
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
}

@end
