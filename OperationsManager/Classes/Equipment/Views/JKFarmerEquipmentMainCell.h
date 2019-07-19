//
//  JKFarmerEquipmentMainCell.h
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKPondChildDeviceModel;
@class JKPondModel;

NS_ASSUME_NONNULL_BEGIN
@protocol JKFarmerEquipmentMainCellDelegate <NSObject>
- (void)pushDeviceInfoVC:(JKPondChildDeviceModel *)dModel;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface JKFarmerEquipmentMainCell : UITableViewCell

@property (nonatomic, weak) id<JKFarmerEquipmentMainCellDelegate> delegate;
- (void)configCellWithModel:(JKPondChildDeviceModel *)model withPondModel:(JKPondModel *)pModel;

@end

NS_ASSUME_NONNULL_END
