//
//  CSGameAPIService.m
//  CSgameSDKDemo
//
//  Created by FreeGeek on 15/6/16.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import "CSGameAPIService.h"
#import "CSHttpRequest.h"
#import "CSGameModel.h"
#import "CSValidation.h"
#import "CSProgressHUD.h"
//#import "CSPayViewController.h"
#import "CSGameSDKpch.h"
#import "buoyButton.h"
#import "CSNavigationController.h"
#import "CSIAPManager.h"
//#import "NoticeViewController.h"
//#import "commentViewController.h"
//#import "TrackingIO.h"
//#import "SKStoreReviewController.h"
#import "CSSYGameSDK.h"
#import "GameDisPlayName.h"
#pragma mark CSGameAPIService
//------------------------------------------------------------------------------------------------------------------------------------------------------------
#define  NetworkErrorMSG  CSLocalizedStringForKey(@"SDK.HUD.Network", nil)

static NSTimer *deepTimer;
static NSTimer *commentTimer;

@implementation CSGameAPIService
+(void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID serverType:(ServerType)serverType
{
    
//    [CSKeychain keycopy];
    

    
//    NSMutableArray *array = [CSKeychain accountsForService:CSGame_KeyChainIdentifier];
//    if (!array||array.count == 0)
//    {
//        NSMutableDictionary *dictimei = [NSMutableDictionary new];
//        [dictimei setObject:[CSGameModel deviceImei] forKey:@"device_imei"];
//        [CSHttpRequest RequestWithURL:CSGame_URL_IMEI POSTbody:dictimei APIName:@"获取帐号" response:^(NSError *error, NSDictionary *resultDict)
//         {
//             
//             if (resultDict)
//             {
//                 NSString *username = [[NSString alloc]initWithFormat:@"%@",resultDict];
//                 if (username.length>0)
//                 {
//                     [CSKeychain setAccount:username password:[CSGameModel deviceImei]  forService:CSGame_KeyChainIdentifier];
//                     [CSKeychain setImageDataStringForAccount:username];
//                     //设置自动登录
//                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CSGame_AutoLogin];
//                 }
//             }
//
//         }];
//        
//    }
    [CSGameModel shared].gameReferer = referer;
    [CSGameModel shared].gameID = gameID;
    [CSGameModel shared].serverType = serverType;
    
    
    

}
+(void)accountlive
{
    if(![self IsActivation])
    {
        NSMutableDictionary * dict = [CSGameModel publicData];
        [dict setObject:@"device_data" forKey:@"do"];
        [CSHttpRequest RequestWithURL:@"https://wvw.9377.com/h5/api/tj.php" POSTbody:dict APIName:@"统计激活" response:^(NSError *error, NSDictionary *resultDict)
         {
             if (!error)
             {
                 if ([[resultDict objectForKey:@"ret"] intValue] == 0)
                 {
                     [self Activation];
                 }
                 
             }
             
         }];
    }
}

+(void)Endcomment
{
    NSString *isComment =  [[CSGameModel shared].commentDict objectForKey:@"ext6"];
    NSString *commentTimerStr = [[CSGameModel shared].commentDict objectForKey:@"ext1"];
    [CSGameModel comment:commentTimerStr];
//    if ([isComment isEqualToString:@"1"])
//    {
//        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.3) {
//            [SKStoreReviewController requestReview];
//            return;
//        }
//    }
    
    [CSGameModel shared].commentbackground = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowEndcomment) name:UIApplicationWillEnterForegroundNotification object:nil];
    NSString *url = [[CSGameModel shared].commentDict objectForKey:@"url"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    
}

+(void)ShowEndcomment
{
    if ([CSGameModel shared].commentbackground == 1)
    {
        [CSGameModel shared].commentbackground = 0;
        [CSProgressHUD showSuccess:@"感谢您的支持！"];
    }
}
+(void)Docomment
{
    
    
    if (commentTimer)
    {
        [commentTimer invalidate];
    }
    NSString *commentTimerStr = [[CSGameModel shared].commentDict objectForKey:@"ext2"];
    NSString *commentTimersec;
    if ([commentTimerStr rangeOfString:@":"].length == 0)
    {
        [commentTimer invalidate];
        commentTimersec = commentTimerStr;
    }
    else
    {
        NSArray *array = [commentTimerStr componentsSeparatedByString:@":"];
        if (array.count>[CSGameModel shared].commnetIndex)
        {
            commentTimersec = [array objectAtIndex:[CSGameModel shared].commnetIndex];
        }
        else
        {
            
            return;
        }
        
    }
    int sec;
    sec =  [commentTimersec intValue];
    if (sec >0)
    {
        commentTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:sec] interval:sec target:self selector:@selector(commentDisplay) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:commentTimer forMode:NSDefaultRunLoopMode];
        [CSGameModel shared].commnetIndex = [CSGameModel shared].commnetIndex+1;
    }
    
    
}

+(BOOL)IsActivation
{
    NSString *key = @"Activation";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:key] boolValue];
    
}
+(void)Activation
{
//    NSString *key = [NSString stringWithFormat:@"Activation%@%@",[CSGameModel shared].gameID,[CSGameModel shared].gamename];
    NSString *key = @"Activation";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:key];
    [userDefaults synchronize];
}
+(void)setPlatform:(int)platform
{
    [CSGameModel shared].platForm = platform;
}

+(void)setServer:(NSString *)server
{
    [CSGameModel shared].server = server;
}

+(void)setDebug:(BOOL)isDebug
{
    [CSGameModel shared].isDebug = isDebug;
}
@end

#pragma mark CSGameAuthorization
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface CSGameAuthorization()<CSGameAuthorizationDelegate,UIAlertViewDelegate>
@property (assign , nonatomic)id<CSGameAuthorizationDelegate>delegate;
@end

@implementation CSGameAuthorization

+(void)GMLink
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"game" forKey:@"page"];
    [dict setObject:[NSString stringWithFormat:@"sdk_domain%@",SDKDoMain] forKey:@"postfix"];
    [dict setObject:@"SDK客服URL" forKey:@"name"];
    [CSGameModel shared].server_GMLink = @"http://m.9377.cn/kefu";
    [CSHttpRequest RequestWithURL:@"https://wvw.9377.cn/api/data_json.php" POSTbody:dict APIName:@"获取客服连接" response:^(NSError *error, NSDictionary *resultDict) {
        if (!error)
        {

            if ([resultDict isKindOfClass:[NSArray class]])
            {
                NSMutableArray *rearray = [[NSMutableArray alloc]initWithArray:resultDict];
                [CSGameModel shared].server_GMLink = [rearray[0] objectForKey:@"url"];
            }

        }

    }];
    
//    [self performSelectorOnMainThread]
    
}

