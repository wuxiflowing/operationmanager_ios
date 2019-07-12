//
//  JKMaintainOrderCell.h
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKMaintainInfoModel;

@protocol JKMaintainOrderCellDelegate <NSObject>
- (void)showOtherMap;
@end

@interface JKMaintainOrderCell : UITableViewCell
@property (nonatomic, weak) id<JKMaintainOrderCellDelegate> delegate;
@property (nonatomic, assign) JKMaintain maintainType;
- (void)createUI:(JKMaintainInfoModel *)model;
@end
