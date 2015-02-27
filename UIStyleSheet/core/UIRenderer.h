//
//  UIRenderer.h
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UIRenderer : NSObject
+ (UIImage*)caLayerToUIImage:(CALayer*)layer;
+ (CALayer*)uiImageToCALayer:(UIImage*)image;
+ (CIImage*)tintCIImage:(CIImage*)image withColor:(CIColor*)color;
+ (UIImage*)colorImage:(UIColor*)color withFrame:(CGRect)frame;
+ (CAGradientLayer*)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;
+ (UIImage*)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;
@end
