//
//  JKRecyceView.h
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceViewDelegate <NSObject>

@end

@interface JKRecyceView : UIView
@property (nonatomic, weak) id<JKRecyceViewDelegate> delegate;

- (void)alertViewInView:(UIView *)view WithTitle:(NSString *)title withContent:(NSString *)content;

@end
