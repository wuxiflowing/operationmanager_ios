//
//  JKInstallationAddrModel.h
//  BusinessManager
//
//  Created by  on 2018/9/13.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKInstallationAddrModel : NSObject
@property (nonatomic, strong) NSString *addrStr;
@property (nonatomic, assign) CGFloat ptLat;
@property (nonatomic, assign) CGFloat ptLng;
@property (nonatomic, assign) BOOL isSelected;
@end
