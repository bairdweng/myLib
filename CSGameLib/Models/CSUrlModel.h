//
//  CSUrlModel.h
//  CSgameSDKDemo
//
//  Created by FreeGeek on 15/6/15.
//  Copyright (c) 2015年 xiezhongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark 手机助手统计


//请求验证码
//http://wvw.9377.cn/api/register.php?cellphone=1&return_json=1&send_captcha=1&username=18122308590
//
//使用验证码登录
//http://wvw.9377.cn/api/register.php?cellphone=1&return_json=1&username=18122308590&captcha=xxx



extern NSString * const CSGame_URL_NewBase;
//获取用户名称
extern NSString * const CSGame_URL_IMEI;
//激活
extern NSString * const SJZS_URL_Activation;
//数据采集
extern NSString * const SJZS_URL_EnterData;
//注册
extern NSString * const SJZS_URL_Register;
//登录
extern NSString * const SJZS_URL_Login;
//支付
extern NSString * const SJZS_URL_Pay;

#pragma mark 统计激活
/**
 *  @brief  统计激活
 */
extern NSString * const CSGame_URL_Statistical;

#pragma mark 注册
/**
 *  @API  注册       POST
 *  @par  username  注册用户名(4-20位)
 *  @par  password  注册密码
 *  @par  return_json 1
 */
extern NSString * const CSGame_URL_Register;

#pragma mark 登录
/**
 *  @API  登录       POST
 *  @par  username  用户名
 *  @par  password  密码
 *  @par  return_json  1
 */
extern NSString * const CSGame_URL_Login;

#pragma mark 登出
/**
 *  @API  用户注销   GET
 *  @par  do         logout
 *  @par  return_json 1
 */
extern NSString * const CSGame_URL_Logout;

#pragma mark 登录校验
/**
 *  @API  登录校验     GET
 *  @par  session_id 发送有户名和密码返回的session_id
 */
extern NSString * const CSGame_URL_Enter;

#pragma mark 修改密码
/**
 *  @API  修改密码   POST
 *  @par  do         pwd_up
 *  @par  password   新密码
 *  @par  password1  重复
 *  @par  password_old  旧密码
 */
extern NSString * const CSGame_URL_ChangePassword;

#pragma mark 获取验证码
/**
 *  @API  手机绑定-获取手机验证码    POST
 *  @par  do         bind_cellphone
 *  @par  step       1
 *  @par  cellphone  手机号码 11位数字
 */
extern NSString * const CSGame_URL_BindPhone;

#pragma mark 绑定手机
/**
 *  @API  手机绑定/解绑   POST
 *  @par  do         bind_cellphone
 *  @par  step       2
 *  @par  cellphone  手机号码 11位数字
 *  @par  captcha    验证码
 *  @par  unbind     默认0 (0绑定 1解绑)
 */
extern NSString * const CSGame_URL_RemoveBindPhone;

#pragma mark 用户信息
/**
 *  @API  用户信息   POST
 *  @par  return_json 1
 */
extern NSString * const CSGame_URL_UserInfo;

#pragma mark 发送验证码--找回密码
/**
 *  @API  找回密码-手机方式-发送验证码  POST
 *  @par  do         cellphone
 *  @par  step       2
 *  @par  username   用户名
 *  @par  return_json  1
 */
extern NSString * const CSGame_URL_RetrievePwdWithbindPhone;

#pragma mark 校验验证码--找回密码
/**
 *  @API  找回密码-手机方式-校验验证码  POST
 *  @par  do         cellphone
 *  @par  step       4
 *  @par  captcha    验证码
 *  @par  return_josn  1
 */
extern NSString * const CSGame_URL_RetrievePwdWithVerificationCode;

#pragma mark 提交新密码--找回密码
/**
 *  @API  找回密码-手机方式-提交新密码  POST
 *  @par  do         cellphone
 *  @par  step       6
 *  @par  password   密码
 *  @par  Password2  确认密码
 *  @par  return_json 1
 */
extern NSString * const CSGame_URL_RetrievePwdWithSubmitNewPwd;

