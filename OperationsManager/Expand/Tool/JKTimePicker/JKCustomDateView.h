//
//  JKCustomDateView.h
//  ChaZX
//
//  Created by    on 2018/8/23.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKCustomDateView;
@class JKDate;
typedef void(^CustomDateBlock)(JKCustomDateView *bView,JKDate *leftDate,JKDate *rightDate);

@interface JKDate : NSObject

@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger day;
@property (nonatomic,assign) NSInteger hour;
@property (nonatomic,assign) NSInteger minute;

- (NSString *)toStringWithSperastring:(NSString *)spera;

- (NSString *)twoCharStringWithSperastring;

- (NSTimeInterval)toTimeInterval;

- (NSDate *)toDateTime;

@end

@interface JKCustomDateView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSDate     *leftStartDate;
@property (nonatomic,strong) NSDate     *leftEndDate;
@property (nonatomic,strong) NSDate     *rightStartDate;
@property (nonatomic,strong) NSDate     *rightEndDate;
@property (nonatomic,assign) BOOL        changedData;
@property (nonatomic,copy) CustomDateBlock   block;

- (instancetype)initWithFrame:(CGRect)frame minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;
- (void)selectDate:(NSDate *)date isRight:(BOOL)isRight;

- (JKDate *)leftDate;
- (NSString *)leftDateString;
- (JKDate *)rightDate;
- (NSString *)rightDateString;

- (void)initStatus:(NSDictionary*)dic;

@end
