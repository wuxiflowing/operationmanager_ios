//
//  JKControllerConfigurationOneCell.h
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKControllerConfigurationOneCell : UITableViewCell
@property (nonatomic, assign) BOOL isControllerOne;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *pondName;
@property (nonatomic, strong) NSString *hasAmmeterA;
@property (nonatomic, strong) NSString *ammeterTypeA;
@property (nonatomic, strong) NSString *powerA;
@property (nonatomic, strong) NSString *voltageUpA;
@property (nonatomic, strong) NSString *voltageDownA;
@property (nonatomic, strong) NSString *electricCurrentUpA;
@property (nonatomic, strong) NSString *electricCurrentDownA;
@property (nonatomic, strong) NSString *deviceType;
@end
