//
//  CSValidation.m
//  CSgameSDKDemo
//
//  Created by FreeGeek on 15/6/16.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import "CSValidation.h"
#import "CSProgressHUD.h"
#import "CSGameSDKpch.h"
@implementation CSValidation


+(BOOL)CheckUserName:(NSString *)userName
{
    if (userName)
    {
        //        return YES;
        
        if (userName.length >= 4)
        {
            return YES;
        }
        else
        {
            [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.AccountNotEnough", nil)];
            return NO;
        }
    }
    else
    {
        [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.AccountNotNull", nil)];
        return NO;
    }
}

+(BOOL)CheckPassword:(NSString *)password
{
    if (password)
    {
        //        return YES;
        if (password.length >= 4)
        {
            return YES;
        }
        else
        {
            [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.PasswordNotEnough", nil)];
            return NO;
        }
    }
    else
    {
        [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.PasswordNotNull", nil)];
        return NO;
    }
}

+(BOOL)CheckPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber)
    {
        NSString *phoneRegex = @"^1\\d{10}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        if ([phoneTest evaluateWithObject:phoneNumber])
        {
            return YES;
        }
        else
        {
            //            [CSProgressHUD showError:@"手机号码错误!"];
            return NO;
        }
    }
    else
    {
        //        [CSProgressHUD showError:@"手机号码不能为空~"];
        return NO;
    }
}

+(BOOL)CheckVerificationCode:(NSString *)verificationCode
{
    if (verificationCode)
    {
        if (verificationCode.length == 6)
        {
            return YES;
        }
        else
        {
            [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.CodeError", nil)];
            return NO;
        }
    }
    else
    {
        [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.CodeNotNull", nil)];
        return NO;
    }
}

+(BOOL)CheckEmail:(NSString *)email
{
    if (email)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:email])
        {
            return YES;
        }
        else
        {
            [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.EmailError", nil)];
            return NO;
        }
    }
    else
    {
        [CSProgressHUD showError:CSLocalizedStringForKey(@"SDK.HUD.EmailNotNull", nil)];
        return NO;
    }
}

+(BOOL)CheckIdCard:(NSString *)idCard
{
    if (idCard)
    {
        if (idCard.length <= 0)
        {
            //            [CSProgressHUD showError:@"身份证格式错误"];
            return NO;
        }
        NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([identityCardPredicate evaluateWithObject:idCard])
        {
            return YES;
        }
        else
        {
            //            [CSProgressHUD showError:@"身份证格式错误"];
            return NO;
        }
    }
    else
    {
        //        [CSProgressHUD showError:@"身份证不能为空~"];
        return NO;
    }
}

+(BOOL)CheckBirthday:(NSString *)birthday
{
    NSString *patternStr = @"^((((1[6-9]|[2-9]\\d)\\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\\d|3[01]))|(((1[6-9]|[2-9]\\d)\\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\\d|30))|(((1[6-9]|[2-9]\\d)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-8]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:birthday
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, birthday.length)];
    
    if (numberofMatch > 0)
    {
        return YES;
    }
    //    [CSProgressHUD showError:@"生日格式错误！eg:2015-05-25"];
    return NO;
}

+(BOOL)CheckVersion:(NSString *)serverVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if ([serverVersion isEqualToString:app_Version])
    {
        return YES;
    }
    
    return NO;
}
















@end
