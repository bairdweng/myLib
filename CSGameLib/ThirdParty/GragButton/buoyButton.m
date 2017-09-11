//
//  buoyButton.m
//  buoyButton
//
//  Created by FreeGeek on 15/8/24.
//  Copyright (c) 2015年 FreeGeek. All rights reserved.
//

#import "buoyButton.h"
//#import "CSGameTabBarViewController.h"
#import "CSGameSDKpch.h"
#define CSisiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CSScreenWidth [UIScreen mainScreen].bounds.size.width
#define CSScreenHeight [UIScreen mainScreen].bounds.size.height
#define WindowWidth [UIApplication sharedApplication].keyWindow.bounds.size.width
#define WindowHeight [UIApplication sharedApplication].keyWindow.bounds.size.height
#define LandscapeLeft [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft
#define LandscapeRight [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight
#define LandscapeUpsideDown [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown
#define CSAnimateDuration  0.1
#define CSButtonImageArray @[@"CSSYGameSDK.bundle/userblank.png",@"CSSYGameSDK.bundle/helpblank.png",@"CSSYGameSDK.bundle/gameblank.png"]
#define CSButtonTitleArray @[CSLocalizedStringForKey(@"SDK.buoyButton.Account", nil),CSLocalizedStringForKey(@"SDK.buoyButton.help", nil),CSLocalizedStringForKey(@"SDK.buoyButton.hide", nil)]

