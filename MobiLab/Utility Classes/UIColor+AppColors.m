//
//  UIColor+AppColors.m
//  MobiLab
//
//  Created by Ahmet Abak on 21/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (UIColor *)navBarTintColor
{
    return [UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];
}

+ (UIColor *)navBarBackgroundColor
{
    return [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
}

+ (UIColor *)segmentedControlNotSelectedColor
{
    return [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:1];
}

+ (UIColor *)segmentedControlSelectedColor
{
    return [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1];
}


+ (UIImage *)imageFromColor:(UIColor *)color withFrame:(CGRect)frame
{
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
