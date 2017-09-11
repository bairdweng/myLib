//
//  CSGameModel.m
//  CSgameSDKDemo
//
//  Created by FreeGeek on 15/6/16.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import "CSGameModel.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CSReachability.h"
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
#import "CSSBJson4.h"
#import "CSGTMBase64.h"
#import <sys/utsname.h>
#import "CSSSKeychain.h"
#import "CSGameSDKpch.h"
NSString *const KEY = @"whatthefuckakey1931csez";
NSString *const KEY_TJ = @"whatthefuckakeytj9377jkl";

@implementation CSGameListModel
@synthesize defaultImgArray,downsArray,nameArray,sizeArray,summaryArray,hostString,dirArray,otaArray,count;
+(CSGameListModel *)shared
{
    static CSGameListModel * model;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        model = [[CSGameListModel alloc]init];
    });
    return model;
}

@end

@implementation CSGameModel
@synthesize gameID,gameReferer,isDebug,server,serverType,sessionID,UserSessionID,UserName,UserPassword,UserInfoDict,payRequest,HeaderImageData,platForm,NewRefererParam;
@synthesize uuid,ad_param,referer_param,deepActivationSec,deepActivationUserName,device_imei,QTeamWithGameName;

+(CSGameModel *)shared
{
    static CSGameModel * model;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        model = [[CSGameModel alloc]init];
    });
    return model;
}

