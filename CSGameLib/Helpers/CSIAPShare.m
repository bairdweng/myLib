//
//  IAPShare.m
//  inappPurchasesTest
//
//  Created by Htain Lin Shwe on 10/7/12.
//  Copyright (c) 2012 Edenpod. All rights reserved.
//

#import "CSIAPShare.h"

#if ! __has_feature(objc_arc)
#error You need to either convert your project to ARC or add the -fobjc-arc compiler flag to IAPShare.m.
#endif

@implementation CSIAPShare
@synthesize iap= _iap;

+ (CSIAPShare *) sharedHelper {
    static CSIAPShare * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[CSIAPShare alloc] init];
        _sharedHelper.iap = nil;
    });
    return _sharedHelper;
}

+(id)toJSON:(NSString *)json
{
    NSError* e = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData: [json dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &e];
    
    if(e==nil) {
        return jsonObject;
    }
    else {
        NSLog(@"%@",[e localizedDescription]);
        return nil;
    }
    
}

@end
