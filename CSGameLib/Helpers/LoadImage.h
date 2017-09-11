//
//  loadImage.h
//  mb
//
//  Created by Baird-weng on 2017/8/28.
//  Copyright © 2017年 xiezhongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LoadImage : NSObject

/**
 读取CSConFusion.bundle的图片
 */
+(void)readBundleImages;
+(void)readImageWithFileName:(NSString *)name;
+(void)readImageWithFileNames:(NSArray *)names;
@end
