//
//  CSValidation.h
//  CSgameSDKDemo
//
//  Created by FreeGeek on 15/6/16.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSValidation : NSObject

/**
 *  @brief  检查用户名格式
 *  @param userName
 *  @return
 */
+(BOOL)CheckUserName:(NSString *)userName;

/**
 *  @brief  检查密码格式
 *  @param password
 *  @return
 */
+(BOOL)CheckPassword:(NSString *)password;

/**
 *  @brief  检查手机格式
 *  @param phoneNumber
 *  @return
 */
+(BOOL)CheckPhoneNumber:(NSString *)phoneNumber;

/**
 *  @brief  检查验证码格式
 *  @param verificationCode
 *  @return
 */
+(BOOL)CheckVerificationCode:(NSString *)verificationCode;

/**
 *  @brief  检查邮箱格式
 *  @param email
 *  @return
 */
+(BOOL)CheckEmail:(NSString *)email;

/**
 *  @brief  检查身份证格式
 *  @param idCard
 *  @return
 */
+(BOOL)CheckIdCard:(NSString *)idCard;

/**
 *  @brief  检查生日格式
 *  @param birthday
 *  @return
 */
+(BOOL)CheckBirthday:(NSString *)birthday;

/**
 *  @brief  检查版本信息
 *  @param serverVersion
 *  @return 
 */
+(BOOL)CheckVersion:(NSString *)serverVersion;

@end
