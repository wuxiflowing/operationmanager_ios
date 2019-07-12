//
//  JKRecyceUntiedView.h
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceUntiedViewDelegate <NSObject>
- (void)scanDeviceIdent;
- (void)unitiedDevice:(NSString *)ident withDeviceIndex:(NSInteger)index;
@end

@interface JKRecyceUntiedView : UIView
@property (nonatomic, weak) id<JKRecyceUntiedViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withIdent:(NSString *)ident withPondName:(NSString *)pondName withPondIndex:(NSInteger)index;
- (void)alertViewInView:(UIView *)view; 

@end