#define xCSButtonImageArray @[@"CSSYGameSDK.bundle/userblank.png",@"CSSYGameSDK.bundle/gameblank.png"]
#define xCSButtonTitleArray @[CSLocalizedStringForKey(@"SDK.buoyButton.Account", nil),CSLocalizedStringForKey(@"SDK.buoyButton.hide", nil)]
//#define CSButtonImageArray @[@"CSSYGameSDK.bundle/userblank.png",@"CSSYGameSDK.bundle/helpblank.png"]
//#define CSButtonTitleArray @[@"账号",@"帮助"]
//ios7下 横屏以后坐标系问题的适配
#define DifferenceBetween  [[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && [[UIScreen mainScreen] applicationFrame].size.height == [UIScreen mainScreen].bounds.size.height
#define CSios7 [[UIDevice currentDevice].systemVersion doubleValue] < 8.0
@interface buoyButton()
{
    CGFloat btnSize;                    //浮标按钮尺寸
    CGFloat detailsBtnSize;          //详情按钮尺寸
    CGFloat detailsLabelWidth;     //详情label宽度
    CGFloat detailsLabelHeight;    //详情label高度
    CGFloat showViewWidth;       //展现视图宽度
    CGFloat showViewHeight;      //展现视图宽度
    CGFloat interval;                   //间隔
    UIImageView * showView;
    CGPoint startPoint;
}
@end
static buoyButton * buoyBtn;
@implementation buoyButton

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        if (CSisiPad)
        {
            btnSize = 60;
            detailsBtnSize = 43;
            detailsLabelHeight = 20;
        }
        else
        {
            btnSize = 40;
            detailsBtnSize = 30;
            detailsLabelHeight = 10;
        }
         if ([CSGameModel shared].QTeamWithGameName.length > 0||[CSGameModel shared].isShowGM)
         {
             showViewWidth = 4 * btnSize;
             interval = (showViewWidth - 3 * detailsBtnSize) / 4.0;
         }
        else
        {
            showViewWidth = 3 * btnSize;
            interval = (showViewWidth - 2 * detailsBtnSize) / 3.0;
        }
        
        showViewHeight = btnSize;
        detailsLabelWidth = detailsBtnSize;
        
        UIImage * image;
        if (DifferenceBetween)
        {
            if (LandscapeLeft)
            {
                self.frame = CGRectMake(WindowWidth / 2 - btnSize / 2, 0, btnSize, btnSize);
                image = [UIImage imageWithCGImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"].CGImage scale:1.0 orientation:UIImageOrientationRight];
            }
            if (LandscapeRight)
            {
                self.frame =CGRectMake(WindowWidth / 2 - btnSize / 2, WindowHeight - btnSize, btnSize, btnSize);
                image = [UIImage imageWithCGImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"].CGImage scale:1.0 orientation:UIImageOrientationLeft];
            }
            
        }
        else
        {
            //ios7倒屏
            if (CSios7 && [[UIScreen mainScreen] applicationFrame].size.height != [UIScreen mainScreen].bounds.size.height)
            {
                self.frame =CGRectMake(WindowWidth - btnSize,WindowHeight / 2 - btnSize / 2, btnSize, btnSize);
                image = [UIImage imageWithCGImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"].CGImage scale:1.0 orientation:UIImageOrientationDown];
            }
            else
            {
                if (LandscapeLeft||LandscapeRight)
                {
                    if (CSgame_isiPad)
                    {
                        self.frame =CGRectMake(0, 40 , btnSize, btnSize);
                    }
                    else
                    {
                        self.frame =CGRectMake(0, 0 , btnSize, btnSize);
                    }
                }
                else
                {
                    self.frame =CGRectMake(0, btnSize * 2, btnSize, btnSize);
                }
                
                image = [UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"];
            }
            
        }
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateSelected];
        self.layer.cornerRadius = btnSize / 2;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchButton)];
        [self addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withFrame) name:UIDeviceOrientationDidChangeNotification object:nil];
        if ([CSGameModel isShowPoCM])
        {
            

            self.tipview = [[CSCMPopTipView alloc]initWithMessage:[[CSGameModel shared].PointDict objectForKey:@"title"]];
            self.tipview.dismissTapAnywhere = NO;
            self.tipview.backgroundColor = [UIColor grayColor];
            self.tipview.has3DStyle = NO;
            self.tipview.delegate = self;
        }
        
        
        
        self.redpoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.redpoint.backgroundColor = [UIColor redColor];
        self.redpoint.layer.cornerRadius = 5.0f;
    }
    if ([CSGameModel PointBar].x != [CSGameModel PointBar].y != 0)
    {
        self.center = [CSGameModel PointBar];
    }
    if ([CSGameModel shared].QTeamWithGameName.length > 0||[CSGameModel shared].isShowGM)
    {
        self.ExCSButtonImageArray = [[NSMutableArray alloc]initWithArray:CSButtonImageArray];
        self.ExCSButtonTitleArray = [[NSMutableArray alloc]initWithArray:CSButtonTitleArray];
    }
    else
    {
        self.ExCSButtonImageArray = [[NSMutableArray alloc]initWithArray:xCSButtonImageArray];
        self.ExCSButtonTitleArray = [[NSMutableArray alloc]initWithArray:xCSButtonTitleArray];
    }
    return self;
    
}


- (void)popTipViewWasDismissedByUser:(CSCMPopTipView *)popTipView
{
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
}
- (void)popTipViewWasDismissedByTimer:(CSCMPopTipView *)popTipView
{
     if (showView.bounds.size.width != 0)
     {
         [self TouchButton];
         [self dismissbyTimer];
     }
}

-(void)dismissbyTimer
{
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
    int dissmisssec = [[[CSGameModel shared].PointDict objectForKey:@"ext4"] intValue];
    if (dissmisssec != 0)
    {
        self.autoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:dissmisssec
                                                                 target:self
                                                               selector:@selector(autoDismissAnimatedDidFire)
                                                               userInfo:nil
                                                                repeats:NO];
    }
    
}

