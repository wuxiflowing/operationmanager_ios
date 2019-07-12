//
//  JKDeviceConfigurationCell.h
//  OperationsManager
//
//  Created by    on 2018/7/11.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKDeviceConfigurationCellDelegate <NSObject>
- (void)choosePond;
- (void)onlineCheckWithTskID:(NSString *)tskID;
- (void)getDeviceInfoWithTskID:(NSString *)tskID;
- (void)getDeviceControlState:(NSString *)state withTskID:(NSString *)tskID;
- (void)resetInstall:(NSString *)tskID;
- (void)scanDeviceId;
- (void)getPondId:(NSString *)pondId;
- (void)locationAddr;
@end

@interface JKDeviceConfigurationCell : UITableViewCell
@property (nonatomic, weak) id<JKDeviceConfigurationCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *pondName;
@property (nonatomic, strong) NSString *pondId;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *addrStr;
@property (nonatomic, assign) BOOL isFromRepairVC;
- (void)createUI;

@end
