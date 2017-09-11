//
//  CSGameModel.h
//  CSgameSDKDemo
//
//  Created by FreeGeek on 15/6/16.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
//#import "GuangBoView.h"
#import "CSNavigationController.h"

@interface CSGameModel : NSObject
//游戏参数设置
@property (strong , nonatomic) NSString * gameID;
@property (strong , nonatomic) NSString * gameReferer;
@property (strong , nonatomic) NSString * server;
@property (strong , nonatomic) NSString * sessionID;
@property (strong , nonatomic) NSString * NewRefererParam;

@property (strong , nonatomic) NSString * server_timestamp;
@property (strong , nonatomic) NSString * server_token;

@property (assign , nonatomic) int platForm;
@property (assign , nonatomic) int serverType;
@property (assign , nonatomic) BOOL isDebug;
@property (assign , nonatomic) BOOL isShowGM;
@property (strong , nonatomic) NSString * server_GMLink;
@property(nonatomic,strong)NSString *device_imei;
@property(nonatomic,strong)NSString *ad_param;
@property(nonatomic,strong)NSString *referer_param;
@property(nonatomic,assign)int deepActivationSec;
@property(nonatomic,strong)NSString *deepActivationUserName;
@property(nonatomic,strong)NSString *uuid;
@property(nonatomic,strong)NSString *gamename;
@property(nonatomic,strong)NSString *QTeamWithGameName;
@property(nonatomic,assign)UIInterfaceOrientationMask mask;

@property (strong , nonatomic) NSString * gameToken;
@property (assign , nonatomic) int gameLevel;
@property (assign , nonatomic) int commnetIndex;

@property (strong , nonatomic) NSString * NotifiyTitle;
@property (strong , nonatomic) NSString * NotifiyUrl;
@property (strong , nonatomic) NSString * NotifiyMsg;
@property (assign , nonatomic) BOOL NotifiyShow;
@property (assign , nonatomic) BOOL DragButtonHidden;
@property (assign , nonatomic) BOOL LoginShow;
@property (assign , nonatomic) int NotifiyMode;

//用户资料
@property (strong , nonatomic) NSString * UserSessionID;
@property (strong , nonatomic) NSString * UserName;
@property (strong , nonatomic) NSString * UserPassword;
@property (strong , nonatomic) NSData * HeaderImageData;
@property (strong , nonatomic) NSDictionary * UserInfoDict;
@property (strong , nonatomic) NSMutableDictionary * commentDict;
@property (strong , nonatomic) NSMutableDictionary * NotifiyDict;
@property (strong , nonatomic) NSMutableDictionary * PointDict;
@property (assign , nonatomic) int UserMoney;
@property (strong , nonatomic) NSString * extrainStr;
@property (assign , nonatomic) int IAPReTime;
@property (strong , nonatomic) NSString* price;


@property (strong , nonatomic) NSMutableString *extrainStrlogo;
//@property(nonatomic,strong)GuangBoView *gbView;


@property (strong, nonatomic) NSMutableDictionary *products;

//展现视图动画
@property (assign , nonatomic) BOOL LoginAnimated;
@property (assign , nonatomic) BOOL PayAnimated;
@property (assign , nonatomic) int  commentbackground;

@property (strong , nonatomic) UIViewController *loginVC;
@property (strong , nonatomic) CSNavigationController *loginNVC;
@property (strong , nonatomic) UIViewController *noticCommentviewcontroller;

//payRequest
@property (strong , nonatomic) NSMutableURLRequest * payRequest;
@property (assign , nonatomic) int loadcount;

+(CSGameModel *)shared;
+(NSString *)Model;
+(NSString *)getRefererparam;
+(NSString *)ParameterSignWithTimestamp:(NSString *)timestamp;
+(NSString *)deviceImei;
+(NSMutableDictionary *)publicData;

+(NSString *)UUID:(NSString *)gameid;

+ (NSString *)md5:(NSString *)str;
//游客登录账号密码
+(NSString *)TouristsLoginAccount;
//加密
+(NSString *)EnCodeStringWithResult:(NSString *)result;

+(NSString *)CSGTMBase64WithString:(NSString *)string;
//获取游戏列表参数格式化
+(NSString *)URLWithDict:(NSMutableDictionary *)dict AndHost:(NSString *)host;
//解密
+(NSString *)DecodeStringWithStr:(NSString *)resultsStr;

//OTA
+ (NSString *)RePath:(NSString *)urlpath WithFormat:(NSString *)string,... NS_REQUIRES_NIL_TERMINATION;


+(BOOL)saveIAP:(NSMutableDictionary *)iapDict;
+(BOOL)reMoveIAP:(NSMutableDictionary *)iapDict;
+(NSMutableArray *)AllIAP;
+ (NSString *)URLEncodedString:(NSString *)string;
+(NSMutableDictionary *)IAPDict:(SKProduct*)product withSKPaymentTransaction:(SKPaymentTransaction*)tran;
+(BOOL)iscomment:(NSString*)commentversion;
+(void)comment:(NSString *)commentversion;


+(BOOL)isShowPoCM;
+(void)ShowPoCm;
+(void)EndShowPoCm;

+(BOOL)isShowRedPoint;
+(void)endShowRedPoint;

+(CGPoint)PointBar;
+(void)UserPointBar:(CGPoint)point;
+(BOOL)isInjoinNotify:(NSString*)notify;
+(void)injoinNotify;
@end

@interface CSGameListModel : NSObject
@property (strong , nonatomic) NSMutableArray * nameArray;
@property (strong , nonatomic) NSMutableArray * sizeArray;
@property (strong , nonatomic) NSMutableArray * downsArray;
@property (strong , nonatomic) NSMutableArray * summaryArray;
@property (strong , nonatomic) NSMutableArray * defaultImgArray;
@property (strong , nonatomic) NSMutableArray * dirArray;
@property (strong , nonatomic) NSMutableArray * otaArray;
@property (strong , nonatomic) NSString * hostString;
@property (assign , nonatomic) int count;

+(CSGameListModel *)shared;
@end
