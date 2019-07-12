//
//  JKToolKit.h
//  BusinessManager
//
//  Created by    on 2018/6/15.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKToolKit : NSObject

+ (void)callPhoneWithNumber:(NSString *)phoneNumber;
+ (NSString *)imageToString:(UIImage *)image;
+ (NSInteger)getNowTimestamp;
+ (NSString *)isNullToString:(id)string;
@end
