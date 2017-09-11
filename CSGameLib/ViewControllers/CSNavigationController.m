 

#import "CSNavigationController.h"
#import "CSGameModel.h"

@interface CSNavigationController ()

@end

@implementation CSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
#ifdef __IPHONE_6_0
    if ([CSGameModel shared].mask !=0)
    {
        return [CSGameModel shared].mask;
    }
    else
    {
        UIInterfaceOrientation currentOrient = [UIApplication  sharedApplication].statusBarOrientation;
        if (currentOrient == UIInterfaceOrientationLandscapeLeft||UIInterfaceOrientationLandscapeRight == currentOrient)
        {
            return UIInterfaceOrientationMaskLandscape;
        }else{
            return UIInterfaceOrientationMaskPortrait;
        }
    }
#endif
}
@end
