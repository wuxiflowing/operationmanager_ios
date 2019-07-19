//
//  JKContactModel.h
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/18.
//  Copyright © 2019 周家康. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKContactModel : NSObject
@property (nonatomic, strong)NSString *linkManID;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *phoneNumber;
@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface JKContactsModel : NSObject
@property (nonatomic, strong)NSString *contacters;
@property (nonatomic, strong)NSString *contactPhone;
@property (nonatomic, strong)NSString *standbyContact;
@property (nonatomic, strong)NSString *standbyContactPhone;
@property (nonatomic, strong)NSString *nightContacters;
@property (nonatomic, strong)NSString *nightContactPhone;
@property (nonatomic, strong)NSString *standbynightContact;
@property (nonatomic, strong)NSString *standbynightContactPhone;
@end

NS_ASSUME_NONNULL_END
