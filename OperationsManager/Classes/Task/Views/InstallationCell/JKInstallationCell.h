//
//  JKInstallationCell.h
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskModel;

@protocol JKInstallationCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKInstallationCell : UITableViewCell
@property (nonatomic, weak) id<JKInstallationCellDelegate> delegate;
@property (nonatomic, assign) JKInstallation installType;
@property (nonatomic, strong) NSString *telStr;
@property (nonatomic, strong) NSString *addrStr;
- (void)createUI:(JKTaskModel *)model;
@end
