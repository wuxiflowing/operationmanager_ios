//
//  NSString+JKString.m
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import "NSString+JKString.h"

@implementation NSString (JKString)

#pragma mark -- 去除多余的空白字符
- (NSString *) trimmingCharacters {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)cacheDic {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [path stringByAppendingPathComponent:self.lastPathComponent];
}

//- (NSString *)docDic {
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//
//    return [path stringByAppendingPathComponent:self.lastPathComponent];
//}
//
//- (NSString *)tmpDic {
//    NSString *path = NSTemporaryDirectory();
//
//    return [path stringByAppendingPathComponent:self.lastPathComponent];
//}

@end
