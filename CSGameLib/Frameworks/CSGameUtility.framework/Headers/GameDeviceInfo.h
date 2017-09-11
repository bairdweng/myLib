//
//  GameDeviceInfo.h
//
//  Created by 9377-LieyanMobile on 15/7/31.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    NetworkTypeDisconnet = 0,
    NetworkTypeWWAN,
    NetworkType2G,
    NetworkType3G,
    NetworkType4G,
    NetworkTypeWiFi,
    NetworkTypeUnknow = NetworkTypeDisconnet,
} NetworkType;

extern NSString* UUID_DEFAULT_KEY_CHAIN;

@interface GameDeviceInfo : NSObject

// 返回设备的IDFA
+(NSString *)IDFA;

// 返回设备的IDFV
+(NSString *)IDFV;

// 返回设备的UUID
+(NSString *)UUID;
// 重置设备的UUID（一般用于调试所需）
+(NSString *)ResetUUID;

// 返回设备号
+(NSString *)model;

// 返回OS字符串, 如：iPhone OS
+(NSString *)systemName;

// 返回OS版本
+(NSString *)systemVersion;

// 返回OS字符串和系统版本，如：iPhone OS(9.0)
+(NSString *)osName;

// 返回mcc
+(NSString *)mcc;
// 返回mnc
+(NSString *)mnc;
// 返回网络码(mcc+mnc)
+(NSString *)networkCode;

// 返回网络状态，返回值见NetworkType定义。
+(NetworkType)networkTypeWithHost:(NSString *)hostName;

// 返回设备分辨率
+(CGSize)resolution;
// 以字符串方式返回设备分辨率，如：320*400
+(NSString *)resolutionFormatted;

@end
