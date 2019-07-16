//
//  JKNewControllerConfigurationOneCell.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/16.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NewControllerConfigurationOneCallback)(NSString *controlState);

@interface JKNewControllerConfigurationOneCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSString *oxygenUpA;
@property (nonatomic, strong) NSString *oxygenDownA;
@property (nonatomic, strong) NSString *electricCurrentUpA;
@property (nonatomic, strong) NSString *electricCurrentDownA;

@property (copy, nonatomic)NewControllerConfigurationOneCallback controlCallBack;
@end

NS_ASSUME_NONNULL_END
