//
//  loadImage.m
//  mb
//
//  Created by Baird-weng on 2017/8/28.
//  Copyright © 2017年 xiezhongxi. All rights reserved.
//

#import "LoadImage.h"
#import <UIKit/UIKit.h>
@implementation LoadImage
+(void)readBundleImages{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CSConFusion" ofType:@"bundle"];
        NSString *bundlePath = path;
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *enumerator;
        enumerator = [fileManager enumeratorAtPath:path];
        while((path = [enumerator nextObject]) != nil) {
            NSString *resPath = [NSString stringWithFormat:@"%@/%@",bundlePath,path];
            UIImage* tempImage = [UIImage imageWithContentsOfFile:resPath];
            if(tempImage){
                NSString *imageStr = [self image2DataURL:tempImage];
                NSLog(@"%ld", imageStr.length);
            }
        }
    });
}
+(void)readImageWithFileName:(NSString *)name{
    UIImage *tempImage = [UIImage imageNamed:name];
    NSString *imageStr = [self image2DataURL:tempImage];
    NSLog(@"%ld",imageStr.length);
}
+(void)readImageWithFileNames:(NSArray *)names{
    if(names&&names.count>0){
        for (NSString *imageName in names) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            UIImage* tempImage = [UIImage imageWithContentsOfFile:imagePath];
            NSString *imageStr = [self image2DataURL:tempImage];
            NSLog(@"%ld",imageStr.length);
        }
    }
}
+ (NSString*)image2DataURL:(UIImage*)image
{
    NSData* imageData = nil;
    NSString *mimeType = nil;
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}
+ (BOOL) imageHasAlpha: (UIImage *) image{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}
@end
