//
//  JKEquipmentControllerCell.h
//  OperationsManager
//
//  Created by    on 2018/7/20.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKEquipmentModel;
@interface JKEquipmentControllerCell : UITableViewCell
- (void)createUI:(JKEquipmentModel *)model;
@end
