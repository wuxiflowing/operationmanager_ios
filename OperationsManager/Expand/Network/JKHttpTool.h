//
//  JKHttpTool.h
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKHttpTool : NSObject
// 请求成功之后回调的 Block
typedef void(^SuccessBlock) (id responseObject);
// 请求失败之后回调的 Block
typedef void(^FailureBlock) (NSError *error);

@property (nonatomic, strong) UIWindow *window;

+ (JKHttpTool *)shareInstance;

- (AFHTTPSessionManager *)baseHttpRequest;

- (void)PostReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock;

- (void)PostPgyerReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock;

- (void)GetReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock;

- (void)PutReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock;

- (void)DeleteReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock;

@end
