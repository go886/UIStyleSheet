//
//  UIRenderer.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIRenderer.h"

@implementation UIRenderer
+ (CIColor*)uiColorToCIColor:(UIColor*)color
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [CIColor colorWithRed:red green:green blue:blue];
}

+ (UIImage*)caLayerToUIImage:(CALayer*)layer
{
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat scale = [screen scale];
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CALayer*)uiImageToCALayer:(UIImage*)image
{
    CALayer*    layer = [CALayer layer];
    CGFloat nativeWidth = CGImageGetWidth(image.CGImage);
    CGFloat nativeHeight = CGImageGetHeight(image.CGImage);
    CGRect      startFrame = CGRectMake(0.0, 0.0, nativeWidth, nativeHeight);
    layer.contents = (id)image.CGImage;
    layer.frame = startFrame;
    return layer;
}

+ (CIImage*)tintCIImage:(CIImage*)image withColor:(CIColor*)color
{
    CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
    CIImage *baseImage = image;
    
    [monochromeFilter setValue:baseImage forKey:@"inputImage"];
    [monochromeFilter setValue:[CIColor colorWithRed:0.75 green:0.75 blue:0.75] forKey:@"inputColor"];
    [monochromeFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
    
    CIFilter *compositingFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
    
    CIFilter *colorGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    [colorGenerator setValue:color forKey:@"inputColor"];
    
    [compositingFilter setValue:[colorGenerator valueForKey:@"outputImage"] forKey:@"inputImage"];
    [compositingFilter setValue:[monochromeFilter valueForKey:@"outputImage"] forKey:@"inputBackgroundImage"];
    
    CIImage *outputImage = [compositingFilter valueForKey:@"outputImage"];
    
    return outputImage;
}

+ (UIImage*)colorImage:(UIColor*)color withFrame:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [color setFill];
    UIRectFill(frame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CAGradientLayer*)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame
{
    if (!topColor)  topColor = [UIColor clearColor];
    if (!bottomColor) bottomColor = topColor;
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = [NSArray arrayWithObjects:
                    (id)[topColor CGColor],
                    (id)[bottomColor CGColor], nil];
    layer.startPoint = CGPointMake(0.5f, 0.0f);
    layer.endPoint = CGPointMake(0.5f, 1.0f);
    return layer;
}

+ (UIImage*)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame
{
    CAGradientLayer *layer = [self gradientLayerWithTop:topColor bottom:bottomColor frame:frame];
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
