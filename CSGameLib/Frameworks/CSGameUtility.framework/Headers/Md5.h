//
//  Md5.h
//
//  Created by 9377-LieyanMobile on 15/4/27.
//
//

#import <Foundation/Foundation.h>

@interface Md5 : NSObject

// 返回md5码, lowercase传入YES时返回小写MD5码，反之为大写。
+(NSString *)md5:(NSString *)string lowercase:(BOOL)lowercase;

@end