-(void)autoDismissAnimatedDidFire
{
    if (DifferenceBetween)  //IOS7横屏
    {
        if (self.center.y < WindowHeight / 2)
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                self.frame = CGRectMake(self.frame.origin.x, 0, btnSize, btnSize);
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                self.frame = CGRectMake(self.frame.origin.x, WindowHeight - btnSize, btnSize, btnSize);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        
        if (self.center.x<WindowWidth / 2)
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
              self.frame =  CGRectMake(0-btnSize/2, self.frame.origin.y, btnSize, btnSize);
//                self.center = CGPointMake(0, self.frame.origin.y);
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
//                self.center = CGPointMake(WindowWidth - btnSize, self.frame.origin.y);
                self.frame = CGRectMake(WindowWidth - btnSize+btnSize/2, self.frame.origin.y, btnSize, btnSize);
            } completion:^(BOOL finished) {
                
            }];
        }
    }

}
-(void)withFrame
{
//    UIImage * image;
//    if (DifferenceBetween)
//    {
//        if (LandscapeLeft)
//        {
////            self.frame = CGRectMake(WindowWidth / 2 - btnSize / 2, 0, btnSize, btnSize);
//            image = [UIImage imageWithCGImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"].CGImage scale:1.0 orientation:UIImageOrientationRight];
//        }
//        else
//        {
////            self.frame = CGRectMake(WindowWidth / 2 - btnSize / 2, WindowHeight - btnSize, btnSize, btnSize);
//            image = [UIImage imageWithCGImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"].CGImage scale:1.0 orientation:UIImageOrientationLeft];
//        }
//    }
//    else
//    {
//        //ios7倒屏
//        if (CSios7 && [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
//        {
////            self.frame = CGRectMake(self.frame.origin.y,self.frame.origin.x, btnSize, btnSize);
//            image = [UIImage imageWithCGImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"].CGImage scale:1.0 orientation:UIImageOrientationDown];
//            //            image = [UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"];
//        }
//        else
//        {
////           self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, btnSize, btnSize);
//            image = [UIImage imageNamed:@"CSSYGameSDK.bundle/dragbutton.png"];
//        }
//    }
//    [self setImage:image forState:UIControlStateNormal];
//    [self setImage:image forState:UIControlStateSelected];
    
//    [self dismissbyTimer];
}

-(void)TouchButton
{
    
//    if (DifferenceBetween)  //IOS7横屏
//    {
//        if (self.center.y < WindowHeight / 2)
//        {
//            [UIView animateWithDuration:CSAnimateDuration animations:^{
//                self.frame = CGRectMake(self.frame.origin.x, 0, btnSize, btnSize);
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
//        else
//        {
//            [UIView animateWithDuration:CSAnimateDuration animations:^{
//                self.frame = CGRectMake(self.frame.origin.x, WindowHeight - btnSize, btnSize, btnSize);
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
//    }
//    else
//    {
//        
//            }

    
    
    
    if (DifferenceBetween) //ios7横屏
    {
        [self DifferenceBetweenShowView];
    }
    else
    {
        if (self.center.x<WindowWidth / 2)
        {
            if (self.frame.origin.x ==0-btnSize/2)
            {
                [UIView animateWithDuration:CSAnimateDuration animations:^{
                                self.frame = CGRectMake(0, self.frame.origin.y, btnSize, btnSize);
//                    self.center = CGPointMake(0, self.frame.origin.y);
                } completion:^(BOOL finished) {
                    [self dismissbyTimer];
                }];
            }
            else
            {
                [self OtherShowView];
            }
            
        }
        else
        {
             if (self.frame.origin.x == WindowWidth - btnSize+btnSize/2)
             {
                 [UIView animateWithDuration:CSAnimateDuration animations:^{
//                     self.center = CGPointMake(WindowWidth - btnSize, self.frame.origin.y);
                                     self.frame = CGRectMake(WindowWidth - btnSize, self.frame.origin.y, btnSize, btnSize);
                 } completion:^(BOOL finished) {
                     [self dismissbyTimer];
                 }];
             }
            else
            {
                [self OtherShowView];

            }
            
        }

        
        
    }
}

