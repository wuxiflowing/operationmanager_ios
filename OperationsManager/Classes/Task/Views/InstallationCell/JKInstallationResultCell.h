//
//  JKResultCell.h
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKInstallationResultCell : UITableViewCell

@property (nonatomic, assign) JKInstallation installType;
@property (nonatomic, assign) BOOL isServiceFree;
@property (nonatomic, assign) BOOL isDepositFree;

@property (nonatomic, assign) BOOL isChooseServerRemit;
@property (nonatomic, assign) BOOL isChooseDepositRemit;

@property (nonatomic, strong) NSString *serverFreeStr;
@property (nonatomic, strong) NSString *serverRemarkStr;
@property (nonatomic, strong) NSString *depositFreeStr;
@property (nonatomic, strong) NSString *depositRemarkStr;

@property (nonatomic, strong) NSMutableArray *imageOrderArr;
@property (nonatomic, strong) NSMutableArray *imageServiceArr;
@property (nonatomic, strong) NSMutableArray *imageDepositArr;

@end
