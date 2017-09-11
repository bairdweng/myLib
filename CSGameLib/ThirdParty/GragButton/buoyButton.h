//
//  buoyButton.h
//  buoyButton
//
//  Created by FreeGeek on 15/8/24.
//  Copyright (c) 2015年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCMPopTipView.h"

@interface buoyButton : UIButton<CMPopTipViewDelegate>
{
    
}

@property(nonatomic,assign)BOOL DragButtonHidden;
@property(nonatomic,strong)CSCMPopTipView *tipview;
@property(nonatomic,strong)UIButton *tipbutton;
@property(nonatomic,strong)UIView *redpoint;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@property(nonatomic,strong)NSMutableArray* ExCSButtonImageArray;
@property(nonatomic,strong)NSMutableArray* ExCSButtonTitleArray;
-(void)dismissbyTimer;
-(void)TouchButton;
-(void)OtherShowView;
+(void)Touch;
+(void)reMoveTouch;
+(buoyButton *)defaultFloatViewWithButton;
+(void)setDragButtonHidden:(BOOL)hidden;

@end
