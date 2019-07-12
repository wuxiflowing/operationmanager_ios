//
//  JKRecyceResultCell.h
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKRecyceInfoModel;
@interface JKRecyceResultCell : UITableViewCell
@property (nonatomic, assign) JKRecyce recyceType;
@property (nonatomic, strong) NSMutableArray *imagePhotoArr;
@property (nonatomic, strong) NSMutableArray *imageOrderArr;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITextView *remarkTV;
@property (nonatomic, strong) UITextView *descriptionLbTV;
@property (nonatomic, assign) BOOL chooseSingle;
@property (nonatomic, strong) JKRecyceInfoModel *model;
@end
