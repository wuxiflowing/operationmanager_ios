//
//  JKAlarmMessageCell.h
//  BusinessManager
//
//  Created by    on 2018/6/15.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskMessageModel;

@interface JKAlarmMessageCell : UITableViewCell
- (void)taskMessgeWithModel:(JKTaskMessageModel *)model;
@end
