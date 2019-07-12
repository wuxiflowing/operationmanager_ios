//
//  JKChooseEquipmentChartView.h
//  OperationsManager
//
//  Created by    on 2018/9/19.
//  Copyright © 2018年   . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKChooseEquipmentChartViewDelegate <NSObject>
- (void)chooseChartTitle:(NSString *)title;
@end

@interface JKChooseEquipmentChartView : UIView
@property (nonatomic, weak) id<JKChooseEquipmentChartViewDelegate> delegate;
@end
