//
//  JKAddDeviceCell.h
//  OperationsManager
//
//  Created by    on 2018/8/16.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKDeviceModel;

@protocol JKAddDeviceCellDelegate <NSObject>
- (void)deleteDevice:(NSInteger)no;
- (void)setDeviceInfo:(NSString *)deviceId withPondName:(NSString *)pondName withPondId:(NSString *)pondId withNo:(NSInteger)no withAutomic:(NSString *)automic;
- (void)checkDeviceInfoWithTskId:(NSString *)tskId;
@end

@interface JKAddDeviceCell : UITableViewCell

@property (nonatomic, strong) id<JKAddDeviceCellDelegate> delegate;
- (void)configCellWithModel:(JKDeviceModel *)model;

@end
