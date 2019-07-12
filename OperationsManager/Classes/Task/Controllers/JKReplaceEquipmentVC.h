//
//  JKReplaceEquipmentVC.h
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKBaseVC.h"
@class JKDeviceModel;
@protocol JKReplaceEquipmentVCDelegate <NSObject>
- (void)addDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withPondAddr:(NSString *)pondAddr withLat:(CGFloat)lat withLng:(CGFloat)lng;
- (void)changeDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withNo:(NSInteger)no;
- (void)replaceDevice:(JKDeviceModel *)model withPondAddr:(NSString *)pondAddr withLat:(CGFloat)lat withLng:(CGFloat)lng;
//- (void)
@end

@interface JKReplaceEquipmentVC : JKBaseVC
@property (nonatomic, weak) id<JKReplaceEquipmentVCDelegate> delegate;
@property (nonatomic, assign) JKEquipmentInfoType type;
@property (nonatomic, strong) NSString *pondName;
@property (nonatomic, strong) NSString *pondId;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *farmerName;
@property (nonatomic, strong) NSString *automic;
@property (nonatomic, assign) BOOL isSet;
@property (nonatomic, assign) NSInteger no;
@property (nonatomic, assign) BOOL isFromRepairVC;
@end
 
