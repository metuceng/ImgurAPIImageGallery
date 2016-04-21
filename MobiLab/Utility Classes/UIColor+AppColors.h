//
//  UIColor+AppColors.h
//  MobiLab
//
//  Created by Ahmet Abak on 21/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColors)
+ (UIColor *)navBarTintColor;
+ (UIColor *)navBarBackgroundColor;
+ (UIColor *)segmentedControlSelectedColor;
+ (UIColor *)segmentedControlNotSelectedColor;
+ (UIImage *)imageFromColor:(UIColor *)color withFrame:(CGRect)frame;
@end
