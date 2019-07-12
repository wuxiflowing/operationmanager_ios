//
//  JKRepairResultCell.h
//  OperationsManager
//
//  Created by    on 2018/7/4.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKRepairResultCell : UITableViewCell
@property (nonatomic, assign) JKRepaire repaireType;

@property (nonatomic, strong) NSMutableArray *imageFixOrderArr;
@property (nonatomic, strong) NSMutableArray *imageReceiptArr;
@property (nonatomic, assign) BOOL chooseSingleTreatment;
@property (nonatomic, strong) NSMutableArray *selectResultArr;
@property (nonatomic, strong) NSMutableArray *selectContentArr;
@property (nonatomic, strong) UITextView *contentTV;
@property (nonatomic, strong) UITextView *resultTV;
@property (nonatomic, strong) UITextView *remarkTV;

- (void)createUI;
@end
