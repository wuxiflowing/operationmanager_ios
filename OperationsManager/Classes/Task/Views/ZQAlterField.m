//
//  ZQAlterField.m
//  ZQAlterFieldDemo
//
//  Created by 肖兆强 on 2018/2/6.
//  Copyright © 2018年 ZQ. All rights reserved.
//

#import "ZQAlterField.h"
#define kZLPhotoBrowserBundle [NSBundle bundleForClass:[self class]]

#define ZQWindow [UIApplication sharedApplication].keyWindow

@interface ZQAlterField ()<UITextFieldDelegate>

/**
 回调block
 */
@property (nonatomic, copy) ensureCallback ensureBlock;

/**
 蒙板
 */
@property (nonatomic, weak) UIView *becloudView;


@end



@implementation ZQAlterField

+ (instancetype)alertView
{
    return [[kZLPhotoBrowserBundle loadNibNamed:@"ZQAlterField" owner:self options:nil] lastObject];;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setCornerRadius:self];
    [self setCornerRadius:self.ensureBtn];
    [self setCornerRadius:self.cancelBtn];
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    // 添加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyboard)];
    [self addGestureRecognizer:tapGR];

    self.contactTextField.delegate = self;
    self.phoneTextField.delegate = self;

}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return YES;
    
}



#pragma mark - 设置控件圆角
- (void)setCornerRadius:(UIView *)view
{
    
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
}


- (void)show
{
    // 蒙版
    UIView *becloudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    becloudView.backgroundColor = [UIColor blackColor];
    becloudView.layer.opacity = 0.3;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlertView:)];
    [becloudView addGestureRecognizer:tapGR];
    
    [ZQWindow addSubview:becloudView];
    self.becloudView = becloudView;
    
    
    
    // 输入框
    self.frame = CGRectMake(0, 0, becloudView.frame.size.width * 0.8, 200);
    self.center = CGPointMake(becloudView.center.x, becloudView.frame.size.height * 0.4);
    [ZQWindow addSubview:self];
    
}

- (void)exitKeyboard
{
    [self endEditing:YES];
}

#pragma mark - 移除ZYInputAlertView
- (void)dismiss
{
    [self removeFromSuperview];
    [self.becloudView removeFromSuperview];
}

#pragma mark - 点击关闭按钮
- (IBAction)closeAlertView:(UIButton *)sender {
    [self dismiss];
}

#pragma mark - 接收传过来的block

- (void)ensureClickBlock:(ensureCallback)block

{
    self.ensureBlock = block;
}

#pragma mark - 点击确认按钮
- (IBAction)ensureBtnClick:(UIButton *)sender {
    [self dismiss];
    if (self.ensureBlock) {
        self.ensureBlock(self.contactTextField.text,self.phoneTextField.text);
    }
    
    
}


@end
