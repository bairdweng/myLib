
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//------------------------------------------------------------------------------ 枚举值 --------------------------------------------------------------------------------
typedef NS_ENUM(NSInteger , CSGameServerType)
{
    CSGAME_SERVER_TYPE_CS = 1,                      //SCG服务区号
    CSGAME_SERVER_TYPE_DEV = 0                     //开发商服务区号
};

//前往TabBar详细页面
typedef NS_ENUM(NSInteger , CSGameSelectedController)
{
    CSGAME_SELECTED_ACCOUNT = 0,                  //账户
    CSGAME_SELECTED_HELP = 1                         //帮助
//    CSGAME_SELECTED_GAME = 2                         //游戏
};

//游戏平台
typedef NS_ENUM(NSInteger, CSGamePlatform) {
    CSGAME_PLATFORM_ORIGINAL_IOS = 1,           //IOS非越狱版
    CSGAME_PLATFORM_NONORIGINAL_IOS = 2,    //IOS越狱版
    CSGAME_PLATFORM_ANDROID = 3,                  //android
};
//-------------------------------------------------------------------------------- 通知 -------------------------------------------------------------------------------------------
//账号内部按钮注销成功通知
extern NSString * const CSGame_Account_LogoutSuccess;

//新用户注册成功通知
extern NSString * const CSGame_Account_RegisSuccess;

//-------------------------------------------------------------------------------- 平台参数设置 -------------------------------------------------------------------------------------------
@interface CSGameActivation : NSObject
/**
 *  @brief  设置平台
 *  @param platform
 */
+(void)setPlatform:(CSGamePlatform)platform;

/**
 *  @brief  设置UUID
 *  @param UUID
 */
+(void)setUUID:(NSString *)UUID;


/**
 *@brief device_imei默认使用IDFA
 *@param device_imei
 */

+ (void)setdevice_imei:(NSString *)device_imei;

/**
 *@brief ad_param广告素材（推广提供，未提供就不要设置）
 */
+ (void)setad_param:(NSString *)ad_param;

/**
 *@brief referer_param子渠道（推广提供，未提供就不要设置）
 */

+ (void)setreferer_param:(NSString *)referer_param;
/**
 *@brief：积分墙专用：：积分墙专用：：积分墙专用： 新用户深度激活时间设置，（用户注册后，）单位秒。
 */
+(void)DeepActivationSec:(int)sec;
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


+(void)setOrientationMask:(UIInterfaceOrientationMask)mask;



//-------------------------------------------------------------------------------- 激活 -------------------------------------------------------------------------------------------
/**
 *  @brief  激活SDK
 *  @param referer        渠道号不做特殊说明，传入@""
 *  @param gameID       游戏ID
 *  @param gamename 为游戏别名
 *  @parma statisticsKey 统计系统的key
 */
//+ (void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID serverType:(CSGameServerType)serverType;
//+ (void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID gameName:(NSString*)gamename;
+ (void)connectionSDK:(NSString *)referer gameID:(NSString *)gameID gameName:(NSString*)gamename statisticsKey:(NSString *)key;
@end


//-------------------------------------------------------------------------------- 授权 --------------------------------------------------------------------------------
@interface CSGameAuth : NSObject
/**
 *  @brief  登录
 *  @param vc                  当前控制器
 *  @param annimated      是否执行页面切换动画
 *  @param block              登录回调block         userName:用户名      sessionID:用户认证ID  timestamp:服务器返回时间戳  token:签名
 *  @param dismissblock    登录页面消失回调
 */
+(void)connectionLoginForController:(UIViewController *)vc animated:(BOOL)animated block:(void(^)(NSString * userName,NSString * sessionID ,NSString *timestamp,NSString *token))block dismissSuccess:(void(^)())dismissblock;

/**
 *  @brief     注销
 *  @param   注销回调block
 */
+(void)connectionLogoutWithBlock:(void(^)(BOOL state))block;

/**
 *  @brief  进入游戏服日志所需参数，游戏激活数据采集
 */
+(void)EnterData;

/**
 *  @brief  进入游戏服日志所需参数，游戏激活数据采集(自传用户名)
 *
 *  @param userName
 */
+(void)EnterDataUserName:(NSString *)userName;

/**
 *  @brief  登录验证
 *  @param sessionId 用户登录成功获取的SessionId
 *  @param block     YES:还在登录状态  NO:已不在登录状态
 */
+(void)loginValidationWithSessionID:(NSString *)sessionId block:(void(^)(BOOL loginState))block;
@end


//--------------------------------------------------------------------------------  支付  --------------------------------------------------------------------------------
@interface CSGamePullPay : NSObject
/**
 *  @brief  支付
 *  @param gameName    游戏别名
 *  @param userName      用户名称
 *  @param amount         定额支付金额,单位为元,最小单位为1元
 *  @param extraInfo       透传参数,将原样回调到游戏服务器
 *  @param vc                 当前控制器
 *  @param annimated     是否执行页面切换动画
 *  @param block             支付页面消失回调
 */
