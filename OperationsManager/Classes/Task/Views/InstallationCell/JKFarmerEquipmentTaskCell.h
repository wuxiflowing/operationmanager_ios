//
//  JKFarmerEquipmentMainCell.h
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKDeviceModel;

NS_ASSUME_NONNULL_BEGIN
@protocol JKFarmerEquipmentMainCellDelegate <NSObject>
- (void)deleteDevice:(NSInteger)no;
- (void)setDeviceInfo:(NSString *)deviceId withPondName:(NSString *)pondName withPondId:(NSString *)pondId withNo:(NSInteger)no withType:(JKEquipmentType)equipmentType;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface JKFarmerEquipmentTaskCell : UITableViewCell

@property (nonatomic, weak) id<JKFarmerEquipmentMainCellDelegate> delegate;
- (void)configCellWithModel:(JKDeviceModel *)model;
@end

NS_ASSUME_NONNULL_END
