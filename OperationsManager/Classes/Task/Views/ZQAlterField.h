//
//  ZQAlterField.h
//  ZQAlterFieldDemo
//
//  Created by 肖兆强 on 2018/2/6.
//  Copyright © 2018年 ZQ. All rights reserved.
//

#import <UIKit/UIKit.h>
//输入内容回调
typedef void(^ensureCallback)(NSString *nameString,NSString *phoneString);


@interface ZQAlterField : UIView

@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

/**
 初始化
 */
+ (instancetype)alertView;


/**
 显示
 */
- (void)show;
/**
 隐藏
 */
- (void)dismiss;

/**
 结果回调
 */
- (void)ensureClickBlock:(ensureCallback) block;



@end
