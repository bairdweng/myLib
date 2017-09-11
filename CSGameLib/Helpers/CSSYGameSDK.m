

#import "CSSYGameSDK.h"
//#import "CSLoginViewController.h"
#import "CSGameAPIService.h"
//#import "CSAccountViewController.h"
#import "buoyButton.h"
#import "CSGameModel.h"
//#import "CSGameTabBarViewController.h"
#import "CSNavigationController.h"
#import "CSProgressHUD.h"
//#import "CSPayViewController.h"
//#import "TrackingIO.h"

NSString * const CSGame_Account_LogoutSuccess = @"CSGame_Account_Logout";
NSString * const CSGame_Account_RegisSuccess = @"CSGame_Account_RegisSuccess";
@interface CSGameAuth()
@end
@implementation CSGameAuth

+(void)connectionLoginForController:(UIViewController *)vc animated:(BOOL)animated block:(void(^)(NSString * userName,NSString * sessionID ,NSString *timestamp,NSString *token))block dismissSuccess:(void(^)())dismissblock
{
    
//   
//    [CSGameModel shared].LoginAnimated = animated;
//    CSLoginViewController * CSLoginVC = [[CSLoginViewController alloc]init];
//    CSLoginVC.loginState = ^(NSString * userName,NSString * sessionID ,NSString *timestamp,NSString *token)
//    {
//        block(userName,sessionID,timestamp,token);
//
//    };
//    CSLoginVC.dismiss = ^(){
//        dismissblock();
//    };
//    NavigationController * CSLoginVCNav = [[NavigationController alloc]initWithRootViewController:CSLoginVC];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
//    {
//        CSLoginVCNav.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    }
//    else
//    {
//        CSLoginVCNav.modalPresentationStyle=UIModalPresentationCurrentContext;
//        vc.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
//        vc.modalPresentationStyle = UIModalPresentationCurrentContext;
//        CSLoginVCNav.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    }
//    [CSGameModel shared].loginNVC = CSLoginVCNav;
//    [CSGameModel shared].loginVC = vc;
////    if (![CSGameModel shared].NotifiyShow)
////    {
//    
//    [vc presentViewController:CSLoginVCNav animated:animated completion:nil];
//    }
//    else
//    {
//        [CSGameModel shared].LoginShow = YES;
//    }
    
//    [[[NSMutableDictionary new] objectForKey:@"NSErrorFailingURLKey"] rangeOfString:@"weixin://"].length;
//    [vc.view.window.rootViewController presentViewController:CSLoginVCNav animated:animated completion:nil];
}

/**
 *  @brief  登出
 */
+(void)connectionLogoutWithBlock:(void(^)(BOOL state))block
{
    [CSGameAuthorization connectionLogoutWithBlock:^(BOOL state) {
        block(state);
    }];
}

+(void)PopNotifi
{
    if ([CSGameModel shared].NotifiyMsg)
    {
         [CSGamePay connectionGameNotifiy];
    }
   
}

+(void)EnterData
{
    [CSGameAuthorization EnterData];
    
}

+(void)EnterDataUserName:(NSString *)userName
{
    [CSGameAuthorization EnterDataUserName:userName];
}

//登录校验
+(void)loginValidationWithSessionID:(NSString *)sessionId block:(void(^)(BOOL loginState))block
{
    [CSGameAuthorization loginValidationWithSessionID:sessionId block:^(BOOL loginState) {
        block(loginState);
    }];
}

@end