#pragma mark 绑定邮箱
/**
 *  @brief  绑定邮箱
 *  @par    do      userinfo_up
 *  @par    email   邮箱地址
 */
extern NSString * const CSGame_URL_BindEmail;

#pragma mark 邮箱找回密码
/**
 *  @API  找回密码-邮件方式    POST
 *  @par  do         getpass_email
 *  @par  username   用户名
 *  @par  email      邮件
 *  @par  return_json  1
 */
extern NSString * const CSGame_URL_RetrievePwdWithEmail;

#pragma mark 游戏列表
/**
 *  @API  游戏列表
 *  @par  data       参数加密串(以下参数进行加密)
 *  @par  protocol   协议参数
 *  @par  rows       fanhi多少行数据
 *  @par  page       当前页
 *  @par  toll       0两者不区分; 1:收费 2:免费
 *  @par  prison     0两者不区分; 1:越狱 2:非越狱
 *  @par  dev        0不区分   1:iphone  2:ipad
 *  @par  apptype    0不区分   1:游戏   2:应用----2
 *  @par  typeid     游戏分类id,应用分类id
 *  @par  special    专题id
 *  @par  column     栏目id
 *  @par  type       hot(热度)
 */
extern NSString * const CSGame_URL_GameList;

#pragma mark 支付请求
/**
 *  @API  支付请求     POST
 *  @par  username   用户名
 *  @par  game       游戏简称 如:ly
 *  @par  server     游戏服务区号
 *  @par  _server    开发商服务器区号
 *  @par  amount     订单总额 玩家付款RMB金额(元)
 *  @par  uni        手机设备号
 *  @par  extra_info 透传参数（原样返回合作商自定义的数据）　长度varchar(255)
 */
extern NSString * const CSGame_URL_Pay;

/**
 *  @API  找回密码-手机方式-发送短信   POST
 *  @par  do         cellphone
 *  @par  step       3
 *  @par  return_json   1
 */
extern NSString * const CSGame_URL_RetrievePwdWithSendMessage;

extern NSString * const CSGame_URL_Statistical;

/**
 *  @API  在线客服   GET
 */
extern NSString * const CSGame_URL_OnlineSport;




/**
 *  @API  支付回调     GET
 *  @par  key        18gqSh1XQSwtqAj09JU-zeb)c78MkRaK
 *  @par  user_id    9377用户ID
 *  @par  username   用户名
 *  @par  game       游戏简称 如:ly
 *  @par  order_amount   订单总额 玩家付款RMB金额
 *  @par  order_id   订单ID 银行回调ID
 *  @par  server_id  9377游戏服务区号
 *  @par  extra_info 透传参数（原样返回合作商自定义的数据）　长度varchar(255)
 *  @par  sign       签名 md5(user_id+username+game+order_amount+order_id +server_id+key)
 */
extern NSString * const CSGame_URL_Topup;








#pragma mark 10







/**
 *  @API  找回密码-密保找回  POST
 *  @par  do         answer
 *  @par  username   用户名
 *  @par  password   密码
 *  @par  Password1  重复密码
 *  @par  question   问题
 *  @par  answer     答案
 *  @par  return_json 1
 */
extern NSString * const CSGame_URL_RetrievePwdWithencrypted;

/**
 *  @API  设置密码问题和答案   POST
 *  @par  do         ped_bh
 *  @par  question   问题
 *  @par  answer     答案
 *  @par  old_answer 旧答案(如果用户已设置过密保)
 */
extern NSString * const CSGame_URL_SetEncrypted;



/**
 *  @API  修改用户信息   POST
 *  @par  do         userinfo_up
 *  @par  qq         qq
 *  @par  sex        性别 男 1 女 0
 *  @par  births     生日
 *  @par  email      电子邮件(只能修改一次)
 *  @par  name       真是姓名(只能修改一次)
 *  @par  idCardNumber 身份证(只能修改一次)
 */
extern NSString * const CSGame_URL_ChangeUserInfo;