-(void)DifferenceBetweenShowView
{
    CGFloat rightButtoninterval;
    if (showView.bounds.size.width == 0)  //视图不存在时,创建视图
    {
        if (self.center.y < WindowHeight / 2) //按钮在左边,视图向右弹出
        {
            
            if (LandscapeRight)
            {
                rightButtoninterval = -5;
                showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/floatViewR.png"]];
            }
            else
            {
                rightButtoninterval = 0;
                showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/floatView.png"]];
            }
            showView.frame = CGRectMake(self.center.x, self.center.y, 0, showViewHeight);
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(self.center.x + btnSize, self.center.y, showViewWidth, showViewHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
        else  //按钮在右边,视图向左弹出
        {
            
            if (LandscapeRight)
            {
                rightButtoninterval = 0;
                showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/floatView.png"]];
            }
            else
            {
                rightButtoninterval = -5;
                showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/floatViewR.png"]];
            }
            showView.frame = CGRectMake(self.center.x, self.center.y - btnSize, 0, showViewHeight);
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(self.center.x - showViewWidth, self.center.y, showViewWidth, showViewHeight);
            } completion:^(BOOL finished) {
            }];
        }
        showView.userInteractionEnabled = YES;
        for (int i = 0; i < self.ExCSButtonImageArray.count; i++)
        {
            UIButton * detailsBtn = [[UIButton alloc]init];
            if (self.center.y < WindowHeight / 2)
            {
                if (LandscapeRight)
                {
                    detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (3 - i) + detailsBtnSize * (2 - i), 0, detailsBtnSize, detailsBtnSize);
                }
                else
                {
                    detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (i + 1) + detailsBtnSize * i, 0, detailsBtnSize, detailsBtnSize);
                }
            }
            else
            {
                if (LandscapeRight)
                {
                    detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (i + 1) + detailsBtnSize * i, 0, detailsBtnSize, detailsBtnSize);
                }
                else
                {
                    detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (3 - i) + detailsBtnSize * (2 - i), 0, detailsBtnSize, detailsBtnSize);
                }
                
            }
            [detailsBtn setImage:[UIImage imageNamed:self.ExCSButtonImageArray[i]] forState:UIControlStateNormal];
            detailsBtn.tag = i;
            [detailsBtn addTarget:self action:@selector(detailsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            showView.layer.masksToBounds = YES;
            [showView addSubview:detailsBtn];
        }
        for (int i = 0; i < self.ExCSButtonTitleArray.count; i++)
        {
            UILabel * detailsLabel = [[UILabel alloc]init];
            if (self.center.y < WindowHeight / 2)
            {
                if (LandscapeRight)
                {
                    detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (3 - i) + detailsLabelWidth * (2 - i), CSisiPad?38:28, detailsLabelWidth, detailsLabelHeight);
                }
                else
                {
                    detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (i + 1) + detailsLabelWidth * i, CSisiPad?38:28, detailsLabelWidth, detailsLabelHeight);
                }
                
            }
            else
            {
                if (LandscapeRight)
                {
                    detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (i + 1) + detailsLabelWidth * i, CSisiPad?38:28, detailsLabelWidth, detailsLabelHeight);
                }
                else
                {
                    detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (3 - i) + detailsLabelWidth * (2 - i), CSisiPad?38:28, detailsLabelWidth, detailsLabelHeight);
                }
                
            }
            detailsLabel.font = [UIFont boldSystemFontOfSize:CSisiPad?14:9];
            detailsLabel.textAlignment = NSTextAlignmentCenter;
            detailsLabel.textColor = [UIColor whiteColor];
            detailsLabel.text = self.ExCSButtonTitleArray[i];
            [showView addSubview:detailsLabel];
        }
        if (self.center.y < WindowHeight / 2)
        {
            if (LandscapeRight)
            {
                showView.center = CGPointMake(self.center.x, self.center.y + showViewHeight / 2 + btnSize * 2);
                showView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }
            else
            {
                showView.center = CGPointMake(self.center.x, self.center.y + showViewHeight / 2 + btnSize * 2);
                showView.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
        }
        else
        {
            if (LandscapeRight)
            {
                showView.center = CGPointMake(self.center.x, self.center.y - showViewHeight / 2 - btnSize * 2);
                showView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }
            else
            {
                showView.center = CGPointMake(self.center.x, self.center.y - showViewHeight / 2 - btnSize * 2);
                showView.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:showView];
    }
    else //视图存在时删除视图
    {
        if (self.center.y < WindowHeight / 2)
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(self.center.x, self.center.y + btnSize / 2, 0, showViewHeight);
            } completion:^(BOOL finished) {
                [showView removeFromSuperview];
                showView = nil;
            }];
        }
        else
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(self.center.x, self.center.y - btnSize * 1.5, 0, showViewHeight);
            } completion:^(BOOL finished) {
                [showView removeFromSuperview];
                showView = nil;
            }];
        }
    }
    
}

