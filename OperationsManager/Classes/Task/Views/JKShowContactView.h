//
//  JKShowContactView.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/15.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//输入内容回调
typedef void(^ensureContactCallback)(NSString *contact);

@interface JKShowContactView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSArray *list;
/**
 初始化
 */
+ (instancetype)showContactView;


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
- (void)ensureCotactClickBlock:(ensureContactCallback) block;
@end

NS_ASSUME_NONNULL_END
