//
//  TracingData.h
//
//  9377数据收集
//
//  Created by 9377-LieyanMobile on 15/8/11.
//  Copyright (c) 2015年 9377-LieyanMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameDeviceInfo.h"

#ifndef TDINSTANCE
#define TDINSTANCE  [TracingData shareInstance]
#endif

typedef enum : NSUInteger {
    TracingAccountUnknown = 0,  // 未知（默认）
    TracingAccountAnonymous,    // 匿名（保留）
    TracingAccountCS9377,       // 自有（9377）
    TracingAccountSinaWB,       // 新浪微博
    TracingAccountQQ,           // QQ号
    TracingAccountTXWB,         // 腾讯微博
}TracingAccountType;

typedef enum : NSUInteger {
    TracingPlatformApple = 1, // 平台：iOS正版
    TracingPlatformIOSYY = 2, // 平台：iOS越狱(默认)
}TracingPlatform;

@interface TracingData : NSObject

@property (nonatomic, copy) NSString* device_id;
@property (nonatomic, copy) NSString* product_slug;
@property (nonatomic, copy) NSString* model;
@property (nonatomic, copy) NSString* resolution;
@property (nonatomic, copy) NSString* os;
@property (nonatomic, copy) NSString* netCode;

@property (nonatomic, assign) int channel;
@property (nonatomic, assign) TracingPlatform platform; // 默认:iOS越狱

@property (nonatomic, assign) NetworkType   netType;

@property (nonatomic, assign, getter=isDebugLog) BOOL debugLog;

+ (instancetype)shareInstance;

- (void)getDeviceInfo;//:(NSString *)uuidKeyChain;

- (void)activateWithURL:(NSString *)url;

@end
