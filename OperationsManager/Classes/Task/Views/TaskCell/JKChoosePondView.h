//
//  JKChoosePondView.h
//  OperationsManager
//
//  Created by    on 2018/8/14.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKChoosePondViewDelegate <NSObject>
- (void)showPondName:(NSString *)pondName withPondId:(NSString *)pondId;
@end

@interface JKChoosePondView : UIView
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *farmerName;
@property (nonatomic, weak) id<JKChoosePondViewDelegate> delegate;

@end