@implementation CSGameActivation
+(void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID serverType:(CSGameServerType)serverType
{
    [CSGameAPIService connectionSDK:referer gameID:gameID serverType:(int)CSGAME_SERVER_TYPE_DEV];
//     [CSGameActivation DisPlayQTeamWithGameName:@"htioshw"];
//    [CSGameActivation DeepActivationSec:10];
}

+ (void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID gameName:(NSString*)gamename;
{
    [CSGameAPIService connectionSDK:referer gameID:gameID serverType:0];
//    [CSGameActivation DisPlayQTeamWithGameName:gamename];
    [CSGameModel shared].gamename = gamename;
}

+ (void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID gameName:(NSString*)gamename statisticsKey:(NSString *)key
{
     [CSGameAPIService setPlatform:CSGAME_PLATFORM_ORIGINAL_IOS];
    [self connectionSDK:referer gameID:gameID gameName:gamename];
   
//    [TrackingIO setPrintLog:YES];
//    [TrackingIO initWithappKey:key withChannelId:@"_default_"];
}

+(void)setPlatform:(CSGamePlatform)platform
{
    [CSGameAPIService setPlatform:platform];
}

/**
 *  @brief  设置UUID
 *  @param UUID
 */
+(void)setUUID:(NSString *)UUID
{
    NSLog(@"%@",UUID);
    [CSGameModel shared].uuid = UUID;
}
/**
 *  @brief  获取QQ群key，如果获取为空，则不显示，gamename 为游戏别名
 *  @param gamename
 */

+(void)DisPlayQTeamWithGameName:(NSString *)gamename
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (gamename.length > 0)
        {
            NSString *url = [NSString stringWithFormat:@"https://wvw.9377.cn/api/qq_group.php?game=%@",[CSGameModel URLEncodedString:gamename]];
            NSData *string = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]options:1 error:nil];
            if (string)
            {
                NSString *restr = [[NSString alloc]initWithData:string encoding:NSUTF8StringEncoding];
                NSArray  *array = [restr componentsSeparatedByString:@"|"];
                if (array.count == 2)
                {
                    NSString *restr = [[NSString alloc]initWithData:string encoding:NSUTF8StringEncoding];
                    NSArray  *array = [restr componentsSeparatedByString:@"|"];
                    if (array.count == 2)
                    {
                        NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external",[array objectAtIndex:0],[array objectAtIndex:1]];
                        [CSGameModel shared].QTeamWithGameName = urlStr;
                        
                    }
                }
            }
        }
        
    });

}

/**
 *@brief device_imei默认使用IDFA
 *@param device_imei
 */

+ (void)setdevice_imei:(NSString *)device_imei
{
    [CSGameModel shared].device_imei = device_imei;
}

/**
 *@brief ad_param广告素材（推广提供，未提供就不要设置）
 */
+ (void)setad_param:(NSString *)ad_param
{
    [CSGameModel shared].ad_param = ad_param;
}

/**
 *@brief referer_param子渠道（推广提供，未提供就不要设置）
 */

+ (void)setreferer_param:(NSString *)referer_param
{
    [CSGameModel shared].referer_param = referer_param;
}
/**
 *@brief：积分墙专用：：积分墙专用：：积分墙专用： 新用户深度激活时间设置，（用户注册后，）单位秒。
 */
+(void)DeepActivationSec:(int)sec
{
    [CSGameModel shared].deepActivationSec = sec;
}


+(void)setServer:(NSString *)server
{
    [CSGameAPIService setServer:server];
}


+(void)setDebug:(BOOL)isDebug
{
    [CSGameAPIService setDebug:isDebug];
}

+(void)setOrientationMask:(UIInterfaceOrientationMask)mask
{
    [CSGameModel shared].mask = mask;
}
@end

@implementation CSGamePullPay
+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo viewController:(UIViewController *)vc animated:(BOOL)animated disMissBlock:(void (^)())block
{
    [CSGameModel shared].PayAnimated = animated;
    [CSGamePay connectionGamePayWithGameName:gameName userName:userName amount:amount extraInfo:extraInfo viewController:vc animated:animated disMissBlock:^{
        block();
    }];
}

+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo ObjectID:(NSString *)oid viewController:(UIViewController *)vc animated:(BOOL)animated block:(void(^)(BOOL state,NSString *error))block

{
    [CSGameModel shared].PayAnimated = animated;
    [CSGamePay connectionGamePayWithGameName:gameName userName:userName amount:amount extraInfo:extraInfo ObjectID:oid viewController:vc animated:animated block:^(BOOL state, NSString *error) {
        block(state,error);
    }];
}

