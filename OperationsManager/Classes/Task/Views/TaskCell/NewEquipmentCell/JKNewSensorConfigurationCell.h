//
//  JKNewSensorConfigurationCell.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/16.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JKNewSensorConfigurationCellDelegate <NSObject>
- (void)changeSensorConfigurationSetting:(NSMutableArray *)dataSource;
@end

@interface JKNewSensorConfigurationCell : UITableViewCell
@property (nonatomic, weak) id<JKNewSensorConfigurationCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *alertlineOneStr;
@property (nonatomic, strong) NSString *alertlineTwoStr;
@property (nonatomic, assign) NSInteger connectionType;
@property (nonatomic, copy) void(^matchingBlock)(NSInteger connectionType);
@property (nonatomic, copy) void(^deviceModeChangeBlock)(NSInteger onLine);
@end
NS_ASSUME_NONNULL_END