+(void)gameNotifiy
{
//    [CSGameModel shared].NotifiyShow = YES;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    //http://www.9377.cn/api/sdk.php?do=sdk_status&game_id=30001&version=22
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    http://wvw.9377.cn/api/data_json.php?page=game&postfix=sdk_notice&name=sdk%E5%88%86%E6%B8%B8%E6%88%8F%E5%85%AC%E5%91%8A
    [dict setObject:@"filter_data" forKey:@"do"];
    [dict setObject:@"sdk_notice" forKey:@"postfix"];
    [dict setObject:@"sdk分游戏公告" forKey:@"name"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"map[ext2]"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"map[ext5]"];
    [dict setObject:[CSGameModel shared].gameID forKey:@"map[thumb]"];
    [dict setObject:@"1" forKey:@"map[ext6]"];
    [dict setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"bundleidentifier"];
    [CSHttpRequest RequestWithURL:CSGame_URL_NewBase POSTbody:dict APIName:@"公告" response:^(NSError *error, NSDictionary *resultDict) {
        if (!error)
        {
            NSMutableArray *array = (NSMutableArray *)resultDict;
            NSMutableDictionary *nolNotifiyDict = nil;
            if ([array isKindOfClass:[NSArray class]]&&array.count >0)
            {
                NSMutableArray *ext6array = [[NSMutableArray alloc]init];
                for (int i =0 ; i< array.count; i++) {
                    NSMutableDictionary *fuckDict = [array objectAtIndex:i];
                    NSString *ext3str = [fuckDict objectForKey:@"ext3"];
//                    NSString *ext8str = [fuckDict objectForKey:@"ext8"];
                    int money = [ext3str intValue];
//                    [CSGameModel shared].UserMoney = 9999;
                    if (ext3str.length >0)
                    {
                        if ([CSGameModel shared].UserMoney-money>=0)
                        {
                            [ext6array addObject:fuckDict];
                            
                        }
                    }
                    else
                    {
                        nolNotifiyDict = fuckDict;
                    }
                    
                }
                
                for (int m = [ext6array count] - 1; m > 0; m--)
                {
                    NSMutableDictionary *mDict = [ext6array objectAtIndex:m];
                     for (int j =0; j< m; j++)
                     {
                         NSMutableDictionary *jDict = [ext6array objectAtIndex:j];
                         if([[mDict objectForKey:@"ext3"] intValue] < [[jDict objectForKey:@"ext3"] intValue])
                         {
                             [ext6array exchangeObjectAtIndex:m withObjectAtIndex:j];
                         }
                    }
                    
                }
                
                if (ext6array.count>0)
                {
                    NSMutableDictionary *fuckDict = [ext6array lastObject];
                    NSString *ext3str = [fuckDict objectForKey:@"ext3"];
                    NSString *ext8str = [fuckDict objectForKey:@"ext8"];
                    NSString *notfyver = [NSString stringWithFormat:@"%@%@%@",[CSGameModel shared].UserName,ext3str,ext8str];
                    if (![CSGameModel isInjoinNotify:notfyver])
                    {
                         [CSGameModel shared].NotifiyDict = nolNotifiyDict;
                    }
                    else
                    {
                        [CSGameModel shared].NotifiyDict = [ext6array lastObject];
                    }
                   
                }
                else
                {
                    [CSGameModel shared].NotifiyDict = nolNotifiyDict;
                }
                
                
                
                
//                NSMutableDictionary *fuckDict = [array objectAtIndex:0];
//                NSString *url = [fuckDict objectForKey:@"ext4"];
//                if(url.length>0)
//                {
//                    [CSGameModel shared].NotifiyUrl = url;
//                    [CSGameModel shared].NotifiyTitle = [fuckDict objectForKey:@"title"];
//                    [CSGameModel shared].NotifiyMsg = [fuckDict objectForKey:@"ext4"];
//                    [CSGameModel shared].NotifiyMode = [[fuckDict objectForKey:@"ext1"] intValue];
//                }
            }
        }
//                else
//                {
////                    [CSGameModel shared].NotifiyShow = NO;
//                    if ([CSGameModel shared].LoginShow)
//                    {
//                        [[CSGameModel shared].loginVC presentViewController:[CSGameModel shared].loginNVC animated:[CSGameModel shared].LoginAnimated completion:nil];
//                    }
//                }
//            }
//            else
//            {
////                [CSGameModel shared].NotifiyShow = NO;
////                if ([CSGameModel shared].LoginShow)
////                {
////                    [[CSGameModel shared].loginVC presentViewController:[CSGameModel shared].loginNVC animated:[CSGameModel shared].LoginAnimated completion:nil];
////                }
////            }
//            
//        }
//        else
//        {
////            [CSGameModel shared].NotifiyShow = NO;
//            if ([CSGameModel shared].LoginShow)
//            {
//                [[CSGameModel shared].loginVC presentViewController:[CSGameModel shared].loginNVC animated:[CSGameModel shared].LoginAnimated completion:nil];
//            }
//        }
        
    }];
}


//+(void)GuangBoblock:(void(^)(NSString * title,NSString *url))block
//{
//
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"filter_data" forKey:@"do"];
//    [dict setObject:@"游戏启动H" forKey:@"name"];
//    [dict setObject:@"click" forKey:@"postfix"];
//    [CSHttpRequest RequestWithURL:@"https://wvw.9377.com/h5/api/sdk.php" POSTbody:dict APIName:@"获取公告" response:^(NSError *error, NSDictionary *resultDict) {
//        if (!error)
//        {
//            NSMutableArray *array =(NSMutableArray *)resultDict;
//            if ([array isKindOfClass:[NSArray class]]&&array.count >0)
//            {
//                NSDictionary *dict = [array objectAtIndex:0];
//                block([dict objectForKey:@"title"],[dict objectForKey:@"ext4"]);
//            }
//            else
//            {
//                block(nil,nil);
//            }
//        }
//        else
//        {
//            block(nil,nil);
//        }
//        
//    }];
//    
//}

+(void)GuangBoblock:(void(^)(NSString *url))block
{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"filter_data" forKey:@"do"];
    [dict setObject:@"游戏启动H" forKey:@"name"];
    [dict setObject:@"click" forKey:@"postfix"];
    [dict setObject:[GameDisPlayName getDisPlayName] forKey:@"map[title]"];
    NSString *url = @"https://wvw.9377.com/h5/api/sdk.php";
    if ([CSGameModel shared].loadcount==0) {
        [CSProgressHUD show:@"努力加载中..."];
    }
    [CSGameModel shared].loadcount++;
    [CSHttpRequest RequestWithURL:url
                         POSTbody:dict
                          APIName:@""
                         response:^(NSError* error, NSDictionary* resultDict) {
                             [CSProgressHUD dismiss];
                             if (!error) {
                                 NSMutableArray* array = (NSMutableArray*)resultDict;
                                 if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                                     NSDictionary* dict = [array objectAtIndex:0];
                                     NSString* gameid = [dict objectForKey:@"ext1"];
                                     if (gameid.length > 0) {
                                         [CSGameActivation connectionSDK:@"" gameID:gameid gameName:@"" statisticsKey:nil];
                                         [CSGameActivation setServer:@"1"];
                                         [CSGameAPIService accountlive];
                                     }
                                     block([dict objectForKey:@"ext4"]);
                                 } else {
                                     block(nil);
                                 }
                             } else {
                                 block(nil);
                             }

                         }];
}

