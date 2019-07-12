//
//  JKGuidePagesView.h
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKGuidePagesView : UIView

- (void)showGuideViewWithImages:(NSArray *)images
               andLoginBtnTitle:(NSString *)loginBtnTitle
          andLoginBtnTitleColor:(UIColor *)loginBtnTitleColor
             andLoginBtnBgColor:(UIColor *)loginBtnBgColor
         andLoginBtnBorderColor:(UIColor *)loginBtnBorderColor;

@end
