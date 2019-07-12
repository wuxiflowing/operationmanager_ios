//
//  JKHttpTool.m
//  OperationsManager
//
//  Created by    on 2018/6/13.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKHttpTool.h"

@implementation JKHttpTool

+ (JKHttpTool *)shareInstance{
    static JKHttpTool *instance= nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[JKHttpTool alloc]init];
    });
    return instance;
}

- (AFHTTPSessionManager *)baseHttpRequest{
    // 1.加密
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}

#pragma mark -- POST
- (void)PostReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"application/xml",@"text/xml", @"application/javascript", @"text/javascript", @"application/octet-stream", @"application/x-www-form-urlencoded",nil];
    
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:encodedUrl parameters:dictionary error:nil];
    [request setValue:@"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJmNCJ9.b5tLg9q3YQ0r8JCC0CvZlDJq9CtT0wCSS9IrPBFYwUOAY3XqpnGNYWscZKkI8AcVwKPBK6A7gUD4TNBnwEn4qw" forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(responseObject);
        } else {
            failureBlock(error);
        }
    }];
    [task resume];
}

#pragma mark -- POST
- (void)PostPgyerReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer  serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    [manager POST:url parameters:dictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    [manager.operationQueue cancelAllOperations];
}

#pragma mark -- Get
- (void)GetReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"application/xml",@"text/xml", @"application/javascript", @"text/javascript", @"application/octet-stream", @"application/x-www-form-urlencoded",nil];
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"Get" URLString:encodedUrl parameters:dictionary error:nil];
    [request setValue:@"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJmNCJ9.b5tLg9q3YQ0r8JCC0CvZlDJq9CtT0wCSS9IrPBFYwUOAY3XqpnGNYWscZKkI8AcVwKPBK6A7gUD4TNBnwEn4qw" forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(responseObject);
        } else {
            failureBlock(error);
        }
    }];
    [task resume];
}

#pragma mark -- Put
- (void)PutReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"application/xml",@"text/xml", @"application/javascript", @"text/javascript", @"application/octet-stream", @"application/x-www-form-urlencoded",nil];
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"Put" URLString:encodedUrl parameters:dictionary error:nil];
    [request setValue:@"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJmNCJ9.b5tLg9q3YQ0r8JCC0CvZlDJq9CtT0wCSS9IrPBFYwUOAY3XqpnGNYWscZKkI8AcVwKPBK6A7gUD4TNBnwEn4qw" forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(responseObject);
        } else {
            failureBlock(error);
        }
    }];
    [task resume];
}

#pragma mark -- Delete
- (void)DeleteReceiveInfo:(NSDictionary *)dictionary url:(NSString *)url successBlock:(SuccessBlock)successBlock withFailureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"application/xml",@"text/xml", @"application/javascript", @"text/javascript", @"application/octet-stream", @"application/x-www-form-urlencoded",nil];
    NSString *encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"Delete" URLString:encodedUrl parameters:dictionary error:nil];
    [request setValue:@"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJmNCJ9.b5tLg9q3YQ0r8JCC0CvZlDJq9CtT0wCSS9IrPBFYwUOAY3XqpnGNYWscZKkI8AcVwKPBK6A7gUD4TNBnwEn4qw" forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(responseObject);
        } else {
            failureBlock(error);
        }
    }];
    [task resume];
}


@end