+(void)iscomment:(void(^)(BOOL iscomment))block
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    //http://www.9377.cn/api/sdk.php?do=sdk_status&game_id=30001&version=22
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [dict setObject:@"get_data" forKey:@"do"];
    [dict setObject:@"sdk评论" forKey:@"name"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"version"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"appversion"];
    [dict setObject:[CSGameModel shared].gameID forKey:@"game"];
    
//    [dict setObject:@"游戏id" forKey:@"version"];
//    [dict setObject:@"游戏id" forKey:@"game"];
    [dict setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"bundleidentifier"];
    [CSHttpRequest RequestWithURL:CSGame_URL_NewBase POSTbody:dict APIName:@"sdk评论" response:^(NSError *error, NSDictionary *resultDict) {
        
        if (!error)
        {
            NSMutableArray *array = (NSMutableArray *)resultDict;
            if ([resultDict isKindOfClass:[NSDictionary class]])
            {
//                NSMutableDictionary *fuckDict = [array objectAtIndex:0];
                if ([resultDict isKindOfClass:[NSDictionary class]])
                {
                    [CSGameModel shared].commentDict = [[NSMutableDictionary alloc]initWithDictionary:resultDict];
                    [CSGameModel shared].commnetIndex = 0;
                    if ([CSGameModel shared].commentDict)
                    {
                        NSString *url = [[CSGameModel shared].commentDict objectForKey:@"url"];
                        NSString * ext1 = [[CSGameModel shared].commentDict objectForKey:@"ext1"];
                        if (url.length >0)
                        {
                            
                                if ([CSGameModel iscomment:ext1])
                                {
                                    block(YES);
                                }
                                else
                                {
                                    block(NO);
                                }
                            
                        }
                        else
                        {
                            block(NO);
                        }
                        
                    }
                    else
                    {
                        block(NO);
                    }
                    
                }
                else
                {
                    block(NO);
                }
                
            }
            if ([array isKindOfClass:[NSArray class]])
            {
                NSMutableDictionary *fuckDict = [array objectAtIndex:0];
                if ([fuckDict isKindOfClass:[NSDictionary class]])
                {
                    [CSGameModel shared].commentDict = [[NSMutableDictionary alloc]initWithDictionary:fuckDict];
                    [CSGameModel shared].commnetIndex = 0;
                    if ([CSGameModel shared].commentDict)
                    {
                        NSString *url = [[CSGameModel shared].commentDict objectForKey:@"url"];
                        NSString * ext1 = [[CSGameModel shared].commentDict objectForKey:@"ext1"];
                        if (url.length >0)
                        {
                            
                            if ([CSGameModel iscomment:ext1])
                            {
                                block(YES);
                            }
                            else
                            {
                                block(NO);
                            }
                            
                        }
                        else
                        {
                            block(NO);
                        }
                        
                    }
                    else
                    {
                        block(NO);
                    }
                    
                }
                else
                {
                    block(NO);
                }

            }
        }
        else
        {
            block(NO);
        }
        
    }];
}



+(void)isBang:(void(^)(int isbang))block
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    //http://www.9377.cn/api/sdk.php?do=sdk_status&game_id=30001&version=22
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [dict setObject:@"apple_pay" forKey:@"do"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"version"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"appversion"];
    [dict setObject:[CSGameModel shared].gameID forKey:@"game_id"];
    [dict setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"bundleidentifier"];
    [CSHttpRequest RequestWithURL:CSGame_URL_NewBase POSTbody:dict APIName:@"防炸模式" response:^(NSError *error, NSDictionary *resultDict) {
        if (resultDict)
        {
            int status = [[resultDict objectForKey:@"status"] intValue];
            block(status);
        }
        else
        {
            block(0);
        }
        
    }];
}
+(void)PointStatus
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    //http://www.9377.cn/api/sdk.php?do=sdk_status&game_id=30001&version=22
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [dict setObject:@"filter_data" forKey:@"do"];
    [dict setObject:@"sdk_icon" forKey:@"postfix"];
    [dict setObject:@"sdk分游戏浮标" forKey:@"name"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"map[ext2]"];
    [dict setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"map[ext5]"];
    [dict setObject:[CSGameModel shared].gameID forKey:@"map[thumb]"];
    [dict setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"bundleidentifier"];
    [CSHttpRequest RequestWithURL:CSGame_URL_NewBase POSTbody:dict APIName:@"获取浮标开关" response:^(NSError *error, NSDictionary *resultDict) {
        if (resultDict)
        {
            NSMutableArray *array = (NSMutableArray *)resultDict;
            if ([array isKindOfClass:[NSArray class]]&&array.count >0)
            {
                
                NSMutableDictionary *dict = [array objectAtIndex:0];
                int status = [[dict objectForKey:@"ext6"] intValue];
                
                if ([CSGameModel shared].isShowGM)
                {
                    [CSGameModel shared].PointDict = dict;
                }
                
                if (status == 1)
                {
                    
                    [buoyButton defaultFloatViewWithButton].DragButtonHidden = NO;
                    [buoyButton setDragButtonHidden:NO];
                    if ([CSGameModel isShowPoCM])
                    {
                        [buoyButton Touch];
                    }
                }
                else
                {
                    [buoyButton defaultFloatViewWithButton].DragButtonHidden = YES;
                    [buoyButton setDragButtonHidden:YES];
                }
                
            }
            else
            {
                [buoyButton defaultFloatViewWithButton].DragButtonHidden = YES;
                [buoyButton setDragButtonHidden:YES];
            }
        }
        else
        {
            [buoyButton defaultFloatViewWithButton].DragButtonHidden = YES;
            [buoyButton setDragButtonHidden:YES];
        }
        
    }];
    
}
//注册

