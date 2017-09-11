//
//  DynamicMethods.m
//  CSGameLib
//
//  Created by Baird-weng on 2017/9/6.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import "DynamicMethods.h"
#import <objc/runtime.h>
@implementation DynamicMethods
+ (void)addMethods{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* methodName = infoDictionary[@"CFBundleName"];
    SEL mo = NSSelectorFromString(methodName);
    [[[[self class]alloc]init] performSelector:mo withObject:methodName afterDelay:1];
}
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* methodName = infoDictionary[@"CFBundleName"];
    SEL mo = NSSelectorFromString(methodName);
    if (sel == mo) {
        class_addMethod([self class], sel, (IMP)MyMethod, "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
void MyMethod(id self, SEL _cmd, NSString *brand) {
    NSLog(@"CFBundleName==============%@", brand);
}
@end
