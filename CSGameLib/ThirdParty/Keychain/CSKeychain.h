//
//  CSKeychain.h
//  MoveButton
//
//  Created by FreeGeek on 15/6/2.
//  Copyright (c) 2015年 FreeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSKeychain : NSObject

+(void)keycopy;

/**
 *  @brief  保存账号密码到Keychain
 *  @param account     账号
 *  @param password    密码
 *  @param serviceName 标识符(公司名)
 *  @return
 */
+(BOOL)setAccount:(NSString *)account password:(NSString *)password forService:(NSString *)serviceName;

/**
 *  @brief  保存AppIcon
 *  @param serviceName 标识符
 *  @return
 */
+(BOOL)setImageDataStringForAccount:(NSString *)account;

//获取appIcon Data数据
+(NSString *)appIconData;

/**
 *  @brief  根据账号&标识符 删除账号信息
 *  @param account     账号
 *  @param serviceName 标识符(公司名)
 *  @return
 */
+(BOOL)deleteAccount:(NSString *)account forService:(NSString *)serviceName;

/**
 *  @brief  根据标识符和账号获取密码
 *  @param serviceName 标识符(公司名)
 *  @param account     账号
 *  @return
 */
+(NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account;

/**
 *  @brief  根据标识符 获取所有账号
 *  @param serviceName 标识符(公司名)
 *  @return 所有账号数组
 */
+(NSArray *)accountsForService:(NSString *)serviceName;

/**
 *  @brief  根据标识符获取所有密码
 *  @param serviceName 标识符
 *  @return 所有密码数组
 */
+(NSArray *)passwordForService:(NSString *)serviceName;

/**
 *  @brief  根据标识符获取所有游戏名称
 *  @param serviceName 标识符
 *  @return
 */
+(NSArray *)lablForService:(NSString *)serviceName;

/**
 *  @brief  获取keyChain中所有的账号信息
 *  @return
 */
+(NSArray *)allAccounts;




@end
