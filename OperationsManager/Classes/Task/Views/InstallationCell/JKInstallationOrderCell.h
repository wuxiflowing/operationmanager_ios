//
//  JKInstallationOrderCell.h
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKInstallInfoModel;

@protocol JKInstallationOrderCellDelegate <NSObject>
- (void)showOtherMap;
@end

@interface JKInstallationOrderCell : UITableViewCell
@property (nonatomic, weak) id<JKInstallationOrderCellDelegate> delegate;
@property (nonatomic, assign) JKInstallation installType;
@property (nonatomic, strong) UILabel *orderCountsLb;
@property (nonatomic, strong) UILabel *installAddrValueLb;
@property (nonatomic, strong) UILabel *operationPeopleLb;
@property (nonatomic, strong) UILabel *collectionServiceFeeLb;
@property (nonatomic, strong) UILabel *collectionDepositFeeLb;
@property (nonatomic, strong) UILabel *timeLb;
- (void)createUI:(JKInstallInfoModel *)model;
@end
