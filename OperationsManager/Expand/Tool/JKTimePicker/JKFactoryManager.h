//
//  JKFactoryManager.h
//  ChaZX
//
//  Created by    on 2018/8/23.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKFactoryManager : NSObject

// 本周
+ (NSDictionary *)thisWeek;
// 本月
+ (NSDictionary *)thisMonth;
// 和当天相比偏移的天数
+ (NSDictionary *)dayCompareTodayOffset:(NSInteger)offset;

+ (NSDateComponents *)dateComponentForTimeInterval:(NSTimeInterval)timeInterval;

+ (NSDate *)dateFromStringByHotline:(NSString *)string;

+ (NSDate *)dateFromStringByHotlineWithoutSeconds:(NSString *)string;

+ (NSArray *)yearMonthDayFromDate:(NSDate *)date;
// 字符串转时间戳
+ (NSTimeInterval)timeIntervalWithString:(NSString*)dataString;

+ (BOOL)compareDateOne:(NSDate *)dateOne earlierToDataTwo:(NSDate *)dateTwo;
// 是否是闰年
+ (BOOL)isLeapYear:(NSInteger)year;

@end
