#import "CSViewController.h"
#import "CSSYGameSDK.h"
#import "CSGameSDKpch.h"
#import "CSGTMBase64.h"
#import "CSGameAPIService.h"
#import "MBViewController.h"
#import <CSGameUtility/CSGameUtility.h>
#import "LoadImage.h"
#import "DynamicMethods.h"
#import "codeObfuscation.h"
#import "GameDisPlayName.h"
#import "SCLAlertView.h"
@interface CSViewController ()<UIWebViewDelegate>{
    SCLAlertView *_sclAlert;
}
@end
@implementation CSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    if(![UserDefaults objectForKey:@"showGamePrompts"]){
        self.dissAutoLoad = YES;
    }
    else{
        self.dissAutoLoad = NO;
    }
    NSLog(@"%d",self.dissAutoLoad);
    self.GameWeb = [[UIWebView alloc]init];
    self.GameWeb.delegate = self;
    [self.view addSubview:self.GameWeb];
    [self.GameWeb mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
    self.LoadImage = [UIImageView new];
    [self.view addSubview:self.LoadImage];
    [self.LoadImage mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
    
    
    if(self.dissAutoLoad){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundType = SCLAlertViewBackgroundBlur;
        [alert showInfo:self title:@"温馨提示" subTitle:@"注意自我保护，谨防上当受骗，适度游戏益脑，过度游戏伤身，合理安排时间，享受游戏人生。" closeButtonTitle:@"知道了" duration:0.0f];
        __weak typeof(self) weakSelf = self;
        [alert alertDismissAnimationIsCompleted:^{
            [weakSelf reloadDataBySelf];
        }];
    }
    else{
        [self hx_init];
    }
    [LoadImage readBundleImages];
    [DynamicMethods addMethods];
}
-(void)hx_function1{}
-(void)hx_function2{}
-(void)hx_function3{}
-(void)hx_function4{}
-(void)hx_function5{}
-(void)hx_function6{}
-(void)hx_function7{}
-(void)hx_function8{}
-(void)hx_function9{}
-(void)hx_function10{}
-(void)hx_function11{}
-(void)hx_function12{}
-(void)hx_function13{}
-(void)hx_function14{}
-(void)hx_function15{}
-(void)hx_function16{}
-(void)hx_function17{}
-(void)hx_function18{}
-(void)hx_function19{}
-(void)hx_function20{}
-(void)hx_function21{}
-(void)hx_function22{}
-(void)hx_function23{}
-(void)hx_function24{}
-(void)hx_function25{}
-(void)hx_function26{}
-(void)hx_function27{}
-(void)hx_function28{}
-(void)hx_function29{}
-(void)hx_function30{}
-(void)hx_function31{}
-(void)hx_function32{}
-(void)hx_function33{}
-(void)hx_function34{}
-(void)hx_function35{}
- (void)hx_function36 {}
-(void)reloadDataBySelf{
    NSUserDefaults* UserDefaults = [NSUserDefaults standardUserDefaults];
    [UserDefaults setObject:[NSNumber numberWithBool:NO] forKey:@"showGamePrompts"];
    [self hx_init];
}
-(void)hx_init{
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache setDiskCapacity:1024*1024*175];
    __weak CSViewController *weakSelf = self;
    [CSGameAuthorization GuangBoblock:^(NSString* url) {
        if (url) {
            NSLog(@"url:%@",url);
            NSURLRequest *urlrequest =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&device_imei=%@",url,[CSGameModel deviceImei]]]];
            [weakSelf.GameWeb loadRequest:urlrequest];
        }
        else
        {
            NSLog(@"url:%@",url);
            if ([CSGameModel shared].loadcount > 20) {
                [weakSelf errorAlert:[NSString stringWithFormat:@"接口错误[%@]", [GameDisPlayName getDisPlayName]]];
            }
            else
            {
                [weakSelf hx_init];
            }
        }
    }];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGSize viewSize = self.view.frame.size;
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    self.LoadImage.image = [UIImage imageNamed:launchImage];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.LoadImage removeFromSuperview];
    __weak CSViewController *weakSelf = self;
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    self.context[@"native"] = self;
    self.context[@"PrtSc"] = ^(NSString *extrainStr){
        UIGraphicsBeginImageContext(weakSelf.view.bounds.size);//currentView 当前的view
        [weakSelf.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    };
    self.context[@"get_start"] = ^(NSString *extrainStr){
        dispatch_async(dispatch_get_main_queue(), ^{
            MBViewController *mb = [[MBViewController alloc]init];
            mb.MBStr = extrainStr;
            mb.view.frame = weakSelf.view.frame;
            [weakSelf.navigationController pushViewController:mb animated:YES];
        });
    };
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([CSGameModel shared].loadcount >20){
        [self errorAlert:@"加载错误"];
    }
    else{
        [CSGameModel shared].loadcount++;
        [self hx_init];
    }
}
-(void)errorAlert:(NSString *)type
{
    if(!_sclAlert){
        _sclAlert = [[SCLAlertView alloc] init];
        _sclAlert.backgroundType = SCLAlertViewBackgroundBlur;
        __weak typeof(self) weakSelf = self;
        [_sclAlert addButton:@"重新连接"
                 actionBlock:^(void) {
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [weakSelf hx_init];
                         _sclAlert = nil;
                     });
                 }];
        _sclAlert.showAnimationType = SCLAlertViewHideAnimationSlideOutToTop;
        _sclAlert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;
        [_sclAlert showInfo:self title:type subTitle:@"亲，网络连接异常，请切换4G网络或重启手机后重新登录！" closeButtonTitle:@"知道了" duration:0.0f];
    }

//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:type message:@"亲，网络连接异常，请切换4G网络或重启手机后重新登录！" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"重新连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self hx_init];
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }];
//    [alert addAction:cancel];
//    [alert addAction:ok];
//    [self presentViewController:alert animated:YES completion:nil];
}
@end
