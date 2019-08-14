//
//  JKNewControllerConfigurationTwoCell.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/16.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NewControllerConfigurationTwoCallback)(NSString *controlState);

@interface JKNewControllerConfigurationTwoCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSString *oxygenUpB;
@property (nonatomic, strong) NSString *oxygenDownB;
@property (nonatomic, strong) NSString *electricCurrentUpB;
@property (nonatomic, strong) NSString *electricCurrentDownB;
@property (nonatomic, strong) NSString *open;
@property (copy, nonatomic)NewControllerConfigurationTwoCallback controlCallBack;
@end

NS_ASSUME_NONNULL_END
