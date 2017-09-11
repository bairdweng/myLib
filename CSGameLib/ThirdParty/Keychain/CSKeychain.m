//
//  CSKeychain.m
//  MoveButton
//
//  Created by FreeGeek on 15/6/2.
//  Copyright (c) 2015年 FreeGeek. All rights reserved.
//

#import "CSKeychain.h"
#import "CSSSKeychain.h"
#import <UIKit/UIKit.h>
#import "CSGTMBase64.h"
#import "CSSBJson4Parser.h"
#import "CSGameSDKpch.h"
#import "CSSFHFKeychainUtils.h"
@implementation CSKeychain
+(void)keycopy
{
     NSString *infos =  [CSSFHFKeychainUtils getPasswordForUsername:@"9377SDK_WWW"andServiceName:@"9377SDK" error:nil];
    NSString *wtf = [CSSFHFKeychainUtils getPasswordForUsername:@"wtf"andServiceName:@"9377SDK" error:nil];
//    if (!wtf)
//    {
        NSMutableArray *array = nil;
        if (infos)
        {
            array = [[NSMutableArray alloc]init];
            CSSBJson4ValueBlock block = ^(id v, BOOL *stop)
            {
//                if (*stop)
//                {
                    [array addObjectsFromArray:v];
                    
                    for (NSMutableDictionary *dict in array)
                    {
                        NSLog(@"%@",dict);
                        [self setAccount:[dict objectForKey:@"username"] password:[dict objectForKey:@"passworld"] forService:CSGame_KeyChainIdentifier];
                        [self setImageDataStringForAccount:[dict objectForKey:@"username"]];
                    }
                    [CSSFHFKeychainUtils storeUsername:@"wtf" andPassword:@"wtf" forServiceName:@"9377SDK" updateExisting:nil error:nil];
                    [CSSFHFKeychainUtils storeUsername:@"9377SDK_WWW" andPassword:@"" forServiceName:@"9377SDK" updateExisting:1 error:nil];
//                }
                
            };
            
            
            CSSBJson4Parser *parser = [CSSBJson4Parser multiRootParserWithBlock:block
                                                                   errorHandler:nil];
            [parser parse:[infos dataUsingEncoding:NSUTF8StringEncoding]];
            
//        }

    }
//    return array;
    
}


/**
 *  @brief  保存账号密码到Keychain
 *  @param account     账号
 *  @param password    密码
 *  @param serviceName 标识符(公司名)
 *  @return
 */
+(BOOL)setAccount:(NSString *)account password:(NSString *)password forService:(NSString *)serviceName
{
//    NSString * gameName;
//    if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] != nil)
//    {
//        gameName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    }
//    else
//    {
//        gameName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
//    }
    return [CSSSKeychain setPassword:password forService:serviceName labl:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]  account:account];
}

/**
 *  @brief  保存AppIcon
 *  @param serviceName 标识符
 *  @return
 */
+(BOOL)setImageDataStringForAccount:(NSString *)account
{
    return [CSSSKeychain setPassword:[self appIconData] forService:@"9377Icon" labl:@"" account:account];
}

+(NSString *)appIconData
{
    UIImage * icon = [UIImage imageNamed:@"icon"];
    NSString * imageData;
    NSData * data;
    if (!icon)
    {
        NSArray *iconfiles = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFiles"];
        if (iconfiles.count>0)
        {
            icon =  [UIImage imageNamed:[iconfiles objectAtIndex:0]];
        }
    }
    if (!icon)
    {
        if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFile"] != nil)
        {
             icon = [UIImage imageNamed:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFile"]];
        }
    }
    if (!icon)
    {
        icon = [UIImage imageNamed:@"CSSYGameSDK.bundle/welcomeIcon"];
    }
    if (icon)
    {
        if (UIImagePNGRepresentation(icon) == nil)
        {
            data = UIImageJPEGRepresentation(icon, 1);
        }
        else
        {
            data = UIImagePNGRepresentation(icon);
        }
        if (data)
        {
//            imageData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            data = [CSGTMBase64 encodeData:data];
            imageData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return imageData;
}

/**
 *  @brief  根据账号&标识符 删除账号信息
 *  @param account     账号
 *  @param serviceName 标识符(公司名)
 *  @return
 */
+(BOOL)deleteAccount:(NSString *)account forService:(NSString *)serviceName
{
    return [CSSSKeychain deletePasswordForService:serviceName account:account];
}

/**
 *  @brief  根据标识符和账号获取密码
 *  @param serviceName 标识符(公司名)
 *  @param account     账号
 *  @return
 */
+(NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account
{
    return [CSSSKeychain passwordForService:serviceName account:account];
}

/**
 *  @brief  根据标识符 获取所有账号
 *  @param serviceName 标识符(公司名)
 *  @return 所有账号数组
 */
+(NSArray *)accountsForService:(NSString *)serviceName
{
    NSArray * resultsArray = [CSSSKeychain accountsForService:serviceName];
    NSMutableArray * accountArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < resultsArray.count; i++)
    {
        [accountArray addObject:[[resultsArray objectAtIndex:i] objectForKey:@"acct"]];
    }
    return accountArray;
}

/**
 *  @brief  根据标识符获取所有密码
 *  @param serviceName 标识符
 *  @return 所有密码数组
 */
+(NSArray *)passwordForService:(NSString *)serviceName
{
    NSMutableArray * passArray = [[NSMutableArray alloc]init];
    NSArray * accountArray = [self accountsForService:serviceName];
    for (int i = 0; i < accountArray.count; i++)
    {
        [passArray addObject:[self passwordForService:serviceName account:[accountArray objectAtIndex:i]]];
    }
    return passArray;
}

/**
 *  @brief  根据标识符获取所有游戏名称
 *  @param serviceName 标识符
 *  @return
 */
+(NSArray *)lablForService:(NSString *)serviceName
{
    NSArray * AllArray = [self allAccounts];
    NSMutableArray * lablArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < AllArray.count; i++)
    {
        if ([[[AllArray objectAtIndex:i] objectForKey:@"svce"] isEqualToString:serviceName])
        {
            if ([[AllArray objectAtIndex:i] objectForKey:@"labl"])
            {
                [lablArray addObject:[[AllArray objectAtIndex:i] objectForKey:@"labl"]];
            }
            
        }
    }
    return lablArray;
}

/**
 *  @brief  获取keyChain中所有的账号信息
 *  @return
 */
+(NSArray *)allAccounts
{
    return [CSSSKeychain allAccounts];
}


@end