+(NSMutableDictionary *)publicData
{
    //time	当前时间戳
    //sign	md5(key. game.device_imei.channel.time)
    //game	所属游戏ID （推广提供——对应后台游戏）
    //platform	平台1(正版) 2(ios越狱) 3(android)
    //device_imei	IMEI
    //referer	渠道（推广提供）
    //ad_param	广告素材（推广提供）
    //device_model	设备机型 如:三星/小米2
    //device_resolution	分辨率
    //device_os	操作系统
    //device_carrier	运营商
    //device_network	联网方式
    

    NSMutableDictionary * publicData = [NSMutableDictionary dictionary];
    NSString * timestamp = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
    [publicData setObject:timestamp forKey:@"time"];
    [publicData setObject:[self shared].gameID forKey:@"game"];
    [publicData setObject:@([self shared].platForm) forKey:@"platform"];                     //--------------
    [publicData setObject:[self deviceImei] forKey:@"device_imei"];//------------------
    [publicData setObject:[self shared].gameReferer forKey:@"referer"];
    [publicData setObject:@"" forKey:@"ad_param"];  //-----------------
    [publicData setObject:[self Model] forKey:@"device_model"];
    [publicData setObject:[self ScreenReslution] forKey:@"device_resolution"];
    [publicData setObject:[self SystemName] forKey:@"device_os"];
     [publicData setObject:[[NSString alloc] initWithFormat:@"%@",[self CurrentOperators]] forKey:@"device_carrier"];
    [publicData setObject:[self CurrentNetType] forKey:@"device_network"];
    [publicData setObject:[self ParameterSignWithTimestamp:timestamp] forKey:@"sign"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [publicData setObject:[infoDictionary objectForKey:@"CFBundleVersion"] forKey:@"ver"];
    [publicData setObject:SDKVER forKey:@"sdkver"];
    [publicData setObject:[self shared].gameID forKey:@"gameid"];
    if ([self shared].uuid)
    {
        [publicData setObject:[self shared].uuid forKey:@"uuid"];
    }
//    else
//    {
//        [publicData setObject:[CSGameModel UUID:[self shared].gameID] forKey:@"uuid"];
//    }
    if ([self shared].ad_param)
    {
        [publicData setObject:[self shared].ad_param forKey:@"ad_param"];
    }
    if ([self shared].referer_param)
    {
        [publicData setObject:[self shared].referer_param forKey:@"referer_param"];
    }
    return publicData;
}

+(NSString *)UUID:(NSString *)gameid
{
    NSString *uuid = [CSSSKeychain passwordForService:gameid account:gameid];
    if (uuid&&uuid.length > 4)
    {
        return uuid;
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    [CSSSKeychain setPassword:uuid forService:gameid labl:gameid  account:gameid];
    return uuid;
    
}

+(NSString *)ParameterSignWithTimestamp:(NSString *)timestamp
{
    return [self md5:[NSString stringWithFormat:@"%@%@%@%@%@",@"whatthefuckakeytj9377jkl",[self shared].gameID,[self deviceImei],[self shared].gameReferer,timestamp]];
     
}

+(NSString *)deviceImei
{
    if ([self shared].device_imei)
    {
        return [self shared].device_imei;
    }
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

//将设备UDID md5加密 提取出数字  取后8位
+(NSString *)TouristsLoginAccount
{
    NSString *TouristsLoginAccount =   [[NSUserDefaults standardUserDefaults] objectForKey:@"TouristsLoginAccount"];
    if (TouristsLoginAccount.length >1)
    {
        return TouristsLoginAccount;
    }
    NSString * str = [self md5:[self deviceImei]];
    NSString * character;
    NSString * resultsStr = @"";
    for (int i = 0; i<str.length; i++)
    {
        character = [str substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqual:@"0"] || [character isEqual:@"1"] || [character isEqual:@"2"] || [character isEqual:@"3"] || [character isEqual:@"4"] || [character isEqual:@"5"] || [character isEqual:@"6"] || [character isEqual:@"7"] || [character isEqual:@"8"] || [character isEqual:@"9"])
        {
            resultsStr = [resultsStr stringByAppendingString:character];
        }
    }
    return [resultsStr substringWithRange:NSMakeRange(resultsStr.length - 8, 8)];
}
+(NSString *)Model
{
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
        return platform;
        //
        //    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
        //    free(machine);
        
//        if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
//        if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
//        if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
//        if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
//        if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
//        if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
//        if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
//        if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
//        if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
//        if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
//        if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
//        if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
//        if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
//        if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
//        if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
//        
//        if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
//        if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
//        if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
//        if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
//        if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
//        
//        if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
//        
//        if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
//        if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
//        if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
//        if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
//        if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
//        if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
//        if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
//        
//        if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
//        if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
//        if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
//        if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
//        if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
//        if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
//        
//        if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
//        if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
//        if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
//        if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
//        if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
//        if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
//        if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air2";
//        if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air2 4G";
//        if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
//        if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
//        return platform;
}

+(NSString *)ScreenReslution
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    return [NSString stringWithFormat:@"%0.0f*%0.0f",screenRect.size.width,screenRect.size.height];
}

+(NSString *)SystemName
{
    return [[UIDevice currentDevice] systemName];
}

+(NSString *)CurrentOperators
{
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier * carrier = [info subscriberCellularProvider];
    if (carrier)
    {
        if (carrier.carrierName)
        {
            return carrier.carrierName;
        }
        
    }
    return @"unknown";
}

+(NSString *)CurrentNetType
{
    CSReachability *rea = [CSReachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([rea currentReachabilityStatus])
    {
        case ReachableViaWiFi:
        {
            return @"WIFI";
        }
            break;
        case ReachableViaWWAN:
        {
            return @"WWAN";
        }
            break;
        default:
        {
            return @"unknown";
        }
            break;
    }
    return @"unknown";
}

//OTA
+ (NSString *)RePath:(NSString *)urlpath WithFormat:(NSString *)string,... NS_REQUIRES_NIL_TERMINATION
{
    va_list   arg_ptr;
    id nArgValue = string;
    int   nArgCout=0;           //可变参数的数目
    va_start(arg_ptr,string);   //以固定参数的地址为起点确定变参的内存起始地址。
    do{
        urlpath = [urlpath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"{%d}",nArgCout] withString:[self URLEncodedString:[NSString stringWithFormat:@"%@",nArgValue]]];
        ++nArgCout;
        nArgValue   =   va_arg(arg_ptr,id);  //得到下一个可变参数的值
        
    }while(nArgValue != nil);
    return urlpath;
}


+ (NSString *)md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


//加密
+(NSString *)EnCodeStringWithResult:(NSString *)result
{
    if (result)
    {
        NSString * str = [[result dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"|"];
        int n = (arc4random() % 8) + 1;
        NSString *time = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
        NSString *key = [[self md5:time] substringWithRange:NSMakeRange(0,n)];
        str = [NSString stringWithFormat:@"%@%@%d",key,str,n];
        str = [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"|"];
        n = (arc4random() % 8) + 1;
        time = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
        key = [[self md5:time] substringWithRange:NSMakeRange(0,n)];
        str = [NSString stringWithFormat:@"%d%@%@",n,str,key];
        return str;
    }
    return nil;
}
//获取游戏列表参数格式化
+(NSString *)URLWithDict:(NSMutableDictionary *)dict AndHost:(NSString *)host
{
    NSMutableString *lostr = [[NSMutableString alloc]init];
    NSMutableString *destr = [[NSMutableString alloc]init];
    [lostr appendString:host];
    if (dict)
    {
        NSArray *array = [dict allKeys];
        for (int i = 0; i < [array count]; i++)
        {
            NSString *key = [array objectAtIndex:i];
            NSString *va = [dict objectForKey:key];
            [destr appendString:key];
            [destr appendString:@"="];
            [destr appendString:[NSString stringWithFormat:@"%@",va]];
            if (i != ([array count] - 1))
            {
                [destr appendString:@"&"];
            }
        }
        CSSBJson4Writer *writer = [[CSSBJson4Writer alloc]init];
        NSString *data = [writer stringWithObject:dict];
        destr = [[NSMutableString alloc]init];
        [destr appendFormat:@"?data=%@",[self EnCodeStringWithResult:data]];
    }
    NSString *encodedValue = [self URLEncodedString:destr];
    [lostr appendString:encodedValue];
    return lostr;
}

+ (NSString *)URLEncodedString:(NSString *)string
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorSystemDefault,
                                                              (CFStringRef)string,
                                                              NULL,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


+(NSString *)CSGTMBase64WithString:(NSString *)string
{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [CSGTMBase64 decodeData:data];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

//解密
+(NSString *)DecodeStringWithStr:(NSString *)resultsStr
{
    if (resultsStr.length > 0 )
    {
        int n = [[resultsStr substringWithRange:NSMakeRange(0,1)] intValue];
        if (n == 0 )
        {
            return nil;
        }
        NSMutableString *str = [[NSMutableString alloc]initWithString:resultsStr];
        [str deleteCharactersInRange:NSMakeRange(0,1)];
        [str deleteCharactersInRange:NSMakeRange(str.length - n, n)];
        NSString *restr  = [NSString stringWithFormat:@"%@",str];
        restr = [restr stringByReplacingOccurrencesOfString:@"|" withString:@"="];
        NSString *base = [self CSGTMBase64WithString:restr];
        n = [[base substringWithRange:NSMakeRange(base.length-1,1)] intValue];
        if (n == 0 )
        {
            return nil;
        }
        str = [[NSMutableString alloc]initWithString:base];
        [str deleteCharactersInRange:NSMakeRange(0,n)];
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
        restr  = [NSString stringWithFormat:@"%@",str];
        restr = [restr stringByReplacingOccurrencesOfString:@"|" withString:@"="];
        base = [self CSGTMBase64WithString:restr];
        return base;
    }
    return nil;
}

+(NSString *)getRefererparam
{
    return @"";
   
}



+(BOOL)saveIAP:(NSMutableDictionary *)iapDict
{
    NSMutableArray *array = [self AllIAP];
    
    NSMutableArray *placesT = nil;
    
    
    if (array) {
        placesT = [array mutableCopy];
    } else {
        placesT = [[NSMutableArray alloc] init];
    }
    
    [placesT addObject:iapDict];
    
    [[NSUserDefaults standardUserDefaults] setObject:placesT forKey:@"CSIAP"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)reMoveIAP:(NSMutableDictionary *)iapDict
{
    NSMutableArray *placesT = [self AllIAP];
    NSMutableArray *array = nil;
    
    if (placesT)
    {
        array = [placesT mutableCopy];
    }
    else
    {
        return NO;
    }
    
    NSMutableIndexSet *index = [[NSMutableIndexSet alloc]init];
    for (int i=0; i< array.count; i++)
    {
        NSMutableDictionary *iap = array[i];
        if ([[iap objectForKey:@"sign"] isEqualToString:[iapDict objectForKey:@"sign"]])
        {
            [index addIndex:i];
        }
    }
    
    [array removeObjectsAtIndexes:index];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"CSIAP"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSMutableArray *)AllIAP
{
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"CSIAP"];
    
}


+(NSMutableDictionary *)IAPDict:(SKProduct*)product withSKPaymentTransaction:(SKPaymentTransaction*)tran
{
    
    
    NSMutableDictionary * publicData = [NSMutableDictionary dictionary];
    NSMutableString *strall = [[NSMutableString alloc]init];
    
    NSMutableArray *keyarray;
    //    uuid
    if ([self shared].uuid)
    {
        [publicData setObject:[self shared].uuid forKey:@"uuid"];
        [strall appendString:[self shared].uuid];
        keyarray = [[NSMutableArray alloc]initWithObjects:@"uuid",@"idfa",@"locale",@"sandbox",@"price",@"game_id",@"server",@"username",@"currency",@"data",@"sign", nil];
        
    }
    else
    {
        keyarray = [[NSMutableArray alloc]initWithObjects:@"idfa",@"locale",@"sandbox",@"price",@"game_id",@"server",@"username",@"currency",@"data",@"sign", nil];
    }
    
    
    //    idfa
    
    [publicData setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"idfa"];
    
    //    currency
    NSLocale *priceLocale = [product priceLocale];
    [publicData setObject:[priceLocale objectForKey:NSLocaleLanguageCode] forKey:@"currency"];
    //    sandbox
    
#ifdef DEBUG
    [publicData setObject:[NSNumber numberWithBool:YES] forKey:@"sandbox"];
#else
    [publicData setObject:[NSNumber numberWithBool:NO] forKey:@"sandbox"];
#endif
    
    
    
    //    price
    [publicData setObject:[CSGameModel shared].price forKey:@"price"];
    //    game_id
    [publicData setObject:[self shared].gameID forKey:@"game_id"];
    //    server
    if ([CSGameModel shared].serverType) //9377服务区
    {
        [publicData setObject:[NSString stringWithFormat:@"%@",[CSGameModel shared].server] forKey:@"server"];
    }
    else
    {
        [publicData setObject:[NSString stringWithFormat:@"%@",[CSGameModel shared].server] forKey:@"_server"];
        keyarray = [[NSMutableArray alloc]initWithObjects:@"uuid",@"idfa",@"locale",@"sandbox",@"price",@"game_id",@"_server",@"username",@"currency",@"data",@"sign", nil];
    }
    
    //    username
    [publicData setObject:[self shared].UserName forKey:@"username"];
    //    locale
    NSString *displayName = [priceLocale displayNameForKey:NSLocaleCountryCode value:[priceLocale objectForKey:NSLocaleCountryCode]];
    [publicData setObject:[displayName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"locale"];
    //    data
    
    
    //    NSString * productIdentifier = tran.payment.productIdentifier;
    
    NSString *transactionReceiptString= nil;
    
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    [publicData setObject:tran.transactionIdentifier forKey:@"transaction_id"];
    if([[UIDevice currentDevice].systemVersion doubleValue]>=7.0)
        
    {
        NSURLRequest*appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
        NSError *error = nil;
        NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSLog(@"re applicationUsername:%@",tran.payment.applicationUsername);
        [[CSGameModel shared].extrainStrlogo  appendString:@":苹果返回"];
        if (tran.payment.applicationUsername)
        {
            [publicData setObject:tran.payment.applicationUsername forKey:@"extra_info"];
            [[CSGameModel shared].extrainStrlogo  appendString:@":设置上报透传"];
            [[CSGameModel shared].extrainStrlogo  appendString:tran.payment.applicationUsername];
        }
        else
        {
            if ([CSGameModel shared].extrainStr)
            {
                [publicData setObject:[CSGameModel shared].extrainStr forKey:@"extra_info"];
                [[CSGameModel shared].extrainStrlogo  appendString:@":设置透传"];
                [[CSGameModel shared].extrainStrlogo  appendString:[CSGameModel shared].extrainStr];
            }
        }
        
        
    }
    else
    {
        NSData * receiptData = tran.transactionReceipt;
        transactionReceiptString = [CSGTMBase64 stringByEncodingData:receiptData];
        if ([CSGameModel shared].extrainStr)
        {
            [publicData setObject:[CSGameModel shared].extrainStr forKey:@"extra_info"];
            [[CSGameModel shared].extrainStrlogo  appendString:@":ios6设置透传"];
            [[CSGameModel shared].extrainStrlogo  appendString:[CSGameModel shared].extrainStr];
        }
        
    }
    if (transactionReceiptString)
    {
        [publicData setObject:transactionReceiptString forKey:@"data"];
    }
    else
    {
        return nil;
    }
    
    [strall appendString:[publicData objectForKey:@"idfa"]];
    [strall appendString:[publicData objectForKey:@"locale"]];
    [strall appendString:[NSString stringWithFormat:@"%d",[[publicData objectForKey:@"sandbox"] intValue]]];
    [strall appendString:[NSString stringWithFormat:@"%0.0f",[[publicData objectForKey:@"price"] floatValue]]];
    [strall appendString:[publicData objectForKey:@"game_id"]];
    if ([CSGameModel shared].serverType) //9377服务区
    {
        //        [publicData setObject:[NSString stringWithFormat:@"%@",[CSGameModel shared].server] forKey:@"server"];
        [strall appendString:[publicData objectForKey:@"server"]];
    }
    else
    {
        //        [publicData setObject:[NSString stringWithFormat:@"%@",[CSGameModel shared].server] forKey:@"_server"];
        [strall appendString:[publicData objectForKey:@"_server"]];
    }
    
    [strall appendString:[publicData objectForKey:@"username"]];
    [strall appendString:[publicData objectForKey:@"currency"]];
    [strall appendString:[publicData objectForKey:@"data"]];
    
    
    [strall appendString:@"i4psu.@ckm$yb4%11s"];
    NSString *sign = [self md5:strall];
    [publicData setObject:sign forKey:@"sign"];
    [publicData setObject:[CSGameModel shared].extrainStrlogo forKey:@"extra_logo"];
    return  publicData;
}

+(BOOL)iscomment:(NSString*)commentversion
{
    NSString *sdkcomment = [[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_comment"];
    if (sdkcomment.length == 0)
    {
        return YES;
    }
    if ([commentversion intValue]> [sdkcomment intValue])
    {
        return YES;
    }
    return NO;
}

+(void)comment:(NSString *)commentversion
{

    [[NSUserDefaults standardUserDefaults] setObject:commentversion forKey:@"sdk_comment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)isShowPoCM
{
//    return YES;
    if ([CSGameModel shared].PointDict)
    {
        NSString *sdkcomment = [[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_pover"];
        if (!sdkcomment)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"sdk_pover"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        int loclpover =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_pover"] intValue];
        int serverpover = [[[CSGameModel shared].PointDict objectForKey:@"ext1"] intValue];
        if (serverpover>loclpover)
        {
            return YES;
        }
        else if(serverpover == loclpover)
        {
            int poshowserver = [[[CSGameModel shared].PointDict objectForKey:@"ext3"] intValue];
            NSString *poshowlock = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d_sdkpover",serverpover]];
            if (!poshowlock)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d_sdkpover",serverpover]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            int loclposhow =  [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d_sdkpover",serverpover]] intValue];
            if (loclposhow < poshowserver)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
        
    }
    return NO;
}
+(void)ShowPoCm
{
    if ([CSGameModel shared].PointDict)
    {

        
        int serverpover = [[[CSGameModel shared].PointDict objectForKey:@"ext1"] intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:serverpover] forKey:@"sdk_pover"];

        
        int loclposhow =  [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d_sdkpover",serverpover]] intValue];
        loclposhow+=1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:loclposhow] forKey:[NSString stringWithFormat:@"%d_sdkpover",serverpover]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    }


+(void)EndShowPoCm
{
    if ([CSGameModel shared].PointDict)
    {
        int serverpover = [[[CSGameModel shared].PointDict objectForKey:@"ext1"] intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:serverpover] forKey:@"sdk_pover"];
        int poshowserver = [[[CSGameModel shared].PointDict objectForKey:@"ext3"] intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:poshowserver] forKey:[NSString stringWithFormat:@"%d_sdkpover",serverpover]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}


+(BOOL)isShowRedPoint
{
    if ([CSGameModel shared].PointDict)
    {
        int serverpover = [[[CSGameModel shared].PointDict objectForKey:@"ext1"] intValue];
        NSString *loclred = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d_sdkpovered",serverpover]];
        if (loclred.length >0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

+(void)endShowRedPoint
{
    if ([CSGameModel shared].PointDict)
    {
        NSString* serverpover = [[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_pover"];
        [[NSUserDefaults standardUserDefaults] setObject:@"showed" forKey:[NSString stringWithFormat:@"%@_sdkpovered",serverpover]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


+(CGPoint)PointBar
{
    return CGPointMake([[[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_pointx"] floatValue], [[[NSUserDefaults standardUserDefaults] objectForKey:@"sdk_pointy"] floatValue]);
}
+(void)UserPointBar:(CGPoint)point
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:point.x] forKey:@"sdk_pointx"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:point.y] forKey:@"sdk_pointy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)isInjoinNotify:(NSString*)notify
{
    NSString* locnotify = [[NSUserDefaults standardUserDefaults] objectForKey:notify];
    if ([locnotify isEqualToString:notify])
    {
        return NO;
    }
    return YES;
}
+(void)injoinNotify
{
    if ([CSGameModel shared].NotifiyDict)
    {
        NSString *ext3str = [[CSGameModel shared].NotifiyDict objectForKey:@"ext3"];
        NSString *ext8str = [[CSGameModel shared].NotifiyDict objectForKey:@"ext8"];
        NSString *notfyver = [NSString stringWithFormat:@"%@%@%@",[CSGameModel shared].UserName,ext3str,ext8str];
        [[NSUserDefaults standardUserDefaults] setObject:notfyver forKey:notfyver];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end




