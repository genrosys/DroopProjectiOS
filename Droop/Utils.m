//
//  Utils.m
//  Droop
//
//  Created by Smart Pro on 2/23/18.
//  Copyright © 2018 pixatra. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