+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo viewController:(UIViewController *)vc animated:(BOOL)animated disMissBlock:(void (^)())block;

/**
 *  @brief  支付  包含内购
 *  @param gameName    游戏别名
 *  @param userName      用户名称
 *  @param amount         定额支付金额,单位为元,最小单位为1元
 *  @param extraInfo       透传参数,将原样回调到游戏服务器
 *  @param vc                 当前控制器
 *  @param annimated     是否执行页面切换动画
 *  @param (BOOL state,NSString *error))block  state内购是否完成，error未完成时，错误信息
 *  @param ObjectID         内购ID
 */
+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo ObjectID:(NSString *)oid viewController:(UIViewController *)vc animated:(BOOL)animated block:(void(^)(BOOL state,NSString *error))block;

/**
 *  @brief 支付完成通知
 *  @param pay_time		String	充值时间 时间格式yyyy-mm-dd hh:mm:ss
 *  @param order_id		String	订单号
 *  @param pay_way		String	充值方式，请咨询数据接收方
 *  @param pay_money		Float	充值金额/元
 *  @param game_coin		Float	充值所获得的游戏币总额
 *  @param pay_ip		String	充值IP
 *  @param block    是否发送成功
 */
+(void)connectionGamePaymentWithPayTime:(NSString *)pay_time OrderID:(NSString*)order_id PayWay:(NSString*)pay_way PayMoney:(float)pay_money GameCoin:(float)game_coin PayIP:(NSString *)pay_ip block:(void(^)(BOOL state,NSString *error))block;
@end


//-------------------------------------------------------------------------------- 浮标设置 --------------------------------------------------------------------------------
@interface CSGameFloatButton :NSObject
/**
 *  @brief  设置浮动按钮是否隐藏
 *  @param hide YES:隐藏  NO:显示
 */
+ (void)setFloatButtonHide:(BOOL)hide;
@end
//-------------------------------------------------------------------------------- 跳转TabBar页面 --------------------------------------------------------------------------------
@interface CSGameController : NSObject
/**
 *  @brief  拉起详细页面控制器
 *  @param vc 当前控制器
 *  @param index CSGAME_SELECTED_ACCOUNT : 账户 CSGAME_SELECTED_HELP : 帮助  CSGAME_SELECTED_GAME : 游戏
 */
+(void)PullUpForViewController:(UIViewController *)vc Index:(CSGameSelectedController)index;
@end

@interface CSGameIAPShare : NSObject
/**
 *  @brief  内购
 *  @param objectID 内购ID
 *  @param amount 内购rmb金额
 *  @param extrainStr 透传字符串
 *  @param (BOOL state,NSString *error))block  state内购是否完成，error未完成时，错误信息
 */
+(void)IAPShareBuyObject:(NSString *)objectID Amount:(NSString*)amount ExtraInfo:(NSString *)extrainStr block:(void(^)(BOOL state,NSString *error))block;
//
// isbang   0 调用IAPShareBuyObject
//          1+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo viewController:(UIViewController *)vc animated:(BOOL)animated disMissBlock:(void (^)())block;
//          2+(void)connectionGamePayWithGameName:(NSString *)gameName userName:(NSString *)userName amount:(int)amount extraInfo:(NSString *)extraInfo ObjectID:(NSString *)oid viewController:(UIViewController *)vc animated:(BOOL)animated block:(void(^)(BOOL state,NSString *error))block;
+(void)IAPCheck:(void(^)(int isbang))block;
@end


@interface CSGamePush : NSObject

/**
 注册设备
 @param deviceToken 通过app delegate的didRegisterForRemoteNotificationsWithDeviceToken回调的获取
 @param successCallback 成功回调
 @param errorCallback 失败回调
 @return  获取的 deviceToken 字符串
 */
+(nullable NSString *)registerDevice:(nonnull NSData *)deviceToken successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback;


/**
 设置 Level
 
 @param Level 玩家的游戏等级 Level
 */
+(void)setlevel:(int)level;


/**
 在didFinishLaunchingWithOptions中调用，用于推送反馈.(app没有运行时，点击推送启动时)
 
 @param launchOptions didFinishLaunchingWithOptions中的userinfo参数
 @param successCallback 成功回调
 @param errorCallback 失败回调
 */
+(void)handleLaunching:(nonnull NSDictionary *)launchOptions successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback;

/**
 在didReceiveRemoteNotification中调用，用于推送反馈。(app在运行时)
 
 @param userInfo 苹果 apns 的推送信息
 @param successCallback 成功回调
 @param errorCallback 失败回调
 */
+(void)handleReceiveNotification:(nonnull NSDictionary *)userInfo successCallback:(nullable void (^)(void)) successCallback errorCallback:(nullable void (^)(void)) errorCallback;


@end

