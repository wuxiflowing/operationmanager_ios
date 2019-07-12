//
//  JKSystemMessageCell.h
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKTaskMessageModel;
@interface JKSystemMessageCell : UITableViewCell
- (void)taskMessgeWithModel:(JKTaskMessageModel *)model;
@end
