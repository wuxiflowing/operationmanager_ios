//
//  JKRecyceDeviceCell.h
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKRecyceDeviceCellDelegate <NSObject>
- (void)untiedDeviceWithIdent:(NSString *)ident withPondName:(NSString *)pondName withIsSelected:(NSInteger)isSelected withBtnTag:(NSInteger)tag;
@end


@interface JKRecyceDeviceCell : UITableViewCell
@property (nonatomic, weak) id<JKRecyceDeviceCellDelegate> delegate;
@property (nonatomic, assign) JKRecyce recyceType;
@property (nonatomic, strong) NSArray *dataSource;
@end
