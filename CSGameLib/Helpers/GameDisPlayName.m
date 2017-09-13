//
//  GameDisplayName.m
//  CSGameLib
//
//  Created by Baird-weng on 2017/9/12.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import "GameDisPlayName.h"

@implementation GameDisPlayName
+(NSString *)getDisPlayName{
    NSDictionary*infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [infoDic objectForKey:@"CFBundleDisplayName"];
    if(!displayName){
        displayName = NSLocalizedString(@"CFBundleDisplayName",@"总是中文");
    }
    if (!displayName) {
        displayName = @"母包";
    }
    return displayName;
}
@end