+(void)connectionGamePaymentWithPayTime:(NSString *)pay_time OrderID:(NSString*)order_id PayWay:(NSString*)pay_way PayMoney:(float)pay_money GameCoin:(float)game_coin PayIP:(NSString *)pay_ip block:(void(^)(BOOL state,NSString *error))block
{
    [CSGamePay connectionGamePaymentWithPayTime:pay_time OrderID:order_id PayWay:pay_way PayMoney:pay_money GameCoin:game_coin PayIP:pay_ip block:^(BOOL state, NSString *error) {
        block(state,error);
    }];
}
@end

@implementation CSGameFloatButton

+(void)setFloatButtonHide:(BOOL)hide
{
    [buoyButton defaultFloatViewWithButton].DragButtonHidden = hide;
    [buoyButton setDragButtonHidden:hide];
}

@end

@implementation CSGameController

+(void)PullUpForViewController:(UIViewController *)vc Index:(CSGameSelectedController)index
{
    if ([CSGameModel shared].UserName.length > 0)
    {
//        CSGameTabBarViewController * tabbarVC = [[CSGameTabBarViewController alloc]init];
//        tabbarVC.selectedIndex = index;
//        [vc presentViewController:tabbarVC animated:YES completion:nil];
//        [vc.view.window.rootViewController presentViewController:tabbarVC animated:YES completion:nil];
    }
    else
    {
        if ([CSGameModel shared].isDebug)
        {
            NSLog(@"----- 拉起详情页面失败 ----- Msg:未登录");
        }
    }
}
@end


@implementation CSGameIAPShare


+(void)IAPCheck:(void(^)(int isbang))block
{
    [CSGameAuthorization isBang:^(int isbang)
     {
         block(isbang);
     }];
}


+(void)IAPShareBuyObject:(NSString *)objectID Amount:(NSString*)amount ExtraInfo:(NSString *)extrainStr block:(void(^)(BOOL state,NSString *error))block
{
    
//    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
//    UIWindow *window;
//    if ([delegate respondsToSelector:@selector(window)])
//    {
//        window = [delegate window];
//    }
//    if (!window)
//    {
//        window = [[UIApplication sharedApplication] keyWindow];
//    }
//    [CSGameAuthorization isBang:^(int isbang)
//     {
//         if (isbang == 1)
//         {
//             
//             if (!extrainStr)
//             {
//                 [CSGamePay connectionGamePayWithGameName:[CSGameModel shared].gamename userName:[CSGameModel shared].UserName amount:[amount intValue] extraInfo:@"" viewController:window.rootViewController animated:YES disMissBlock:^{
//                     block(YES,@"");
//                 }];
//             }
//             else
//             {
//                 [CSGamePay connectionGamePayWithGameName:[CSGameModel shared].gamename userName:[CSGameModel shared].UserName amount:[amount intValue] extraInfo:extrainStr viewController:window.rootViewController animated:YES disMissBlock:^{
//                     block(YES,@"");
//                 }];
//             }
//             
//             
//             
//         }
//         else if (isbang == 2)
//         {
//             
//             [CSGamePay connectionGamePayWithGameName:[CSGameModel shared].gamename userName:[CSGameModel shared].UserName amount:[amount intValue] extraInfo:extrainStr ObjectID:objectID viewController:window.rootViewController animated:YES block:^(BOOL state, NSString *error) {
//                 block(state,error);
//             }];
//         }
//         
//         else
//         {
    [CSGameModel shared].price = amount;
             [CSGamePay connectionGamePaymentWithPay:objectID ExtraInfo:extrainStr block:^(BOOL state, NSString *error) {
                 block(state,error);
             }];
//         }
//    }];

    
    
}




@end

@implementation CSGamePush




/**
 注册设备
 
 @param deviceToken 通过app delegate的didRegisterForRemoteNotificationsWithDeviceToken回调的获取
 @param successCallback 成功回调
 @param errorCallback 失败回调
 @return  获取的 deviceToken 字符串
 */
