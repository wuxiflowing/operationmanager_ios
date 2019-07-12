//
//  JKMessageInfoVC.m
//  OperationsManager
//
//  Created by    on 2018/7/6.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKMessageInfoVC.h"

@interface JKMessageInfoVC ()

@end

@implementation JKMessageInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"标题";
    titleLb.textColor = RGBHex(0x333333);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.font = JKFont(17);
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.safeAreaTopView.mas_bottom).offset(SCALE_SIZE(20));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_offset(25);
    }];
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.text = @"江苏省无锡市滨湖区建筑西路586建苑大厦412室江苏省无锡市滨湖区建筑西路586筑西路586建苑大厦412室";
    contentLb.font = JKFont(15);
    contentLb.numberOfLines = 0;
    contentLb.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.headIndent = 0.0f;
    CGFloat emptylen = contentLb.font.pointSize * 2;
    paraStyle.firstLineHeadIndent = emptylen;//首行缩进
//    paraStyle.tailIndent = 0.0f;//行尾缩进
    paraStyle.lineSpacing = 5.0f;//行间距
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:contentLb.text attributes:@{NSParagraphStyleAttributeName:paraStyle}];
    contentLb.attributedText = attrText;
    CGSize size = [contentLb sizeThatFits:CGSizeMake(200, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    [self.view addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom);
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_offset(size.height);
    }];
    
    UILabel *timeLb = [[UILabel alloc] init];
    timeLb.text = @"2018年00月00日";
    timeLb.textColor = RGBHex(0x333333);
    timeLb.textAlignment = NSTextAlignmentRight;
    timeLb.font = JKFont(15);
    [self.view addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLb.mas_bottom).offset(SCALE_SIZE(20));
        make.left.equalTo(self.view).offset(SCALE_SIZE(15));
        make.right.equalTo(self.view).offset(-SCALE_SIZE(15));
        make.height.mas_offset(25);
    }];

}

@end
