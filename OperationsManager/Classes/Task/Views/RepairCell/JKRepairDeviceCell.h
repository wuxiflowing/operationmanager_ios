//
//  JKRepairDeviceCell.h
//  OperationsManager
//
//  Created by    on 2018/7/5.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRepairDeviceCellDelegate <NSObject>
- (void)addNewDevice;
- (void)deleteNewDevice;
- (void)showDeviceInfo:(NSString *)tskId;
- (void)configurationDeviceInfo:(NSString *)tskId;
@end

@interface JKRepairDeviceCell : UITableViewCell
@property (nonatomic, assign) JKRepaire repaireType;
@property (nonatomic, weak) id<JKRepairDeviceCellDelegate> delegate;
- (void)createUI:(NSString *)tskID withNewDevice:(BOOL)isNewDevice;

@end
