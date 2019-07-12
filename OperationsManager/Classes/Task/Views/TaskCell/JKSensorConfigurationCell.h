//
//  JKSensorConfigurationCell.h
//  OperationsManager
//
//  Created by    on 2018/7/10.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JKSensorConfigurationCellDelegate <NSObject>
- (void)changeAutomatic:(BOOL)isAutomatic;
- (void)changeSensorConfigurationSetting:(NSMutableArray *)dataSource;
@end

@interface JKSensorConfigurationCell : UITableViewCell
@property (nonatomic, weak) id<JKSensorConfigurationCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *oxyLimitUpStr;
@property (nonatomic, strong) NSString *oxyLimitDownOneStr;
@property (nonatomic, strong) NSString *oxyLimitDownTwoStr;
@property (nonatomic, strong) NSString *alertlineOneStr;
@property (nonatomic, strong) NSString *alertlineTwoStr;
@property (nonatomic, assign) BOOL isAutomatic;
@end
