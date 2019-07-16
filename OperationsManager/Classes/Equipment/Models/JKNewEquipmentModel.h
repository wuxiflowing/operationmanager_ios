//
//  JKNewEquipmentModel.h
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKNewEquipmentModel : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *dissolvedOxygen;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *ph;
@property (nonatomic, strong) NSString *connectionType;
@property (nonatomic, strong) NSString *workStatus;
@property (nonatomic, strong) NSString *alertline1;
@property (nonatomic, strong) NSString *alertline2;

@property (nonatomic, strong) NSString *controlId1;
@property (nonatomic, strong) NSString *oxyLimitUp1;
@property (nonatomic, strong) NSString *oxyLimitDown1;
@property (nonatomic, strong) NSString *electricityUp1;
@property (nonatomic, strong) NSString *electricityDown1;
@property (nonatomic, strong) NSString *open1;
@property (nonatomic, strong) NSString *controlStatusAuto1;

@property (nonatomic, strong) NSString *controlId2;
@property (nonatomic, strong) NSString *oxyLimitUp2;
@property (nonatomic, strong) NSString *oxyLimitDown2;
@property (nonatomic, strong) NSString *electricityUp2;
@property (nonatomic, strong) NSString *electricityDown2;
@property (nonatomic, strong) NSString *open2;
@property (nonatomic, strong) NSString *controlStatusAuto2;

@property (nonatomic, strong) NSString *controlId3;
@property (nonatomic, strong) NSString *oxyLimitUp3;
@property (nonatomic, strong) NSString *oxyLimitDown3;
@property (nonatomic, strong) NSString *electricityUp3;
@property (nonatomic, strong) NSString *electricityDown3;
@property (nonatomic, strong) NSString *open3;
@property (nonatomic, strong) NSString *controlStatusAuto3;

@property (nonatomic, strong) NSString *controlId4;
@property (nonatomic, strong) NSString *oxyLimitUp4;
@property (nonatomic, strong) NSString *oxyLimitDown4;
@property (nonatomic, strong) NSString *electricityUp4;
@property (nonatomic, strong) NSString *electricityDown4;
@property (nonatomic, strong) NSString *open4;
@property (nonatomic, strong) NSString *controlStatusAuto4;

@end

NS_ASSUME_NONNULL_END
