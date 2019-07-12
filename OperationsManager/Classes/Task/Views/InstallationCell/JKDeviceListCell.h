//
//  JKDeviceListCell.h
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKInstallInfoModel;

@protocol JKDeviceListCellDelegate <NSObject>
- (void)checkEquipmentInfo:(JKInstallInfoModel *)model withTag:(NSInteger)tag;
@end


@interface JKDeviceListCell : UITableViewCell
@property (nonatomic, weak) id<JKDeviceListCellDelegate> delegate;
@property (nonatomic, assign) JKInstallation type;

- (void)createUI:(JKInstallInfoModel *)model;

@end
