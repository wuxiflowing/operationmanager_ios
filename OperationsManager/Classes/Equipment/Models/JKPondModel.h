//
//  JKPondModel.h
//  OperationsManager
//
//  Created by    on 2018/8/13.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKPondModel : NSObject
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *farmerId;
@property (nonatomic, strong) NSString *fishVariety;
@property (nonatomic, strong) NSString *fryNumber;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *linkMan;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *pondAddress;
@property (nonatomic, strong) NSString *pondId;
@property (nonatomic, strong) NSString *putInBatch;
@property (nonatomic, strong) NSString *putInDate;
@property (nonatomic, strong) NSString *realSaleDate;
@property (nonatomic, strong) NSString *receiveAddress;
@property (nonatomic, strong) NSString *reckonSaleDate;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *trafficCondition;
@property (nonatomic, strong) NSArray *childDeviceList;
@end


@interface JKPondChildDeviceModel : NSObject
@property (nonatomic, strong) NSString *alarmType;
@property (nonatomic, strong) NSString *alertlineTwo;
@property (nonatomic, strong) NSString *automatic;
@property (nonatomic, assign) CGFloat dissolvedOxygen;
@property (nonatomic, strong) NSString *enabled;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *deviceIdentifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *oxyLimitDownOne;
@property (nonatomic, strong) NSString *oxyLimitUp;
@property (nonatomic, assign) CGFloat ph;
@property (nonatomic, strong) NSString *scheduled;
@property (nonatomic, assign) CGFloat temperature;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSInteger workStatus;
@property (nonatomic, strong) NSString *aeratorControlTwo;
@property (nonatomic, strong) NSString *aeratorControlOne;
@property (nonatomic, strong) NSString *ident;

@property (nonatomic, strong) NSString *aeratorControlTree;
@property (nonatomic, strong) NSString *aeratorControlFour;
@property (nonatomic, strong) NSString *statusControlOne;
@property (nonatomic, strong) NSString *statusControlTwo;
@property (nonatomic, strong) NSString *statusControlTree;
@property (nonatomic, strong) NSString *statusControlFour;


@end
