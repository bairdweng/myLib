#import "MBViewController.h"
@interface MBViewController ()
@property (strong, nonatomic)  UIWebView *MB;
@end
@implementation MBViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(leftItemAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(RightItemAction)];
    if (!self.MB)
    {
        self.MB = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.MB.delegate = self;
        [self.view addSubview:self.MB];
    }
    if (self.MBStr)
    {
        [self.MB loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.MBStr]]];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}


-(void)leftItemAction
{
    if (self.MBStr)
    {
        [self.MB loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.MBStr]]];
    }
}

-(void)RightItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSString *url = [NSString stringWithFormat:@"%@",request.URL];
    if([url rangeOfString:@"weixin://"].length > 0||[url rangeOfString:@"itms-apps://"].length > 0||[url rangeOfString:@"alipay://"].length > 0||[url rangeOfString:@"mqqapi://"].length > 0)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        
        return NO;
    }
    if ([url rangeOfString:@"/last_server.php"].length>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

        return NO;
        
    }
    
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self viewDidLoad];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    __weak MBViewController *weakSelf = self;
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"exceptionValue --- %@",exceptionValue);
    };
    self.context[@"native"] = self;
    
    self.context[@"get_end"] = ^()
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
