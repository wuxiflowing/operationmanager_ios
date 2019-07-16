//
//  JKNewControllerConfigurationfourCell.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/16.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NewControllerConfigurationFourCallback)(NSString *controlState);

@interface JKNewControllerConfigurationFourCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSString *oxygenUpD;
@property (nonatomic, strong) NSString *oxygenDownD;
@property (nonatomic, strong) NSString *electricCurrentUpD;
@property (nonatomic, strong) NSString *electricCurrentDownD;

@property (copy, nonatomic)NewControllerConfigurationFourCallback controlCallBack;
@end

NS_ASSUME_NONNULL_END
