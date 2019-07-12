//
//  JKEquipmentModel.h
//  OperationsManager
//
//  Created by    on 2018/9/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKEquipmentModel : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *dissolvedOxygen;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *ph;
@property (nonatomic, strong) NSString *enabled;
@property (nonatomic, strong) NSString *automatic;
@property (nonatomic, strong) NSString *workStatus;
@property (nonatomic, strong) NSString *oxyLimitUp;
@property (nonatomic, strong) NSString *oxyLimitDownOne;
@property (nonatomic, strong) NSString *oxyLimitDownTwo;
@property (nonatomic, strong) NSString *alertlineOne;
@property (nonatomic, strong) NSString *alertlineTwo;
@property (nonatomic, strong) NSString *aeratorControlOne;
@property (nonatomic, strong) NSString *aeratorControlTwo;
@property (nonatomic, strong) NSString *channelA;
@property (nonatomic, strong) NSString *statusA;
@property (nonatomic, strong) NSString *hasAmmeterA;
@property (nonatomic, strong) NSString *ammeterTypeA;
@property (nonatomic, strong) NSString *ammeterIdA;
@property (nonatomic, strong) NSString *powerA;
@property (nonatomic, strong) NSString *voltageUpA;
@property (nonatomic, strong) NSString *voltageDownA;
@property (nonatomic, strong) NSString *electricCurrentUpA;
@property (nonatomic, strong) NSString *electricCurrentDownA;
@property (nonatomic, strong) NSString *channelB;
@property (nonatomic, strong) NSString *statusB;
@property (nonatomic, strong) NSString *hasAmmeterB;
@property (nonatomic, strong) NSString *ammeterTypeB;
@property (nonatomic, strong) NSString *ammeterIdB;
@property (nonatomic, strong) NSString *powerB;
@property (nonatomic, strong) NSString *voltageUpB;
@property (nonatomic, strong) NSString *voltageDownB;
@property (nonatomic, strong) NSString *electricCurrentUpB;
@property (nonatomic, strong) NSString *electricCurrentDownB;
@property (nonatomic, strong) NSString *scheduled;
@end
