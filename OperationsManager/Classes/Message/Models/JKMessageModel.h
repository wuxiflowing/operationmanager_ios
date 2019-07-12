//
//  JKMessageModel.h
//  BusinessManager
//
//  Created by    on 2018/7/30.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKMessageModel : NSObject
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *msgContent;
@end
