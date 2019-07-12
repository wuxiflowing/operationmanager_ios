//
//  JKInstallationedResultCell.h
//  OperationsManager
//
//  Created by    on 2018/8/27.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKInstallInfoModel;
@interface JKInstallationedResultCell : UITableViewCell
@property (nonatomic, assign) BOOL hasPayServiceFree;
@property (nonatomic, assign) BOOL hasPayDepositFree;

- (void)getModel:(JKInstallInfoModel *)model;
@end
