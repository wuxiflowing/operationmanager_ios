//
//  JKDeviceControlInfo.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/18.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKDeviceControlInfo : NSObject
@property (nonatomic, assign) NSInteger controlId;
@property (nonatomic, assign) CGFloat oxyLimitUp;
@property (nonatomic, assign) CGFloat oxyLimitDown;
@property (nonatomic, assign) CGFloat electricityUp;
@property (nonatomic, assign) CGFloat electricityDown;
@property (nonatomic, assign) NSInteger open;
@property (nonatomic, assign) NSInteger isAuto;
@end

NS_ASSUME_NONNULL_END