-(void)OtherShowView
{
    CGFloat rightButtoninterval;
    if (showView.bounds.size.width == 0)  //视图不存在时,创建视图
    {
        [self.autoDismissTimer invalidate];
        self.autoDismissTimer = nil;
        if (self.center.x < WindowWidth / 2) //按钮在左边,视图向右弹出
        {
            rightButtoninterval = 0;
            showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/floatView.png"]];
            showView.frame = CGRectMake(self.frame.origin.x + btnSize, self.frame.origin.y, 0, showViewHeight);
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(self.frame.origin.x + btnSize, self.frame.origin.y, showViewWidth, showViewHeight);
            } completion:^(BOOL finished) {
                if ([CSGameModel isShowPoCM])
                {
                    [self.tipview presentPointingAtView:self.tipbutton inView:[UIApplication sharedApplication].keyWindow animated:YES];
                    [CSGameModel ShowPoCm];
                    
                    int dissmisssec = [[[CSGameModel shared].PointDict objectForKey:@"ext7"] intValue];
                    if (dissmisssec!=0)
                    {
                        [self.tipview autoDismissAnimated:YES atTimeInterval:dissmisssec];
                    }
                    
                }
                else
                {
                    self.tipview = [[CSCMPopTipView alloc]initWithMessage:@""];
                    self.tipview.dismissTapAnywhere = NO;
                    self.tipview.backgroundColor = [UIColor grayColor];
                    self.tipview.has3DStyle = NO;
                    self.tipview.delegate = self;
//                    [self.tipview presentPointingAtView:self.tipbutton inView:[UIApplication sharedApplication].keyWindow animated:YES];
                    if ([CSGameModel shared].PointDict)
                    {
                        int dissmisssec = [[[CSGameModel shared].PointDict objectForKey:@"ext7"] intValue];
                        if (dissmisssec!=0)
                        {
                            [self.tipview autoDismissAnimated:YES atTimeInterval:dissmisssec];
                        }
                    }
                    
                }
            }];
        }
        else  //按钮在右边,视图向左弹出
        {
            rightButtoninterval = -5;
            showView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CSSYGameSDK.bundle/floatViewR.png"]];
            showView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, showViewHeight);
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(self.frame.origin.x - showViewWidth, self.frame.origin.y, showViewWidth, showViewHeight);
            } completion:^(BOOL finished)
            {
//                NSLog(@"..");
                if ([CSGameModel isShowPoCM])
                {
                    [self.tipview presentPointingAtView:self.tipbutton inView:[UIApplication sharedApplication].keyWindow animated:YES];
                    [CSGameModel ShowPoCm];
                    int dissmisssec = [[[CSGameModel shared].PointDict objectForKey:@"ext7"] intValue];
                    if (dissmisssec==0)
                    {
                        dissmisssec = 5;
                    }
                    [self.tipview autoDismissAnimated:YES atTimeInterval:dissmisssec];
                }
                else
                {
                    self.tipview = [[CSCMPopTipView alloc]initWithMessage:@""];
                    self.tipview.dismissTapAnywhere = NO;
                    self.tipview.backgroundColor = [UIColor grayColor];
                    self.tipview.has3DStyle = NO;
                    self.tipview.delegate = self;
//                    [self.tipview presentPointingAtView:self.tipbutton inView:[UIApplication sharedApplication].keyWindow animated:YES];
                    if ([CSGameModel shared].PointDict)
                    {
                        int dissmisssec = [[[CSGameModel shared].PointDict objectForKey:@"ext7"] intValue];
                        if (dissmisssec!=0)
                        {
                            [self.tipview autoDismissAnimated:YES atTimeInterval:dissmisssec];
                        }
                    }
                    
                }
                
            }];
        }
        showView.userInteractionEnabled = YES;
        BOOL isIOSSevenUpsideDown = CSios7 && [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown;
        for (int i = 0; i < self.ExCSButtonImageArray.count; i++)
        {
            UIButton * detailsBtn = [[UIButton alloc]init];
            if (self.center.x < WindowWidth / 2)
            {
                detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (i + 1) + detailsBtnSize * i, 0, detailsBtnSize, showViewHeight);
            }
            else
            {
                detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (3 - i) + detailsBtnSize * (2 - i), 0, detailsBtnSize, showViewHeight);
            }
            //IOS7倒屏
            if (isIOSSevenUpsideDown)
            {
                detailsBtn.transform = CGAffineTransformMakeRotation(M_PI);
                if (self.center.x < WindowWidth / 2)
                {
                    detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (i + 1) + detailsBtnSize * i, showViewHeight, detailsBtnSize, showViewHeight);
                }
                else
                {
                    detailsBtn.frame = CGRectMake( rightButtoninterval + 3 + interval * (3 - i) + detailsBtnSize * (2 - i), showViewHeight, detailsBtnSize, showViewHeight);
                }
            }
            [detailsBtn setImage:[UIImage imageNamed:self.ExCSButtonImageArray[i]] forState:UIControlStateNormal];
            detailsBtn.tag = i;
            if (self.ExCSButtonImageArray.count-1 == i)
            {
                detailsBtn.tag = 2;
            }
            [detailsBtn addTarget:self action:@selector(detailsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            showView.layer.masksToBounds = YES;
            [detailsBtn setTitle: self.ExCSButtonTitleArray[i] forState:UIControlStateNormal];
            detailsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:CSisiPad?14:9];
            [detailsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buoyButton verticalImageAndTitle:3.0f FuckWangLei:detailsBtn];
            [showView addSubview:detailsBtn];
            if (detailsBtn.tag == self.ExCSButtonImageArray.count-2)
            {
                self.tipbutton = detailsBtn;
                if ([CSGameModel isShowRedPoint])
                {
                    [self.tipbutton addSubview:self.redpoint];
                }
                
            }
        }
        for (int i = 0; i < self.ExCSButtonTitleArray.count; i++)
        {
            UILabel * detailsLabel = [[UILabel alloc]init];
            if (self.center.x < WindowWidth / 2)
            {
                detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (i + 1) + detailsLabelWidth * i, CSisiPad?38:28, detailsLabelWidth, detailsLabelHeight);
            }
            else
            {
                detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (3 - i) + detailsLabelWidth * (2 - i), CSisiPad?38:28, detailsLabelWidth, detailsLabelHeight);
            }
            if (isIOSSevenUpsideDown)
            {
                detailsLabel.transform = CGAffineTransformMakeRotation(M_PI);
                if (self.center.x < WindowWidth / 2)
                {
                    detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (i + 1) + detailsLabelWidth * i, 2, detailsLabelWidth, detailsLabelHeight);
                }
                else
                {
                    detailsLabel.frame = CGRectMake(rightButtoninterval + 3 + interval * (3 - i) + detailsLabelWidth * (2 - i),2, detailsLabelWidth, detailsLabelHeight);
                }
            }
            detailsLabel.font = [UIFont boldSystemFontOfSize:CSisiPad?14:9];
            detailsLabel.textAlignment = NSTextAlignmentCenter;
            detailsLabel.textColor = [UIColor whiteColor];
            detailsLabel.text = self.ExCSButtonTitleArray[i];
