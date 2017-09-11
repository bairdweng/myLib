//
//  CSHttpRequest.h
//  CSGameSDK
//
//  Created by FreeGeek on 15/5/27.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CSHttpRequest : NSObject

/**
 *  @brief  HttpRequest
 *  @param url            url
 *  @param postDict    参数字典
 *  @param APIName  接口名称
 *  @param block        block
 */
+(void)RequestWithURL:(NSString *)url
                  POSTbody:(NSMutableDictionary *)postDict
                    APIName:(NSString *)apiName
                    response:(void(^)(NSError * error,NSDictionary * resultDict))response;
//手机助手统计
+(void)SjzsRequestWithURL:(NSString *)url
                        POSTbody:(NSMutableDictionary *)postDict
                          response:(void(^)(NSError * error,NSDictionary * resultDict))response;
@end
