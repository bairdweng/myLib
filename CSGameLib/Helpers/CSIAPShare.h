//
//  IAPShare.h
//  ;
//
//  Created by Htain Lin Shwe on 10/7/12.
//  Copyright (c) 2012 Edenpod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSIAPHelper.h"
@interface CSIAPShare : NSObject
@property (nonatomic,strong) CSIAPHelper *iap;

+ (CSIAPShare *) sharedHelper;

+(id)toJSON:(NSString*)json;
@end
