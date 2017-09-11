

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface MBViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) NSString *MBStr;
@property (nonatomic, strong) JSContext *context;
@end
