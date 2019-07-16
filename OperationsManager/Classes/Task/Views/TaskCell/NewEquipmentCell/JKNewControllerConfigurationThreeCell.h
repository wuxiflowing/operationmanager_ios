//
//  JKNewControllerConfigurationThreeCell.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/16.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NewControllerConfigurationThreeCallback)(NSString *controlState);

@interface JKNewControllerConfigurationThreeCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSString *oxygenUpC;
@property (nonatomic, strong) NSString *oxygenDownC;
@property (nonatomic, strong) NSString *electricCurrentUpC;
@property (nonatomic, strong) NSString *electricCurrentDownC;

@property (copy, nonatomic)NewControllerConfigurationThreeCallback controlCallBack;
@end

NS_ASSUME_NONNULL_END
