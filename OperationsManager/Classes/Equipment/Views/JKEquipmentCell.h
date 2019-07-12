//
//  JKEquipmentCell.h
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKPondChildDeviceModel;
@protocol JKEquipmentCellDelegate <NSObject>
- (void)equipmentInfoClick:(NSString *)deviceId;
@end

@interface JKEquipmentCell : UITableViewCell
@property (nonatomic, weak) id<JKEquipmentCellDelegate> delegate;
- (void)configCellWithModel:(JKPondChildDeviceModel *)model;
@end
