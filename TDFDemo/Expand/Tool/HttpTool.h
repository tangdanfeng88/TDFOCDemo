//
//  HttpTool.h
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define POSTSTR @"POST"
#define GETSTR  @"GET"

#define BASE_URL        @"http://api.518yin.com/"

@interface HttpTool : NSObject
//直接调本地接口
+ (NSURLSessionDataTask *)myOriRequestWithUrlStr:(NSString *)urlStr
                                         baseUrl:(NSString *)baseUrl
                                          method:(NSString *)methodStr
                                      parameters:(NSDictionary *)parameters
                               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

// isShowLogin 表示如果登录过期是否去登录
+ (NSURLSessionDataTask *)myRequestWithUrlStr:(NSString *)urlStr
                                      baseUrl:(NSString *)baseUrl
                                  isShowLogin:(BOOL)isShowLogin
                                       method:(NSString *)methodStr
                                   parameters:(NSDictionary *)parameters
                                      success:(void (^)(NSObject *resultObj))success
                                         fail:(void (^)(NSString *errorStr))fail;
@end
