//
//  JKTaskMessageModel.h
//  BusinessManager
//
//  Created by    on 2018/7/31.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKTaskMessageModel : NSObject
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *memId;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSString *msgContent;
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *receiverName;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *taskStatus;
@end
