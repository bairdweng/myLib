//
//  CSGameAPIService.h
//  CSgameSDKDemo
//
//  Created by FreeGeek on 15/6/16.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSAFNetworking.h"
#import "CSUrlModel.h"
#import <StoreKit/StoreKit.h>
typedef enum
{
    SERVER_TYPE_CS = 1,  //SCG服务区号
    SERVER_TYPE_DEV = 0  //开发商服务区号
}ServerType;

#pragma mark CSGameAPIService
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface CSGameAPIService : NSObject
/**
 *  @brief  激活SDK
 *  @param referer    <#referer description#>
 *  @param server     <#server description#>
 *  @param gameID     游戏简称
 *  @param serverType 服务区号
 */
+ (void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID serverType:(ServerType)serverType;
+ (void)accountlive;

/**
 *  @brief  设置平台
 *  @param platform
 */
+(void)setPlatform:(int)platform;

+(void)Docomment;
+(void)Endcomment;

/**
 *  @brief  设置服务区号
 *  @param server
 */
+(void)setServer:(NSString *)server;

/**
 *  @brief  设置调试模式
 *  @param isDebug YES:控制台打印数据  NO:控制台不打印数据
 */
+ (void)setDebug:(BOOL)isDebug;

@end

#pragma mark CSGameAuthorization
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface CSGameAuthorization :NSObject
/**
 *  @brief  获取客服公告
 */
+(void)GMLink;
/**
 *  @brief  评论
 *  @param 是否评论
 */
+(void)iscomment:(void(^)(BOOL iscomment))block;

/**
 *  @brief  公告
 */
+(void)gameNotifiy;

/**
 *  @brief  充值防炸模式
 *  @param isbang 是否开始web充值
 */
+(void)isBang:(void(^)(int isbang))block;
/**
 *  @brief  公告
 *  @param title 标题
 *  @param url 连接
 */
//+(void)GuangBoblock:(void(^)(NSString * title,NSString *url))block;
+(void)GuangBoblock:(void(^)(NSString *url))block;
/**
 *  @brief  是否显示浮标
 */
+(void)PointStatus;
/**
 *  @brief  注册
 *  @param userName 用户名
 *  @param password 密码
 *  @param delegate
 */
+ (void)connectionRegisterWithUserName:(NSString *)userName password:(NSString *)password delegate:(id)delegate;

/**
 *  @brief  登录
 *  @param userName 用户名
 *  @param password 密码
 *  @param delegate
 *  @param autoLogin 是否为自动登录
 */
+(void)connectionLoginWithUserName:(NSString *)userName password:(NSString *)password autoLogin:(BOOL)autoLogin block:(void(^)(NSString * userName,NSString *sessionID,NSString *timestamp,NSString *token))block;

/**
 *  @brief  登出
 *  @param delegate
 */
+(void)connectionLogoutWithBlock:(void(^)(BOOL state))block;

/**
 *  @brief  进入游戏服日志所需参数，游戏激活数据采集
 */
+(void)EnterData;

/**
 *  进入游戏服日志所需参数，游戏激活数据采集(用户名自传)
 *
 *  @param userName
 */
+(void)EnterDataUserName:(NSString *)userName;

/**
 *  @brief  登录校验
 *  @param sessionID 登录成功返回的sessionID
 *  @param delegate
 */
+(void)loginValidationWithSessionID:(NSString *)sessionId block:(void(^)(BOOL loginState))block;
@end


@protocol CSGameAuthorizationDelegate <NSObject>
@optional
/**
 *  @brief  注册成功回调方法
 */
- (void)registerSuccess;

/**
 *  @brief  注册失败回调方法
 */

- (void)registerFailure;


/**
 *  @brief  登录校验成功回调方法
 */
- (void)checkLoginSessionIDSuccess;

/**
 *  @brief  登录校验失败回调方法
 */
- (void)checkLoginSessionIDFailure;
@end

#pragma mark CSGameUserInfo
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface CSGameUserInfo : NSObject

/**
 *  @brief  获取当前登录用户的资料
 *  @param delegate
 */
+(void)connectionRequestUserInfo:(void (^)(NSDictionary * userinfo))userinfo;

@end

#pragma mark CSGameModifyUserInfo
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface CSGameModifyUserInfo :NSObject

/**
 *  @brief  修改密码
 *  @param password    新密码
 *  @param oldPassword 旧密码
 *  @param delegate
 */
+ (void)connectionModifyPasswordWithPassword:(NSString *)password oldPassword:(NSString *)oldPassword delegate:(id)delegate;

/**
 *  @brief  获取手机验证码 (绑定手机)
 *  @param phoneNumber 手机号码
 *  @param delegate
 */
+ (void)connectionSendVerificationCodeWithPhoneNumber:(NSString *)phoneNumber delegate:(id)delegate;

/**
 *  @brief  绑定手机
 *  @param phoneNumber      手机号码
 *  @param verificationCode 验证码
 *  @param delegate
 */
+ (void)connectionBindPhoneNumberWithPhoneNumber:(NSString *)phoneNumber verificationCode:(NSString *)verificationCode delegate:(id)delegate;

/**
 *  @brief  绑定邮箱
 *  @param email    邮箱地址
 *  @param delegate
 */
+ (void)connectionBindEmailWithEmailAddress:(NSString *)email delegate:(id)delegate;

/**
 *  @brief  获取手机验证码 (找回密码)
 *  @param phoneNumber 手机号码
 *  @param delegate
 */
+ (void)connectionRetrievePasswordSendVerificationCodeWithUserName:(NSString *)userName delegate:(id)delegate;

/**
 *  @brief  校验验证码有效性 (找回密码)
 *  @param verificationCode 验证码
 *  @param delegate
 */
+ (void)connectionCheckEffectivenessVerificationCode:(NSString *)verificationCode delegate:(id)delegate;

/**
 *  @brief  提交新密码 (找回密码)
 *  @param newPassword   新密码
 *  @param modifySuccess
 */
+ (void)connectionSubmitNewPasswordWithNewPassword:(NSString *)newPassword delegate:(id)delegate;

/**
 *  @brief  邮箱找回密码
 *  @param email    绑定的邮箱地址
 *  @param userName 用户名
 *  @param delegate 
 */
+ (void)connectionRetrievePasswordWithUserName:(NSString *)userName delegate:(id)delegate;
+(void)connectionRetrievePasswordWithUserName:(NSString *)userName  Email:(NSString *)mail delegate:(id)delegate;

+ (void)regisApnsToken:(NSString *)token successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback;


@end

@protocol CSGameModifyUserInfoDelegate <NSObject>
@optional
/**
 *  @brief  修改密码成功回调方法
 */
- (void)modifySuccess;

/**
 *  @brief  修改密码失败回调方法
 */
- (void)modifyFailure;

/**
 *  @brief  发送验证码成功回调方法
 */
- (void)sendVerificationCodeSuccess;

/**
 *  @brief  发送验证码失败回调方法
 */
- (void)sendVerificationCodeFailure;

/**
 *  @brief  绑定手机成功回调方法
 */
- (void)bindPhoneSuccess;

/**
 *  @brief  绑定手机失败回调方法
 */
- (void)bindPhoneFailure;

/**
 *  @brief  绑定邮箱成功
 */
- (void)bindEmailSuccess;

/**
 *  @brief  绑定邮箱失败
 */
- (void)bindEmailFailure;

/**
 *  @brief  校验验证码有效
 */
- (void)checkVerificationCodeSuccess;

/**
 *  @brief  校验验证码无效
 */
- (void)checkVerificationCodeFailure;

/**
 *  @brief  提交新密码成功
 */
- (void)submitPasswordSuccess;

/**
 *  @brief  提交新密码失败
 */
- (void)submitPasswordFailure;

/**
 *  @brief  邮箱找回密码成功
 */
- (void)retrievePasswordWithEmailSuccess;

/**
 *  @brief  邮箱找回密码失败
 */
- (void)retrievePasswordWithEmailFailure;
@end

#pragma mark CSGameInstallation
@interface CSGameInstallation : NSObject

/**
 *  @brief  获取游戏列表
 *  @param delegate <#delegate description#>
 */
+ (void)connectionGameListDelegate:(id)delegate;

@end

@protocol CSGameInstallationDelegate <NSObject>
@optional
/**
 *  @brief  获取游戏列表成功
 */
- (void)returnGameListSuccess;

/**
 *  @brief  获取游戏列表失败
 */
- (void)returnGameListFailure;

@end

#pragma mark CSGamePay
@interface CSGamePay : NSObject
+(void)connectionGameNotifiy;
+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo viewController:(UIViewController *)vc animated:(BOOL)animated disMissBlock:(void(^)())block;
+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo ObjectID:(NSString *)oid viewController:(UIViewController *)vc animated:(BOOL)animated block:(void(^)(BOOL state,NSString *error))block;
+(void)connectionGamePaymentWithPayTime:(NSString *)pay_time OrderID:(NSString*)order_id PayWay:(NSString*)pay_way PayMoney:(float)pay_money GameCoin:(float)game_coin PayIP:(NSString *)pay_ip block:(void(^)(BOOL state,NSString *error))block;
+(void)connectionGamePaymentWithPay:(NSString *)objectID ExtraInfo:(NSString *)extrainStr block:(void(^)(BOOL state,NSString *error))block;
+(void)purchaseProduct:(SKProduct *)product ExtraStr:(NSString *)extrastr block:(void(^)(BOOL state,NSString *error))block;
@end

@interface UIButton(csgameapiservice)
-(void)setBackgroundImageUrl:(NSString *)imageurl forState:(UIControlState)state;
@end
