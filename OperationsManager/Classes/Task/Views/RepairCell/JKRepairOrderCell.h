//
//  JKRepairOrderCell.h
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRepaireInfoModel;

@protocol JKRepairOrderCellDelegate <NSObject>
- (void)showOtherMap;
@end

@interface JKRepairOrderCell : UITableViewCell
@property (nonatomic, assign) JKRepaire repaireType;
@property (nonatomic, weak) id<JKRepairOrderCellDelegate> delegate;
@property (nonatomic, strong) UILabel *pondNameLb;
@property (nonatomic, strong) UILabel *pondAddrValueLb;
@property (nonatomic, strong) UILabel *operationPeopleLb;
@property (nonatomic, strong) UILabel *deviceTypeLb;
@property (nonatomic, strong) UILabel *faultDescriptionValueLb;
@property (nonatomic, strong) UILabel *pictureLb;
@property (nonatomic, strong) NSString *repaireImg;
@property (nonatomic, strong) UIView *bgView;
- (void)createUI:(JKRepaireInfoModel *)model;
@end
