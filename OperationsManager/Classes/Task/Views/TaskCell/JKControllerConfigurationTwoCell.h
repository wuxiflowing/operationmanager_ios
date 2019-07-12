//
//  JKControllerConfigurationTwoCell.h
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKControllerConfigurationTwoCell : UITableViewCell
@property (nonatomic, assign) BOOL isControllerTwo;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *hasAmmeterB;
@property (nonatomic, strong) NSString *pondName;
@property (nonatomic, strong) NSString *ammeterTypeB;
@property (nonatomic, strong) NSString *powerB;
@property (nonatomic, strong) NSString *voltageUpB;
@property (nonatomic, strong) NSString *voltageDownB;
@property (nonatomic, strong) NSString *electricCurrentUpB;
@property (nonatomic, strong) NSString *electricCurrentDownB;
@property (nonatomic, strong) NSString *deviceType;
@end
