//
//  JKRepairCell.h
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskModel;

@protocol JKRepairCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKRepairCell : UITableViewCell
@property (nonatomic, weak) id<JKRepairCellDelegate> delegate;
@property (nonatomic, assign) JKRepaire repaireType;
@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *addrStr;
- (void)createUI:(JKTaskModel *)model;
@end