/**
 *  @API  设置用户昵称   POST
 *  @par  do         bbs_up
 *  @par  nickname   昵称
 */
extern NSString * const CSGame_URL_SetUserName;

/**
 *  @API  修改用户头像   POST
 *  @par  data        图像base64
 */
extern NSString * const CSGame_URL_SetUserHeader;


#pragma mark 20


/**
 *  @API  用户登录IP记录   POST
 *  @par  do    ip_action
 */
extern NSString * const CSGame_URL_IPRecord;

/**
 *  @API  活动-特权-获取所有游戏(新页游与手游)   GET
 */
extern NSString * const CSGame_URL_GetAllGameActivity;

/**
 *  @API  活动-特权-获取所有游戏(分类排序)   GET
 *  @par  type   yy 页游 如: http://wvw.9377.cn/api/app.php?do=all-game-new&type=yy
 */
extern NSString * const CSGame_URL_GetAllGameActivityClassification;

/**
 *  @API  活动-特权-获取指定游戏礼包(新页游与手游)   GET
 *  @par  do        all-getcard
 *  @par  id        游戏ID 如:30001
 *  @par  category  游戏分类 如:yy/sy(页游/手游)
 */
extern NSString * const CSGame_URL_GetSpecifiedGameGift;

/**
 *  @API  活动-特权-获取指定游戏礼包-详细页面(新页游和手游)   GET
 *  @par  do        all-getcard-page
 *  @par  game      游戏简称 如:ly
 *  @par  game_id   游戏ID 如:30001
 *  @par  category  游戏分类 如:yy/sy(页游/手游)
 *  @par  card_id   卡ID 如:283
 *  @par  all_server 是否全服通用 0:否  1:是
 */
extern NSString * const CSGame_URL_GetSpecifiedGameGiftDetailPage;

/**
 *  @API  活动-获取所有活动(游戏目录)   GET
 *  @par  do        huodong
 */
extern NSString * const CSGame_URL_GetAllActivity;

/**
 *  @API  活动-获取所有活动(游戏目录下的列表)   GET
 *  @par  do        huodong_game_list
 *  @par  id        游戏目录ID
 */
extern NSString * const CSGame_URL_GetAllActivityList;

/**
 *  @API  活动-获取所有活动(游戏目录下的列表 根据游戏名称)   GET
 *  @par  do        huodong_game_query
 *  @par  q         游戏名称 如:烈焰
 */
extern NSString * const CSGame_URL_GetAllActivityListAccordingGameName;

/**
 *  @API  解除用户IP异常状态   GET
 */
extern NSString * const CSGame_URL_RemoveUserIPAbnormal;

#pragma mark 30

/**
 *  @API  当前版本   GET
 */
extern NSString * const CSGame_URL_CurrentVersion;

/**
 *  @API  游戏plist   GET
 */
extern NSString * const CSGame_URL_GamePlist;

/**
 *  @API  QQ登录   GET
 *  @par  _qq_action   login
 *  @par  app          1
 *  @par  _9377_param  game_id=30001&server=1&referer=9377
 *  eg    http://wvw.9377.cn/api/qq.php?_qq_action=login&app=1&_9377_param=game_id%3D30001%26server%3D1%26referer%3D9377
 */
extern NSString * const CSGame_URL_QQLogin;

/**
 *  @API  数据统计-激活统计   GET
 *  @par  referer      渠道 如:9377
 *  @par  imei         手机唯一标示
 *  @par  game_id      游戏ID
 *  @par  sign         签名 md5($referer.$game_id.$imei.$key)
 *  @par  type         数据类别 1/2  ios/android
 *  eg: key: whatthefuckakey1931csez
 */
extern NSString * const CSGame_URL_DataStatistics;

/**
 *  @API  游戏客服信息   GET
 */
extern NSString * const CSGame_URL_GameServiceInformation;

/**
 *  @API  获取游戏下载链接   GET
 */
extern NSString * const CSGame_URL_GetGameDownloadLink;


extern NSString * const  CSGame_URL_PayIAP;


