//
//  HttpTool.m
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool
+ (NSURLSessionDataTask *)myOriRequestWithUrlStr:(NSString *)urlStr
                                         baseUrl:(NSString *)baseUrl
                                          method:(NSString *)methodStr
                                      parameters:(NSDictionary *)parameters
                               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:methodStr URLString:[NSString stringWithFormat:@"%@%@",baseUrl,urlStr] parameters:parameters error:nil];
    request.timeoutInterval = 10;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil  completionHandler:completionHandler];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionDataTask *)myRequestWithUrlStr:(NSString *)urlStr
                                      baseUrl:(NSString *)baseUrl
                                  isShowLogin:(BOOL)isShowLogin
                                       method:(NSString *)methodStr
                                   parameters:(NSDictionary *)parameters
                                      success:(void (^)(NSObject *resultObj))success
                                         fail:(void (^)(NSString *errorStr))fail
{
    return [HttpTool myOriRequestWithUrlStr:urlStr baseUrl:baseUrl method:methodStr parameters:parameters completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (error.code==-1001) {
                fail(@"请求超时");
                return;
            }
            DLog(@"urlStr error:%@",error.description);
            fail(@"网络异常");//网络链接问题或者请求地址有误
        } else {
            NSDictionary *dic = responseObject;
            if (dic&&[dic isKindOfClass:[NSDictionary class]]) {
                NSObject *codeStr = dic[@"code"];
                if ([codeStr isKindOfClass:[NSNull class]]) {
                    fail(@"请求失败");
                    return;
                }
                if ([dic[@"code"] intValue]==200) {
                    success(dic[@"result"]);
                    return;
                }else{
                    NSString *msg = dic[@"msg"];
                    if (msg&&[msg isKindOfClass:[NSString class]]) {
                        fail(msg);
                    }else{
                        fail(@"请求失败");//未返回错误信息
                    }
                }
            }else{
                fail(@"请求失败");//返回数据格式错误
            }
        }
        
    }];
}
@end
