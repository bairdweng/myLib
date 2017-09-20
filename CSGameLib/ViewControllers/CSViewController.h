

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface CSViewController : UIViewController
@property (strong, nonatomic) UIWebView *GameWeb;
@property (nonatomic, strong) JSContext *context;
@property (strong, nonatomic) UIImageView *LoadImage;
@property (nonatomic, assign) BOOL dissAutoLoad;
- (void)reloadDataBySelf;
@end

