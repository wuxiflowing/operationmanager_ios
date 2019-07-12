//
//  JKDeviceModel.h
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  strongright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKDeviceModel : NSObject <NSCoding>
@property (nonatomic , assign) NSInteger no;
@property (nonatomic , strong) NSString *pondId;
@property (nonatomic , strong) NSString *deviceId;
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *type;
@property (nonatomic , assign) CGFloat dissolvedOxygen;
@property (nonatomic , assign) CGFloat temperature;
@property (nonatomic , assign) CGFloat ph;
@property (nonatomic , assign) NSInteger alarmType;
@property (nonatomic , strong) NSString *automatic;
@property (nonatomic , assign) NSInteger workStatus;
@property (nonatomic , assign) CGFloat oxyLimitUp;
@property (nonatomic , assign) CGFloat oxyLimitDownOne;
@property (nonatomic , assign) CGFloat oxyLimitDownTwo;
@property (nonatomic , assign) CGFloat alertlineOne;
@property (nonatomic , assign) CGFloat alertlineTwo;
@property (nonatomic , strong) NSArray *aeratorControls;
@property (nonatomic , strong) NSString *channelA;
@property (nonatomic , strong) NSString *statusA;
@property (nonatomic , strong) NSString *hasAmmeterA;
@property (nonatomic , strong) NSString *ammeterTypeA;
@property (nonatomic , strong) NSString *ammeterIdA;
@property (nonatomic , strong) NSString *powerA;
@property (nonatomic , strong) NSString *openA;
@property (nonatomic , strong) NSString *voltageUpA;
@property (nonatomic , strong) NSString *voltageDownA;
@property (nonatomic , strong) NSString *electricCurrentUpA;
@property (nonatomic , strong) NSString *electricCurrentDownA;
@property (nonatomic , strong) NSString *aeratorNameA;
@property (nonatomic , strong) NSString *channelB;
@property (nonatomic , strong) NSString *statusB;
@property (nonatomic , strong) NSString *hasAmmeterB;
@property (nonatomic , strong) NSString *ammeterTypeB;
@property (nonatomic , strong) NSString *ammeterIdB;
@property (nonatomic , strong) NSString *powerB;
@property (nonatomic , strong) NSString *openB;
@property (nonatomic , strong) NSString *voltageUpB;
@property (nonatomic , strong) NSString *voltageDownB;
@property (nonatomic , strong) NSString *electricCurrentUpB;
@property (nonatomic , strong) NSString *electricCurrentDownB;
@property (nonatomic , strong) NSString *aeratorNameB;

@property (nonatomic , strong) NSString *addr;
@property (nonatomic , assign) CGFloat lat;
@property (nonatomic , assign) CGFloat lng;


@end