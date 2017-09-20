//
//  CSWKWebViewController.h
//  CSGameLib
//
//  Created by Baird-weng on 2017/9/19.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface CSWKWebViewController : UIViewController
@property (strong, nonatomic) WKWebView *GameWeb;
@property (nonatomic, strong) JSContext *context;
@property (strong, nonatomic) UIImageView *LoadImage;
@property (nonatomic, assign) BOOL dissAutoLoad;
- (void)reloadDataBySelf;
@end