+ (void)connectionRegisterWithUserName:(NSString *)userName password:(NSString *)password delegate:(id)delegate
{
    [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.register", nil)];
    CSGameAuthorization * Authorization = [[CSGameAuthorization alloc]init];
    Authorization.delegate = delegate;
    NSMutableDictionary * dict = [CSGameModel publicData];
    [dict setObject:@"1" forKey:@"return_json"];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
    [CSValidation CheckUserName:userName];
    [CSValidation CheckPassword:password];
    if ([CSValidation CheckUserName:userName])
    {
        if ([CSValidation CheckPassword:password])
        {
            [CSHttpRequest RequestWithURL:CSGame_URL_Register  POSTbody:dict APIName:@"注册" response:^(NSError *error, NSDictionary *resultDict) {
                if (resultDict)
                {
                    if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CSGame_Account_RegisSuccess" object:userName];
                        if ([CSGameModel shared].deepActivationSec > 0)
                        {
                            deepTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:[CSGameModel shared].deepActivationSec] interval:[CSGameModel shared].deepActivationSec target:self selector:@selector(onlinetime) userInfo:nil repeats:NO];
                            [[NSRunLoop currentRunLoop] addTimer:deepTimer forMode:NSDefaultRunLoopMode];
                            [CSGameModel shared].deepActivationUserName = userName;
//                            [TrackingIO setRegisterWithAccountID:userName];
                        }
                        
                            [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                            if ([Authorization.delegate respondsToSelector:@selector(registerSuccess)])
                            {
                                [Authorization.delegate registerSuccess];
                            }
                    }
                    else
                    {
                        [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                        if ([Authorization.delegate respondsToSelector:@selector(registerFailure)])
                        {
                            [Authorization.delegate registerFailure];
                        }
                    }
                }
                else
                {
                    [Authorization.delegate registerFailure];
                    [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
                }
            }];
        }
    }
}

+(void)onlinetime
{
    NSMutableDictionary * dict = [CSGameModel publicData];
    [dict setObject:@"online_data" forKey:@"do"];
    [dict setObject:[CSGameModel shared].deepActivationUserName forKey:@"username"];
    [CSHttpRequest RequestWithURL:CSGame_URL_Statistical POSTbody:dict APIName:@"深度激活" response:^(NSError *error, NSDictionary *resultDict) {
    }];
}

//登录
+(void)connectionLoginWithUserName:(NSString *)userName password:(NSString *)password autoLogin:(BOOL)autoLogin block:(void(^)(NSString * userName,NSString *sessionID,NSString *timestamp,NSString *token))block
{
    NSMutableDictionary * dict = [CSGameModel publicData];
    [dict setObject:@"1" forKey:@"return_json"];
    [dict setObject:userName forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
    [CSValidation CheckUserName:userName];
    [CSValidation CheckPassword:password];
    if (![[CSGameModel shared].deepActivationUserName isEqualToString:userName])
    {
        [deepTimer invalidate];
    }
//    if ([CSValidation CheckUserName:userName])
//    {
//        if ([CSValidation CheckPassword:password])
//        {
    if (autoLogin)
    {
        [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.autoLogin", nil)];
    }
    else
    {
        [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.Login", nil)];
    }
            [CSHttpRequest RequestWithURL:CSGame_URL_Login POSTbody:dict APIName:@"登录" response:^(NSError *error, NSDictionary *resultDict) {
                if (resultDict)
                {
                    if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                    {
                        NSMutableString * sessionID = [resultDict objectForKey:@"session_id"];
                        [CSGameModel shared].server_timestamp = [resultDict objectForKey:@"timestamp"];
                        [CSGameModel shared].server_token = [resultDict objectForKey:@"token"];
                        [CSGameModel shared].UserMoney = [[resultDict objectForKey:@"money"] intValue];
                        [CSGameModel shared].isShowGM = NO;
                        [CSGameAuthorization gameNotifiy];
                        if ([[resultDict objectForKey:@"show_gm"] boolValue]) {
                            [CSGameModel shared].isShowGM = YES;
                            [self GMLink];
                        }
                        
                        NSString * userName = [[sessionID componentsSeparatedByString:@"|"] objectAtIndex:1];
//                        [TrackingIO setLoginWithAccountID:userName];
                        [CSGameModel shared].sessionID = sessionID;
                        if(![CSGameAPIService IsActivation])
                        {
                            NSMutableDictionary * dict = [CSGameModel publicData];
                            [dict setObject:@"device_data" forKey:@"do"];
                            [CSHttpRequest RequestWithURL:CSGame_URL_Statistical POSTbody:dict APIName:@"统计激活" response:^(NSError *error, NSDictionary *resultDict)
                             {
                                 if (!error)
                                 {
                                     [CSGameAPIService Activation];
                                 }
                                 
                             }];
                        }

                        block(userName,sessionID,[CSGameModel shared].server_timestamp,[CSGameModel shared].server_token);
                    }
                    else
                    {
                       
                        [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                        
                        block(nil,nil,nil,nil);
                    }
                }
                else
                {
                    [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
                    block(nil,nil,nil,nil);
                }
            }];
}


+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9999) {
        switch (buttonIndex) {
            case 1:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:020-37039849"]];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 1:   //找回密码
            {
                
            }
                break;
            case 2:  //联系客服
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"联系客服" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"热线:020-37039849",@"Q Q:2850907511", nil];
                alert.tag = 9999;
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
}


//注销
+(void)connectionLogoutWithBlock:(void(^)(BOOL state))block
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"logout" forKey:@"do"];
    [dict setObject:@"1" forKey:@"return_json"];
    [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
    [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.Logout", nil)];
    if (commentTimer)
    {
        [commentTimer invalidate];
    }
    [CSHttpRequest RequestWithURL:CSGame_URL_Logout POSTbody:dict APIName:@"注销" response:^(NSError *error, NSDictionary *resultDict) {
        if (resultDict)
        {
            if ([[resultDict objectForKey:@"status"] intValue] >= 0)
            {
                [buoyButton reMoveTouch];
                [[NSUserDefaults standardUserDefaults] setObject:NO forKey:CSGame_AutoLogin];
                [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                [CSGameModel shared].UserName = nil;
                [CSGameModel shared].sessionID = nil;
                block(YES);
            }
            else
            {
                [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                block(NO);
            }
        }
        else
        {
            [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
            block(NO);
        }
    }];
}

//登录校验
+ (void)checkLoginSessionIDWithSessionID:(NSString *)sessionID gameName:(NSString *)gameName key:(NSString *)key delegate:(id)delegate
{
    
    NSString * timestamp = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
    NSString * sessionid = [NSString stringWithFormat:@"%@",[CSGameModel shared].sessionID];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:sessionid forKey:@"session_id"];
    [dict setObject:gameName forKey:@"game"];
    [dict setObject:@"pengyangyang" forKey:@"username"];
    [dict setObject:timestamp forKey:@"timestamp"];
    [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
    [dict setObject:[CSGameModel md5:[NSString stringWithFormat:@"%@%@%@%@%@",@"pengyangyang",gameName,[CSGameModel shared].server,timestamp,key]] forKey:@"sign"];
    if ([CSGameModel shared].server) //SCG游戏服务区号
    {
        [dict setObject:[CSGameModel shared].server forKey:@"sid"];
    }
    else
    {
        [dict setObject:[CSGameModel shared].server forKey:@"_sid"];
    }
}

+(void)EnterData
{
    NSString * userName =  [CSGameModel shared].UserName;
    if (userName.length > 0)
    {
        NSString * server = [CSGameModel shared].server;
        NSMutableDictionary * dict = [CSGameModel publicData];
        [dict setObject:@"1" forKey:@"return_json"];
        [dict setObject:@"enter_data" forKey:@"do"];
        [dict setObject:userName forKey:@"username"];
        [dict setObject:server forKey:@"server"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
        [CSHttpRequest RequestWithURL:CSGame_URL_Statistical POSTbody:dict APIName:@"进入游戏" response:^(NSError *error, NSDictionary *resultDict) {
        }];
    }
    else
    {
        if ([CSGameModel shared].isDebug)
        {
            NSLog(@"----- 进入游戏 ----- 未登录");
        }
    }
}

+(void)EnterDataUserName:(NSString *)userName
{
    if (userName.length > 0)
    {
        NSString * server = [CSGameModel shared].server;
        NSMutableDictionary * dict = [CSGameModel publicData];
        [dict setObject:@"1" forKey:@"return_json"];
        [dict setObject:@"enter_data" forKey:@"do"];
        [dict setObject:userName forKey:@"username"];
        [dict setObject:server forKey:@"server"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
        [CSHttpRequest RequestWithURL:CSGame_URL_Statistical POSTbody:dict APIName:@"进入游戏" response:^(NSError *error, NSDictionary *resultDict) {
        }];
    }else{
        if ([CSGameModel shared].isDebug)
        {
            NSLog(@"----- 进入游戏 ----- 未登录");
        }
    }
}


+(void)loginValidationWithSessionID:(NSString *)sessionId block:(void(^)(BOOL loginState))block
{
    if (sessionId)
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:sessionId forKey:@"session_id"];
        [CSHttpRequest RequestWithURL:CSGame_URL_Enter POSTbody:dict APIName:@"登录验证" response:^(NSError *error, NSDictionary *resultDict)
         {
             if (resultDict)
             {
                 if ([CSGameModel shared].UserName)
                 {
                     if ([resultDict[@"LOGIN_ACCOUNT"] isEqualToString:[CSGameModel shared].UserName])
                     {
                         block(YES);
                     }
                     else
                     {
                         block(NO);
                     }
                 }
             }
            else
            {
                block(NO);
            }
        }];
    }
    else
    {
        block(NO);
        if ([CSGameModel shared].isDebug)
        {
            NSLog(@"--------- 登录验证 ---------SessionID无效");
        }
    }
}

@end
#pragma mark CSGameUserInfo
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation CSGameUserInfo

//获取用户信息
+(void)connectionRequestUserInfo:(void (^)(NSDictionary * userinfo))userinfo
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"return_json"];
    [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
    [CSHttpRequest RequestWithURL:CSGame_URL_UserInfo POSTbody:dict APIName:@"获取用户信息" response:^(NSError *error, NSDictionary *resultDict) {
    if (resultDict)
    {
        userinfo(resultDict);
        [CSGameAuthorization iscomment:^(BOOL iscomment) {
            if (iscomment)
            {
                [CSGameAPIService Docomment];
                
            }
            else
            {
                if ([CSGameModel shared].NotifiyDict)
                {
                    [CSGamePay connectionGameNotifiy];
                }
            }
        }];
    }
    else
    {
        [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
    }
    }];
}
@end


#pragma mark CSGameModifyUserInfo
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface CSGameModifyUserInfo()<CSGameModifyUserInfoDelegate>
@property (assign , nonatomic)id<CSGameModifyUserInfoDelegate>delegate;
@end
@implementation CSGameModifyUserInfo

//修改密码
+(void)connectionModifyPasswordWithPassword:(NSString *)password oldPassword:(NSString *)oldPassword delegate:(id)delegate
{
    CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
    modifyUserInfo.delegate = delegate;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"pwd_up" forKey:@"do"];
    [dict setObject:password forKey:@"password1"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:oldPassword forKey:@"password_old"];
    [dict setObject:[CSGameModel shared].sessionID forKey:@"session_id"];
    [dict setObject:[CSGameModel deviceImei] forKey:@"device_imei"];
    [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
//    if ([CSValidation CheckPassword:password])
//    {
//        if ([CSValidation CheckPassword:oldPassword])
//        {
            [CSHttpRequest RequestWithURL:CSGame_URL_ChangePassword POSTbody:dict APIName:@"修改密码" response:^(NSError *error, NSDictionary *resultDict) {
                if (resultDict)
                {
                    if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                    {
                        [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                        if ([modifyUserInfo.delegate respondsToSelector:@selector(modifySuccess)])
                        {
                            [modifyUserInfo.delegate modifySuccess];
                        }
                    }
                    else
                    {
                        [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                        if ([modifyUserInfo.delegate respondsToSelector:@selector(modifyFailure)])
                        {
                             [modifyUserInfo.delegate modifyFailure];
                        }
                    }
                }
                else
                {
                    [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
                }
            }];
//        }
//    }
}

//发送验证码
+(void)connectionSendVerificationCodeWithPhoneNumber:(NSString *)phoneNumber delegate:(id)delegate
{
    if ([CSValidation CheckPhoneNumber:phoneNumber])
    {
        CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
        modifyUserInfo.delegate = delegate;
        [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.request", nil)];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"bind_cellphone" forKey:@"do"];
        [dict setObject:@"1" forKey:@"step"];
        [dict setObject:phoneNumber forKey:@"cellphone"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
         [dict setObject:@"1" forKey:@"no_code"];
        [CSHttpRequest RequestWithURL:CSGame_URL_BindPhone POSTbody:dict APIName:@"发送验证码" response:^(NSError *error, NSDictionary *resultDict) {
            if (resultDict)
            {
                if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                {
                    [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(sendVerificationCodeSuccess)])
                    {
                        [modifyUserInfo.delegate sendVerificationCodeSuccess];
                    }
                }
                else
                {
                    [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(sendVerificationCodeFailure)])
                    {
                        [modifyUserInfo.delegate sendVerificationCodeFailure];
                    }
                }
            }
            else
            {
                [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
             }
        }];
    }
}

//绑定手机
+(void)connectionBindPhoneNumberWithPhoneNumber:(NSString *)phoneNumber verificationCode:(NSString *)verificationCode delegate:(id)delegate
{
    if ([CSValidation CheckPhoneNumber:phoneNumber])
    {
        if ([CSValidation CheckVerificationCode:verificationCode])
        {
            CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
            modifyUserInfo.delegate = delegate;
            [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.validation", nil)];
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:@"bind_cellphone" forKey:@"do"];
            [dict setObject:@"2" forKey:@"step"];
            [dict setObject:phoneNumber forKey:@"cellphone"];
            [dict setObject:verificationCode forKey:@"captcha"];
            [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
            [CSHttpRequest RequestWithURL:CSGame_URL_RemoveBindPhone POSTbody:dict APIName:@"绑定手机" response:^(NSError *error, NSDictionary *resultDict) {
                if (resultDict)
                {
                    if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                    {
                        [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                        if ([modifyUserInfo.delegate respondsToSelector:@selector(bindPhoneSuccess)])
                        {
                             [modifyUserInfo.delegate bindPhoneSuccess];
                        }
                    }
                    else
                    {
                        [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                        if ([modifyUserInfo.delegate respondsToSelector:@selector(bindPhoneFailure)])
                        {
                            [modifyUserInfo.delegate bindPhoneFailure];
                        }
                    }
                }
                else
                {
                    [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
                    }
            }];
        }

    }
    
}

//绑定邮箱
+ (void)connectionBindEmailWithEmailAddress:(NSString *)email delegate:(id)delegate
{
    if ([CSValidation CheckEmail:email])
    {
        CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
        modifyUserInfo.delegate = delegate;
        [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.bind", nil)];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"userinfo_up" forKey:@"do"];
        [dict setObject:email forKey:@"email"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
        [CSHttpRequest RequestWithURL:CSGame_URL_BindEmail POSTbody:dict APIName:@"绑定邮箱" response:^(NSError *error, NSDictionary *resultDict) {
            if (resultDict)
            {
                if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                {
                    [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(bindEmailSuccess)])
                    {
                        [modifyUserInfo.delegate bindEmailSuccess];
                    }
                }
                else
                {
                    [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(bindEmailFailure)])
                    {
                         [modifyUserInfo.delegate bindEmailFailure];
                    }
                }
            }
            else
            {
                [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
            }
        }];
    }
}

//获取手机验证码 (找回密码)
+(void)connectionRetrievePasswordSendVerificationCodeWithUserName:(NSString *)userName delegate:(id)delegate
{
    if ([CSValidation CheckUserName:userName])
    {
        CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
        modifyUserInfo.delegate = delegate;
        [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.request", nil)];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"cellphone" forKey:@"do"];
        [dict setObject:@"2" forKey:@"step"];
        [dict setObject:userName forKey:@"username"];
        [dict setObject:@"1" forKey:@"return_json"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
        [dict setObject:@"1" forKey:@"no_code"];
        [CSHttpRequest RequestWithURL:CSGame_URL_RetrievePwdWithbindPhone POSTbody:dict APIName:@"发送验证码" response:^(NSError *error, NSDictionary *resultDict) {
            if (resultDict)
            {
                if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:@"cellphone" forKey:@"do"];
                    [dict setObject:@"3" forKey:@"step"];
                    [dict setObject:@"1" forKey:@"return_json"];
                    [CSHttpRequest RequestWithURL:CSGame_URL_RetrievePwdWithbindPhone POSTbody:dict APIName:@"发送验证码" response:^(NSError *error, NSDictionary *resultDict) {
                        if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                        {
                            [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                            if ([modifyUserInfo.delegate respondsToSelector:@selector(sendVerificationCodeSuccess)])
                            {
                                [modifyUserInfo.delegate sendVerificationCodeSuccess];
                            }
                        }
                        else
                        {
                            [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                            if ([modifyUserInfo.delegate respondsToSelector:@selector(sendVerificationCodeFailure)])
                            {
                                [modifyUserInfo.delegate sendVerificationCodeFailure];

                            }
                        }
                    }];
                }
                else
                {
                    [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(sendVerificationCodeFailure)])
                    {
                        [modifyUserInfo.delegate sendVerificationCodeFailure];
                        
                    }
                }
            }
            else
            {
                [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
            }
        }];
        
    }
}

//校验验证码有效性 (找回密码)
+(void)connectionCheckEffectivenessVerificationCode:(NSString *)verificationCode delegate:(id)delegate
{
    if ([CSValidation CheckVerificationCode:verificationCode])
    {
        CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
        modifyUserInfo.delegate = delegate;
        [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.validation", nil)];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"cellphone" forKey:@"do"];
        [dict setObject:@"4" forKey:@"step"];
        [dict setObject:verificationCode forKey:@"captcha"];
        [dict setObject:@"1" forKey:@"return_json"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
        [CSHttpRequest RequestWithURL:CSGame_URL_RetrievePwdWithVerificationCode POSTbody:dict APIName:@"校验验证码" response:^(NSError *error, NSDictionary *resultDict) {
            if (resultDict)
            {
                if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                {
                    [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(checkVerificationCodeSuccess)])
                    {
                         [modifyUserInfo.delegate checkVerificationCodeSuccess];
                    }
                }
                else
                {
                    [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(checkVerificationCodeFailure)])
                    {
                        [modifyUserInfo.delegate checkVerificationCodeFailure];
                    }
                }
            }
            else
            {
                [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
            }
        }];
    }
}

//提交新密码
+(void)connectionSubmitNewPasswordWithNewPassword:(NSString *)newPassword delegate:(id)delegate
{
    if ([CSValidation CheckPassword:newPassword])
    {
       [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.request", nil)];
        CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
        modifyUserInfo.delegate = delegate;
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"cellphone" forKey:@"do"];
        [dict setObject:@"6" forKey:@"step"];
        [dict setObject:@"1" forKey:@"return_json"];
        [dict setObject:newPassword forKey:@"password"];
        [dict setObject:newPassword forKey:@"password2"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
        [CSHttpRequest RequestWithURL:CSGame_URL_RetrievePwdWithSubmitNewPwd POSTbody:dict APIName:@"提交新密码" response:^(NSError *error, NSDictionary *resultDict) {
            if (resultDict)
            {
                if ([[resultDict objectForKey:@"status"] intValue] >= 0)
                {
                    [CSProgressHUD showSuccess:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(submitPasswordSuccess)])
                    {
                        [modifyUserInfo.delegate submitPasswordSuccess];
                    }
                }
                else
                {
                    [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                    if ([modifyUserInfo.delegate respondsToSelector:@selector(submitPasswordFailure)])
                    {
                         [modifyUserInfo.delegate submitPasswordFailure];
                    }
                }
            }
            else
            {
                [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
             }
        }];
    }
}

//邮箱找回密码
+(void)connectionRetrievePasswordWithUserName:(NSString *)userName  Email:(NSString *)mail delegate:(id)delegate
{
    if ([CSValidation CheckUserName:userName])
    {
        [CSProgressHUD show:CSLocalizedStringForKey(@"SDK.HUD.validation", nil)];
        CSGameModifyUserInfo * modifyUserInfo = [[CSGameModifyUserInfo alloc]init];
        modifyUserInfo.delegate = delegate;
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:@"getpass_email" forKey:@"do"];
        [dict setObject:userName forKey:@"username"];
        [dict setObject:mail forKey:@"email"];
        [dict setObject:@"1" forKey:@"return_json"];
        [dict setObject:[CSGameModel getRefererparam] forKey:@"referer_param"];
        [CSHttpRequest RequestWithURL:CSGame_URL_RetrievePwdWithEmail POSTbody:dict APIName:@"邮箱找回密码" response:^(NSError *error, NSDictionary *resultDict)
         {
             if (resultDict)
             {
                 if ([[resultDict objectForKey:@"status"] intValue] >= 0 || resultDict == nil)
                 {
                     [CSProgressHUD showSuccess:CSLocalizedStringForKey(@"SDK.HUD.sendEmail", nil)];
                     if ([modifyUserInfo.delegate respondsToSelector:@selector(retrievePasswordWithEmailSuccess)])
                     {
                         [modifyUserInfo.delegate retrievePasswordWithEmailSuccess];
                     }
                 }
                 else
                 {
                     [CSProgressHUD showError:[resultDict objectForKey:@"msg"]];
                     if ([modifyUserInfo.delegate respondsToSelector:@selector(retrievePasswordWithEmailFailure)])
                     {
                         [modifyUserInfo.delegate retrievePasswordWithEmailFailure];
                     }
                 }
             }
             else
             {
                 [CSProgressHUD showError:(NSString *)NetworkErrorMSG];
             }


        }];
    }
}


+ (void)regisApnsToken:(NSString *)token successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [CSGameModel shared].gameToken = token;
    //    http://wvw.9377.cn/api/sdk.php?do=set_token&token=fuck2&gid=11&username=xxx&level=1112&sign=xxx
    if (token)
    {
        [CSGameModel shared].gameToken = token;
        [dict setObject:[CSGameModel shared].gameToken forKey:@"token"];
    }
    else
    {
        NSLog(@"token为空");
        return;
    }
    [dict setObject:@"set_token" forKey:@"do"];
    if ([CSGameModel shared].gameID.length >0)
    {
        [dict setObject:[CSGameModel shared].gameID forKey:@"gid"];
    }
    if ([CSGameModel shared].UserName.length >0)
    {
        [dict setObject:[CSGameModel shared].UserName forKey:@"username"];
    }
    if ([CSGameModel shared].gameLevel >0)
    {
        [dict setObject:[NSNumber numberWithInt:[CSGameModel shared].gameLevel]  forKey:@"level"];
    }
    NSArray *keys = [dict allKeys];
    //    NSLog(@"%@",keys);
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *string = [[NSMutableString alloc]init];
    for (NSString *categoryId in sortedArray)
    {
        //        NSLog(@"%@",categoryId);
        if ([[dict objectForKey:categoryId] isKindOfClass:[NSNumber class]])
        {
            [string appendString:[NSString stringWithFormat:@"%d",[[dict objectForKey:categoryId] intValue]]];
        }
        else
        {
            [string appendString:[dict objectForKey:categoryId]];
        }
        
    }
    
    [string appendString:@"60a8df35002ffbc8290723178bb08ac4"];
    
    NSString *key = [CSGameModel md5:string];
    [dict setObject:key forKey:@"sign"];
    
    
    [CSHttpRequest RequestWithURL:CSGame_URL_NewBase POSTbody:dict APIName:@"发送token" response:^(NSError *error, NSDictionary *resultDict) {
        if (!error)
        {
            if ([[resultDict objectForKey:@"status"] intValue] > 0)
            {
                
                successCallback();
            }
            else
            {
                errorCallback();
            }
        }
        else
        {
            errorCallback();
        }
    }];
    
}

@end

@interface CSGameInstallation()<CSGameInstallationDelegate>
@property (assign , nonatomic)id<CSGameInstallationDelegate>delegate;
@end

@implementation CSGameInstallation

+(void)connectionGameListDelegate:(id)delegate
{
    

}
@end

@implementation CSGamePay

+(void)connectionGameNotifiy
{
    
  
    
}

+ (void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo viewController:(UIViewController *)vc animated:(BOOL)animated disMissBlock:(void(^)())block
{

}

+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo ObjectID:(NSString *)oid viewController:(UIViewController *)vc animated:(BOOL)animated block:(void(^)(BOOL state,NSString *error))block
{

}

+(void)connectionGamePaymentWithPayTime:(NSString *)pay_time OrderID:(NSString*)order_id PayWay:(NSString*)pay_way PayMoney:(float)pay_money GameCoin:(float)game_coin PayIP:(NSString *)pay_ip block:(void(^)(BOOL state,NSString *error))block
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //    do	是	String	payment
    [dict setObject:@"payment" forKey:@"do"];
    //        username	是	String	用户名
    [dict setObject:[CSGameModel shared].UserName forKey:@"username"];
    //        time	是	int	当前unix 10位的时间戳
    NSString * timestamp = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
    [dict setObject:timestamp forKey:@"time"];
    //        sign	是	String	md5(key. game.device_imei.referer.time)
    [dict setObject:[CSGameModel ParameterSignWithTimestamp:timestamp] forKey:@"sign"];
    //        device_imei	是	String	安卓传(IMEI)，苹果正版（传IDFA）
    [dict setObject:[CSGameModel deviceImei] forKey:@"device_imei"];
    //        referer	是	String	广告渠道渠道（推广提供）——除了苹果正版，其他包都得传
    [dict setObject:[CSGameModel getRefererparam] forKey:@"referer"];
    //        pay_time	是	String	充值时间
    [dict setObject:pay_time forKey:@"pay_time"];
    //        时间格式yyyy-mm-dd hh:mm:ss
    //        order_id	是	String	订单号
    [dict setObject:order_id forKey:@"order_id"];
    //        pay_way	是	String	充值方式，请咨询数据接收方
    [dict setObject:pay_way forKey:@"pay_way"];
    //        pay_money	是	Float	充值金额/元
    [dict setObject:[NSNumber numberWithFloat:pay_money] forKey:@"pay_money"];
    //        game_coin	是	Float	充值所获得的游戏币总额
    [dict setObject:[NSNumber numberWithFloat:game_coin] forKey:@"game_coin"];
    //        game	是	Int	所属游戏ID （推广提供——对应后台游戏）
    [dict setObject:[CSGameModel shared].gameID  forKey:@"game"];
    //        server	是	Int	游戏开服序号，如 1, 2, 3
    //        _server	否	Int	开发商服序号，如果开服序号不为常规递增方式，传递此值。server及 _server只能使用其中一个
    if ([CSGameModel shared].serverType) //9377服务区
    {
        [dict setObject:[NSString stringWithFormat:@"%@",[CSGameModel shared].server] forKey:@"server"];
    }
    else
    {
        [dict setObject:[NSString stringWithFormat:@"%@",[CSGameModel shared].server] forKey:@"_server"];
    }
    //        pay_ip	是	String	充值IP
    [dict setObject:pay_ip forKey:@"pay_ip"];
    [dict setObject:@"1" forKey:@"return_json"];
    
    
    [CSHttpRequest RequestWithURL:CSGame_URL_Statistical POSTbody:dict APIName:@"充值数据回传" response:^(NSError *error, NSDictionary *resultDict)
     {
         if ([CSGameModel shared].isDebug)
         {
             NSLog(@"%@",resultDict);
         }
         BOOL *st;
         if (!resultDict)
         {
             st = YES;
         }
         block(st,resultDict);
     }];
    
}

+(void)connectionGamePaymentWithPay:(NSString *)objectID ExtraInfo:(NSString *)extrainStr block:(void(^)(BOOL state,NSString *error))block
{
    [CSGameModel shared].extrainStrlogo = [[NSMutableString alloc]initWithFormat:@":传入%@",extrainStr];
    if (extrainStr)
    {
        [CSGameModel shared].extrainStr = [[NSString alloc]initWithFormat:@"%@",extrainStr];
        [[CSGameModel shared].extrainStrlogo  appendString:@":赋值"];
        [[CSGameModel shared].extrainStrlogo  appendString:[CSGameModel shared].extrainStr];
    }
    else
    {
        [[CSGameModel shared].extrainStrlogo  appendString:@":传入extrainStr为空"];
    }
    [CSProgressHUD show:CSLocalizedStringForKey(@"请稍候", nil)];
    
    NSMutableArray *array = nil;
    
    for (NSMutableDictionary *redictt in array)
    {
        NSLog(@"需要补单！");
       NSMutableDictionary* redict = [[NSMutableDictionary alloc]initWithDictionary:redictt];
        [CSHttpRequest RequestWithURL:CSGame_URL_PayIAP POSTbody:redict APIName:@"内购" response:^(NSError *error, NSDictionary *resultDict)
         {
             
             if ([CSGameModel shared].isDebug)
             {
                 NSLog(@"%@",resultDict);
             }
             if ([[resultDict objectForKey:@"status"] intValue] == 0)
             {
                 [CSGameModel reMoveIAP:redict];
                 if ([CSGameModel shared].isDebug)
                 {
                     NSLog(@"补单完成！");
                 }
             }
             else
             {
                 [[CSIAPManager sharedIAPManager] RefreshRequest:^{
                     NSString *transactionReceiptString = nil;
                     NSURLRequest*appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
                     NSError *error = nil;
                     NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
                     transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                     if (transactionReceiptString)
                     {
                         [redict setObject:transactionReceiptString forKey:@"data"];
                     }
                     NSMutableString *strall = [[NSMutableString alloc]init];
                     if ([redict objectForKey:@"uuid"])
                     {
                         [strall appendString:[redict objectForKey:@"uuid"]];
                     }
                     [strall appendString:[redict objectForKey:@"idfa"]];
                     [strall appendString:[redict objectForKey:@"locale"]];
                     [strall appendString:[NSString stringWithFormat:@"%d",[[redict objectForKey:@"sandbox"] intValue]]];
                     [strall appendString:[NSString stringWithFormat:@"%0.0f",[[redict objectForKey:@"price"] floatValue]]];
                     [strall appendString:[redict objectForKey:@"game_id"]];
                     if ([CSGameModel shared].serverType) //9377服务区
                     {
                         [strall appendString:[redict objectForKey:@"server"]];
                     }
                     else
                     {
                         [strall appendString:[redict objectForKey:@"_server"]];
                     }
                     
                     [strall appendString:[redict objectForKey:@"username"]];
                     [strall appendString:[redict objectForKey:@"currency"]];
                     [strall appendString:[redict objectForKey:@"data"]];
                     
                     
                     [strall appendString:@"i4psu.@ckm$yb4%11s"];
                     NSString *sign = [CSGameModel md5:strall];
                     if (sign)
                     {
                         [redict setObject:sign forKey:@"sign"];
                     }
                     [CSHttpRequest RequestWithURL:CSGame_URL_PayIAP POSTbody:redict APIName:@"内购" response:^(NSError *error, NSDictionary *resultDict)
                      {
                          
                          if ([CSGameModel shared].isDebug)
                          {
                              NSLog(@"%@",resultDict);
                          }
                          if ([[resultDict objectForKey:@"status"] intValue] == 0)
                          {
                              [CSGameModel reMoveIAP:redict];
                              if ([CSGameModel shared].isDebug)
                              {
                                  NSLog(@"补单完成！");
                              }
                          }
                          
                      }];
                 }];
             }
             
         }];
        
    }
    
    if (![CSGameModel shared].UserName)
    {
        block(NO,@"未登录");
        [CSProgressHUD showError:@"未登录"];
        return;
    }
    
    

    
    [[CSIAPManager sharedIAPManager] getProductsForIds:[NSArray arrayWithObjects:objectID, nil]
                                            completion:^(NSArray *products) {
                                                BOOL hasProducts = [products count] != 0;
                                                if(! hasProducts)
                                                {
                                                    block(NO,@"未找到对应商品");
                                                    [CSProgressHUD showError:@"未找到对应商品"];
                                                }
                                                else
                                                {
                                                    SKProduct *product = products[0];
                                                    if (product)
                                                    {
                                                        [CSGamePay purchaseProduct:product ExtraStr:[CSGameModel shared].extrainStr block:^(BOOL state,NSString *error)
                                                         {
                                                             block(state,error);
                                                         }];
                                                    }
                                                }

                                            } error:^(NSError *error) {
                                                block(NO,error.localizedDescription);
                                                [CSProgressHUD showError:error.localizedDescription];
                                            }];
}

+(void)purchaseProduct:(SKProduct *)product ExtraStr:(NSString *)extrastr block:(void(^)(BOOL state,NSString *error))block
{
    
    [[CSIAPManager sharedIAPManager] purchaseProduct: product ExtraStr:extrastr completion:^(SKPaymentTransaction *transaction)
     {
         NSMutableDictionary *dict = [CSGameModel IAPDict:product withSKPaymentTransaction:transaction];
         [CSGameModel saveIAP:dict];
//         [dict setObject:@"999999" forKey:@"price"];
         [CSHttpRequest RequestWithURL:CSGame_URL_PayIAP POSTbody:dict APIName:@"内购" response:^(NSError *error, NSDictionary *resultDict)
          {
              BOOL st = NO;
              if ([CSGameModel shared].isDebug)
              {
                  NSLog(@"%@",resultDict);
              }
              if (resultDict)
              {
                  if ([[resultDict objectForKey:@"status"] intValue] == 0)
                  {
                      st = YES;
                      [CSGameModel reMoveIAP:dict];
                      block(st,[resultDict objectForKey:@"message"]);
                      [CSProgressHUD showSuccess:@"购买完成"];
                  }
                  else
                  {
                      [CSProgressHUD showError:[resultDict objectForKey:@"message"]];
                      block(st,[resultDict objectForKey:@"message"]);
                  }
              }
              else
              {
                  [CSProgressHUD showError:[resultDict objectForKey:@"message"]];
                  block(st,[resultDict objectForKey:@"message"]);
              }
          }];
         
     } error:^(NSError *error)
     {
         block(NO,error.localizedDescription);
         [CSProgressHUD showError:error.localizedDescription];
     }];
    
}


@end


@implementation UIButton(csgameapiservice)

-(void)setBackgroundImageUrl:(NSString *)imageurl forState:(UIControlState)state
{
    static CSAFHTTPSessionManager * manager;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [CSAFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15.0;   //网络超时时间
        manager.requestSerializer = [CSAFHTTPRequestSerializer serializer];
        manager.responseSerializer = [CSAFImageResponseSerializer serializer];
    });
    [manager GET:imageurl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self setBackgroundImage:responseObject forState:state];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

@end
