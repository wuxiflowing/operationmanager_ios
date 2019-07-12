//
//  JKTaskTopCell.h
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKTaskTopCellDelegate <NSObject>
- (void)callFarmerPhone:(NSString *)phoneNumber;
@end

@interface JKTaskTopCell : UITableViewCell
@property (nonatomic, weak) id<JKTaskTopCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *headImgV;
@property (nonatomic, strong) NSString *headImgStr;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addrLb;
@property (nonatomic, strong) NSString *telStr;

@end
