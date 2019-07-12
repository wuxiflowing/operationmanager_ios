//
//  TZImagePickerHelper.h
//  BusinessManager
//
//  Created by    on 2018/8/9.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZImagePickerHelper : NSObject <UINavigationControllerDelegate,  UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, assign) JKImageType imageType;
@property (nonatomic, copy) void(^finishInstallOrder)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishInstallService)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishInstallDeposit)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishRepaireFixOrder)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishRepaireReceipt)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishMaintain)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishRecyceDevicePhoto)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishRecyceDeviceOrder)(NSArray *array, NSArray *imageArr);
@property (nonatomic, copy) void(^finishAttachFile)(NSArray *array, NSArray *imageArr);

- (void)showImagePickerControllerWithMaxCount:(NSInteger )maxCount WithViewController: (UIViewController *)superController;

@end
