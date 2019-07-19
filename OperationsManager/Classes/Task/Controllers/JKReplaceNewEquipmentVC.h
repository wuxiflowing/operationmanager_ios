//
//  JKReplaceNewEquipmentVC.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/16.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKBaseVC.h"
@class JKDeviceModel;
#import "JKContactModel.h"
@protocol JKReplaceNewEquipmentVCDelegate <NSObject>
- (void)newAddDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withPondAddr:(NSString *)pondAddr withLat:(CGFloat)lat withLng:(CGFloat)lng contactsModel:(JKContactsModel *)contactsModel;
- (void)newChangeDevice:(JKDeviceModel *)model withPondName:(NSString *)pondName withPondId:(NSString *)pondId withNo:(NSInteger)no contactsModel:(JKContactsModel *)contactsModel;
- (void)newReplaceDevice:(JKDeviceModel *)model withPondAddr:(NSString *)pondAddr withLat:(CGFloat)lat withLng:(CGFloat)lng contactsModel:(JKContactsModel *)contactsModel;
//- (void)
@end

@interface JKReplaceNewEquipmentVC : JKBaseVC
@property (nonatomic, weak) id<JKReplaceNewEquipmentVCDelegate> delegate;
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
