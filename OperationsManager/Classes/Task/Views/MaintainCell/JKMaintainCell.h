//
//  JKMaintainCell.h
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskModel;

@protocol JKMaintainCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKMaintainCell : UITableViewCell
@property (nonatomic, weak) id<JKMaintainCellDelegate> delegate;
@property (nonatomic, assign) JKMaintain maintainType;
@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *addrStr;
- (void)createUI:(JKTaskModel *)model;
@end
