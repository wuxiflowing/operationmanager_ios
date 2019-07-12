//
//  Url.h
//  OperationsManager
//
//  Created by    on 2018/7/29.
//  Copyright © 2018年   . All rights reserved.
//

#ifndef Url_h
#define Url_h

// 测试
//#define kUrl_Base    @"http://apitest.celefish.com:8080"
//#define API_KEY @"c02fa8abe880869d950267c17e51a564"
//#define APP_KEY @"ae336f228c5aa5f126a071b68e535af2"

// 正式
#define kUrl_Base    @"http://api.celefish.com:8080"
#define API_KEY @"4521681f3976d526ff7ea73c0c48874a"
#define APP_KEY @"a6dd18bef08bae127f3663edc63742ab"

#define kGtAppId @"8zxWecsMlz6HVGmKqt29N6"
#define kGtAppKey @"rBJkrQ87lHA8WB8q2KTwg5"

#define kGtAppSecret @"kEtOeiOFLO9hMgxItwzTb9"
















// 暂时不用
//#define kGtAppId @"CplCU21isZ57bOEVqkjVm"
//#define kGtAppKey @"QABWlIGsJn7fa51guKJJo"
//#define kGtAppSecret @"TKPZYZ6hTh6mg6tvtG6Ko5"


#define kUrl_Login       [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/login"]
#define kUrl_ModifyPwd   [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/updatePW"]
#define kUrl_Banner      [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/getBanner"]
#define kUrl_AppCSM      [NSString stringWithFormat:@"%@%@",kUrl_Base,@"/RESTAdapter/app/createAppCSM"]

#endif /* Url_h */
