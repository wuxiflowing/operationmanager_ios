//
//  JKMaintainResultCell.h
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKMaintainInfoModel;
@protocol JKMaintainResultCellDeleagte <NSObject>
- (void)getLocationLatAndLngAndTime;
@end

@interface JKMaintainResultCell : UITableViewCell
@property (nonatomic, weak) id<JKMaintainResultCellDeleagte> delegate;
@property (nonatomic, assign) JKMaintain maintainType;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UITextView *textV;
- (void)createUI:(JKMaintainInfoModel *)model;
@end