//            [showView addSubview:detailsLabel];
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:showView];
    }
    else //视图存在时删除视图
    {
        [self.tipview dismissAnimated:YES];
        if (self.center.x < WindowWidth / 2)
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(showView.frame.origin.x, showView.frame.origin.y, 0, showViewHeight);
            } completion:^(BOOL finished) {
                [showView removeFromSuperview];
                showView = nil;
                [self dismissbyTimer];
            }];
            
        }
        else
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                showView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, showViewHeight);
            } completion:^(BOOL finished) {
                [showView removeFromSuperview];
                showView = nil;
                [self dismissbyTimer];
            }];
        }
        
    }
    
}

-(void)detailsButtonAction:(UIButton *)sender
{
//    [self.tipview dismissAnimated:YES];
//    [self TouchButton];
//    UIButton * btn = (UIButton *)sender;
//    if (btn.tag != 2)
//    {
//        CSGameTabBarViewController * tabbarVC = [[CSGameTabBarViewController alloc]init];
//        tabbarVC.selectedIndex = btn.tag;
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shabiyunying" object:[NSNumber numberWithInt:btn.tag] userInfo:nil];
//        if ( [CSGameModel shared].noticCommentviewcontroller&&![[[CSGameModel shared].noticCommentviewcontroller.navigationController.viewControllers lastObject] isKindOfClass:[CSGameTabBarViewController class]])
//        {
//            [[CSGameModel shared].noticCommentviewcontroller.navigationController pushViewController:tabbarVC animated:NO];
//        }
//        else
//        {
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:tabbarVC animated:YES completion:^{
//            }];
//        }
//        
//        
//        if (btn.tag == self.ExCSButtonTitleArray.count -2)
//        {
//            [self.redpoint removeFromSuperview];
//            [CSGameModel endShowRedPoint];
//            [CSGameModel EndShowPoCm];
//        }
//    }
//    else
//    {
//        self.DragButtonHidden = YES;
//        [buoyButton setDragButtonHidden:YES];
//    }
//
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    startPoint = [[touches anyObject] locationInView:self];
    [self.tipview dismissAnimated:YES];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    移动按钮时,当视图存在,那么移除视图.
    if ([showView window])
    {
        [showView removeFromSuperview];
    }
    
    //计算位移 = 当前位置 - 起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - startPoint.x;
    float dy = point.y - startPoint.y;
    
    //计算移动后的view中心点
    CGPoint newCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    //限制用户不可将视图拖出屏幕
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newCenter.x = MAX(halfx, newCenter.x);
    //y坐标右边界
    newCenter.x = MIN(self.superview.bounds.size.width - halfx, newCenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newCenter.y = MAX(halfy, newCenter.y);
    newCenter.y = MIN(self.superview.bounds.size.height - halfy, newCenter.y);
    
    self.center = newCenter;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (DifferenceBetween)  //IOS7横屏
    {
        if (self.center.y < WindowHeight / 2)
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                self.frame = CGRectMake(self.frame.origin.x, 0, btnSize, btnSize);
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                self.frame = CGRectMake(self.frame.origin.x, WindowHeight - btnSize, btnSize, btnSize);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        
        if (self.center.x<WindowWidth / 2)
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, btnSize, btnSize);
            } completion:^(BOOL finished) {
                [CSGameModel UserPointBar:self.center];
                [self dismissbyTimer];
            }];
        }
        else
        {
            [UIView animateWithDuration:CSAnimateDuration animations:^{
                self.frame = CGRectMake(WindowWidth - btnSize, self.frame.origin.y, btnSize, btnSize);
            } completion:^(BOOL finished) {
                [CSGameModel UserPointBar:self.center];
                [self dismissbyTimer];
            }];
        }
    }
}



+(buoyButton *)defaultFloatViewWithButton
{
    if (!buoyBtn)
    {
        buoyBtn = [[buoyButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:buoyBtn];
    return buoyBtn;
}

+(void)setDragButtonHidden:(BOOL)hidden
{
    if ([buoyButton defaultFloatViewWithButton].DragButtonHidden)
    {
        buoyBtn.hidden = YES;
    }
    else
    {
        buoyBtn.hidden = hidden;
        if (!hidden)
        {
            [buoyBtn dismissbyTimer];
        }
    }
    
}
+(void)Touch
{
    [buoyBtn TouchButton];
}

+(void)reMoveTouch
{
    [buoyBtn removeFromSuperview];
    buoyBtn = nil;
}

+ (void)verticalImageAndTitle:(CGFloat)spacing FuckWangLei:(UIButton *)btn
{
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);

}
@end
