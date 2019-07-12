//
//  JKBaseVC.h
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKBaseVC : UIViewController
@property (nonatomic, strong) UIView *safeAreaTopView;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *titleLb;
- (void)createEmptyImgV;
@end