+(nullable NSString *)registerDevice:(nonnull NSData *)deviceToken successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback
{
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    [CSGameModifyUserInfo regisApnsToken:hexToken successCallback:^{
        successCallback();
    } errorCallback:^{
        errorCallback();
    }];
    
    return hexToken;
}

/**
 设置 Level
 
 @param Level 玩家的游戏等级 Level
 */
+(void)setlevel:(int)level
{
    [CSGameModel shared].gameLevel = level;
    [CSGameModifyUserInfo regisApnsToken:[CSGameModel shared].gameToken successCallback:^{
    } errorCallback:^{
    }];
}
/**
 设置 TotalRecharge
 
 @param rmb 玩家的游戏中花费的rmb
 */
+(void)setTotalRecharge:(int)rmb
{
    
}


//+(void)handleLaunching:(nonnull NSDictionary *)launchOptions successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback
//{
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    if (launchOptions)
//    {
//        
//        NSMutableDictionary *apns = [launchOptions objectForKey:@"aps"];
//        if (apns)
//        {
//            int  type = [[apns objectForKey:@"PushType"] intValue];
//            NSString *urlstr = [apns objectForKey:@"url"];
//            if (urlstr)
//            {
//                successCallback();
//                switch (type)
//                {
//                    case 1:
//                    {
//                        NSURL * url = [NSURL URLWithString:urlstr];
//                        NSMutableURLRequest * payRequest = [[NSMutableURLRequest alloc]initWithURL:url];
//                        [CSGameModel shared].payRequest = payRequest;
//                        CSPayViewController * CSPayVC = [[CSPayViewController alloc]init];
//                        NavigationController * CSLoginVCNav = [[NavigationController alloc]initWithRootViewController:CSPayVC];
//                        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
//                        {
//                            CSLoginVCNav.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//                        }
//                        else
//                        {
//                            CSLoginVCNav.modalPresentationStyle=UIModalPresentationCurrentContext;
//                            CSLoginVCNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//                        }
//                        
//                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:CSLoginVCNav animated:YES completion:nil];
//                    }
//                        break;
//                        
//                    default:
//                    {
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstr]];
//                    }
//                        break;
//                }
//            }
//            else
//            {
//                errorCallback();
//            }
//            
//        }
//    }
//}

/**
 在didReceiveRemoteNotification中调用，用于推送反馈。(app在运行时)
 
 @param userInfo 苹果 apns 的推送信息
 @param successCallback 成功回调
 @param errorCallback 失败回调
 */
//+(void)handleReceiveNotification:(nonnull NSDictionary *)userInfo successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback
//{
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    if (userInfo)
//    {
//        NSLog(@"userInfo:%@",userInfo);
//        NSMutableDictionary *apns = [userInfo objectForKey:@"aps"];
//        if (apns)
//        {
//            int  type = [[apns objectForKey:@"PushType"] intValue];
//            NSString *urlstr = [apns objectForKey:@"url"];
//            if (urlstr)
//            {
//                successCallback();
//                switch (type)
//                {
//                    case 1:
//                    {
//                        NSURL * url = [NSURL URLWithString:urlstr];
//                        NSMutableURLRequest * payRequest = [[NSMutableURLRequest alloc]initWithURL:url];
//                        [CSGameModel shared].payRequest = payRequest;
//                        CSPayViewController * CSPayVC = [[CSPayViewController alloc]init];
//                        NavigationController * CSLoginVCNav = [[NavigationController alloc]initWithRootViewController:CSPayVC];
//                        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
//                        {
//                            CSLoginVCNav.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//                        }
//                        else
//                        {
//                            CSLoginVCNav.modalPresentationStyle=UIModalPresentationCurrentContext;
//                            CSLoginVCNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//                        }
//                        
//                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:CSLoginVCNav animated:YES completion:nil];
//                    }
//                        break;
//                        
//                    default:
//                    {
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstr]];
//                    }
//                        break;
//                }
//            }
//            else
//            {
//                errorCallback();
//            }
//            
//        }
//    }
//}

@end



