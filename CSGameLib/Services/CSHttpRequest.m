//
//  CSHttpRequest.m
//  CSGameSDK
//
//  Created by FreeGeek on 15/5/27.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import "CSHttpRequest.h"
#import "CSAFNetworking.h"
#import "CSGameModel.h"
@implementation CSHttpRequest

+(CSAFHTTPSessionManager *)shared
{
    static CSAFHTTPSessionManager * manager;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [CSAFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15.0;   //网络超时时间
        manager.requestSerializer = [CSAFHTTPRequestSerializer serializer];
        manager.responseSerializer = [CSAFHTTPResponseSerializer serializer];
    });
    return manager;
}

+(void)RequestWithURL:(NSString *)url POSTbody:(NSMutableDictionary *)postDict APIName:(NSString *)apiName response:(void(^)(NSError * error,NSDictionary * resultDict))response
{
    

    
    if ([CSGameModel shared].isDebug)
    {
        if ([apiName isEqualToString:@"内购"])
        {
            NSMutableDictionary *neigoudict = [[NSMutableDictionary alloc]initWithDictionary:postDict];
            [neigoudict removeObjectForKey:@"data"];
             NSLog(@"发送数据%@：%@",apiName,neigoudict);
        }
        else
        {
             NSLog(@"发送数据%@：%@",apiName,postDict);
        }
       
    }

    [[self shared] GET:url parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSMutableDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (dictionary)
        {
             response(nil,dictionary);
        }
        else
        {
            response(nil,str);
        }
        if ([CSGameModel shared].isDebug)
        {
            if (dictionary)
            {
                NSLog(@"----- %@ ----- response : %@ ----- Error : %@",apiName,dictionary,nil);
            }
            else
            {
                NSLog(@"----- %@ ----- response : %@",apiName,str,nil);
            }
        }
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        response(error,nil);
        if ([CSGameModel shared].isDebug)
        {
             NSLog(@"----- %@ ----- Msg : %@ ----- Status : %@ ----- Error : %@",apiName,nil,nil,error);
        }
    }];
}


@end
