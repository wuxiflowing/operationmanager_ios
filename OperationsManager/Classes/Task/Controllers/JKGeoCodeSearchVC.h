//
//  JKGeoCodeSearchVC.h
//  BusinessManager
//
//  Created by  on 2018/9/12.
//  Copyright © 2018年 . All rights reserved.
//

#import "JKBaseVC.h"

@protocol JKGeoCodeSearchVCDelegate <NSObject>
- (void)chooseAdddrInfo:(NSString *)info;
@end

@interface JKGeoCodeSearchVC : JKBaseVC
@property (nonatomic, weak) id<JKGeoCodeSearchVCDelegate> delegate;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@end
