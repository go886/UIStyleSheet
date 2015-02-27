//
//  UIStyleSheetConverter.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIStyleSheetConverter.h"
#import <objc/message.h>

@implementation UIStyleSheetConverter
+ (BOOL)toBoolean:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        if ([value isEqualToString:@"true"]) {
            return YES;
        }
        if ([value isEqualToString:@"false"]) {
            return NO;
        }
    }
    return [value boolValue];
}

+ (float)toFloat:(id)value {
    return [value floatValue];
}

+ (NSInteger)toInteger:(id)value {
    return [value integerValue];
}

+ (CGSize)toSize:(NSString*)value {
    NSArray *strings = [value componentsSeparatedByString: @","];
    return CGSizeMake(
                      [self toFloat:[strings objectAtIndex:0]],
                      [self toFloat:[strings objectAtIndex:1]]
                      );
}

+ (CGPoint)toPoint:(NSString*)value {
    CGSize size = [self toSize:value];
    return CGPointMake(size.width, size.height);
}
+ (CGRect)toRect:(NSString*)value {
    NSArray *strings = [value componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    strings = [strings filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF != ''"]];
    float v[4] = {0,0,0,0};
    for (NSInteger i = 0; i<strings.count; ++i) {
        v[i] = [self toFloat:[strings objectAtIndex:i]];
    }
    return CGRectMake(v[0], v[1], v[2], v[3]);
}
+ (UIOffset)toOffset:(NSString*)value {
    CGSize size = [self toSize:value];
    return UIOffsetMake(size.width, size.height);
}
+ (UIEdgeInsets)toEdgeInsets:(NSString*)value {
    CGRect rt = [self toRect:value];
    return UIEdgeInsetsMake(rt.origin.y, rt.origin.x, rt.size.height, rt.size.width);
}
+ (UITextBorderStyle)toBorderStyle:(NSString*)value {
    if ([value isEqualToString:@"none"]) {
        return UITextBorderStyleNone;
    } else if ([value isEqualToString:@"line"]) {
        return UITextBorderStyleLine;
    } else if ([value isEqualToString:@"bezel"]) {
        return UITextBorderStyleBezel;
    } else if ([value isEqualToString:@"rounded"]) {
        return UITextBorderStyleRoundedRect;
    }
    return UITextBorderStyleNone;

}
+ (UITableViewCellSeparatorStyle)toSeparatorStyle:(NSString*)value {
    if([value isEqualToString:@"none"]) {
        return UITableViewCellSeparatorStyleNone;
    } else if([value isEqualToString:@"single-line"]) {
        return UITableViewCellSeparatorStyleSingleLine;
    } else if([value isEqualToString:@"single-line-etched"]){
        return UITableViewCellSeparatorStyleSingleLineEtched;
    }
    return UITableViewCellSeparatorStyleNone;
}
+ (UIFont*)toFont:(NSString*)value {
    NSArray *strings = [value componentsSeparatedByString: @","];
    if (strings && strings.count == 2) {
        if ([@"system" isEqualToString:strings[0]]) {
            return [UIFont systemFontOfSize:[self toFloat:strings[1]]];
        } else if([@"bold-system" isEqualToString:strings[0]])
            return [UIFont boldSystemFontOfSize:[self toFloat:strings[1]]];
        else
            return [UIFont fontWithName:strings[0] size:[self toFloat:strings[1]]];
    }
    return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}

+ (NSArray *)getCapturedStrings:(NSString *)content withPattern:(NSString *)pattern {
    if (!content) {
        return nil;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    
    if (!result)
        return nil;
    
    NSMutableArray *capturedStrings = [NSMutableArray array];
    for (NSUInteger i = 0; i <= regex.numberOfCaptureGroups; i++) {
        NSRange capturedRange = [result rangeAtIndex:i];
        if (capturedRange.location != NSNotFound) {
            [capturedStrings insertObject:[content substringWithRange:capturedRange] atIndex:i];
        } else {
            [capturedStrings insertObject:[NSNull null] atIndex:i];
        }
    }
    return [NSArray arrayWithArray:capturedStrings];
}
+ (UIColor*)toColor:(NSString*)value {
    // Look at UIColor selectors for a matching selector.
    // Name matches can take the form of 'colorname' (matching selectors like +redColor with 'red').
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", value]);
    if (selector) {
        if ([[UIColor class] respondsToSelector:selector]) {
            // [[UIColor class] performSelector:selector] would be better here, but it causes
            // a warning: "PerformSelector may cause a leak because its selector is unknown"
            return ((id (*)(id, SEL))objc_msgSend)([UIColor class], selector);
        }
    }
    
    // Remove all whitespace.
    NSString *cString = [[[value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                          componentsJoinedByString:@""]
                         uppercaseString];
    
    NSArray *hexStrings = [UIStyleSheetConverter getCapturedStrings:cString
                                               withPattern:@"(?:0X|#)([0-9A-F]{6,8})"];
   
    UIColor *color = nil;
    if (hexStrings) {
        unsigned int c;
        [[NSScanner scannerWithString:[hexStrings objectAtIndex:1]] scanHexInt:&c];
        if (c > 0xFFFFFF) {
            color = [UIColor colorWithRed:(float)((c & 0xFF000000) >> 24)/ 255.0f
                                    green:(float)((c & 0x00FF0000) >> 16) / 255.0f
                                     blue:(float)((c & 0x0000FF00) >> 8) / 255.0f
                                    alpha:(float)((c & 0x000000FF)) / 255.0f];
        }else {
            color = [UIColor colorWithRed:(float)((c & 0xFF0000) >> 16) / 255.0f
                                    green:(float)((c & 0x00FF00) >> 8) / 255.0f
                                     blue:(float)((c & 0x0000FF)) / 255.0f
                                    alpha:1.0f];
        }
    } else {
        NSArray *csStrings = [UIStyleSheetConverter getCapturedStrings:cString
                                                           withPattern:@"(RGB|RGBA|HSL|HSLA)\\((\\d{1,3}|[0-9.]+),(\\d{1,3}|[0-9.]+),(\\d{1,3}|[0-9.]+)(?:,(\\d{1,3}|[0-9.]+))?\\)"];
        if (csStrings) {
            BOOL isRGB = [[csStrings objectAtIndex:1] hasPrefix:@"RGB"];
            BOOL isAlpha = [[csStrings objectAtIndex:1] hasSuffix:@"A"];
            
            // Color space with alpha specified but no alpha provided.
            if (isAlpha && [[csStrings objectAtIndex:5] isEqual:[NSNull null]])
                return nil;
            
            CGFloat a = isAlpha ?
            [UIStyleSheetConverter parseColorComponent:[csStrings objectAtIndex:5]] :
            1.0f;
            
            if (isRGB) {
                color = [UIColor colorWithRed:[UIStyleSheetConverter parseColorComponent:[csStrings objectAtIndex:2]]
                                        green:[UIStyleSheetConverter parseColorComponent:[csStrings objectAtIndex:3]]
                                         blue:[UIStyleSheetConverter parseColorComponent:[csStrings objectAtIndex:4]]
                                        alpha:a];
            } else {
                color = [UIColor colorWithHue:[UIStyleSheetConverter parseColorComponent:[csStrings objectAtIndex:2]]
                                   saturation:[UIStyleSheetConverter parseColorComponent:[csStrings objectAtIndex:3]]
                                   brightness:[UIStyleSheetConverter parseColorComponent:[csStrings objectAtIndex:4]]
                                        alpha:a];
            }
        }
       
    }
    
    return color;
}

/** Parses a color component in a color expression. Values containing
 *  periods (.) are treated as unscaled floats. Integer values
 *  are normalized by 255.
 */
+ (CGFloat)parseColorComponent:(NSString *)s {
    if ([s rangeOfString:@"."].location != NSNotFound) {
        return [s floatValue];
    } else {
        return [s floatValue] / 255.0f;
    }
}
+ (UIColor*)toColorFromImage:(NSString*)value {
    UIImage* image = [self toImage:value];
    return [UIColor colorWithPatternImage:image];
}
+ (UIImage*)toImageFromColor:(NSString*)value {
    UIColor* color = [self toColor:value];
    CGFloat alphaChannel;
    [color getRed:NULL green:NULL blue:NULL alpha:&alphaChannel];
    BOOL opaqueImage = (alphaChannel == 1.0);
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, opaqueImage, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage*)toImage:(NSString*)value {
    NSArray* array  = [value componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (array.count > 1) {
        value = array[0];
        float offsets[4] = {0};
        for (int i=1; i<array.count && i<5; ++i) {
            offsets[i-1] = [array[i] floatValue];
        }
        UIEdgeInsets edg = {offsets[1], offsets[0], offsets[3], offsets[2]};
        return  [[UIImage imageWithContentsOfFile:value] resizableImageWithCapInsets:edg];
    }

    UIImage* img = [UIImage imageWithContentsOfFile:value];
    return img;
}
+ (NSString*)toString:(NSString *)value {
    if (value && value.length > 2 && '"' == [value characterAtIndex:0] && '"' == [value characterAtIndex:value.length -1]) {
        return NSLocalizedString([value substringWithRange:NSMakeRange(1, value.length -2)],nil);
    }
    return value;
}
+ (UIViewContentMode)toViewContentMode:(NSString*)value {
    if ([@"fill" isEqualToString:value]) {
        return UIViewContentModeScaleToFill;
    }else if([@"aspect-fit" isEqualToString:value]) {
        return UIViewContentModeScaleAspectFit;
    }else if([@"aspect-fill" isEqualToString:value])
        return UIViewContentModeScaleAspectFill;
    else if([@"redraw" isEqualToString:value])
        return UIViewContentModeRedraw;
    else if([@"center" isEqualToString:value])
        return UIViewContentModeCenter;
    else if([@"top" isEqualToString:value])
        return UIViewContentModeTop;
    else if([@"bottom" isEqualToString:value])
        return UIViewContentModeBottom;
    else if([@"left" isEqualToString:value])
        return UIViewContentModeLeft;
    else if([@"right" isEqualToString:value])
        return UIViewContentModeRight;
    else if([@"topleft" isEqualToString:value])
        return UIViewContentModeTopLeft;
    else if([@"topright" isEqualToString:value])
        return UIViewContentModeTopRight;
    else if([@"bottomleft" isEqualToString:value])
        return UIViewContentModeBottomLeft;
    else if([@"bottomright" isEqualToString:value])
        return UIViewContentModeBottomRight;

    return UIViewContentModeScaleToFill;
}
+ (kTextAlignment)toTextAlignment:(NSString*)value {
    kTextAlignment alignment = kTextAlignmentLeft;
    
    if ([value isEqualToString:@"center"]) {
        alignment =   kTextAlignmentCenter;
    } else if ([value isEqualToString:@"right"]) {
        alignment =   kTextAlignmentRight;
    }
    
    return alignment;
}
+ (UIControlContentVerticalAlignment)toControlContentVerticalAlignment:(NSString*)value {
    UIControlContentVerticalAlignment alignment = UIControlContentVerticalAlignmentTop;
    if ([@"center" isEqualToString:value])
        alignment = UIControlContentVerticalAlignmentCenter;
    else if([@"bottom" isEqualToString:value])
        alignment = UIControlContentVerticalAlignmentBottom;
    else if([@"fill" isEqualToString:value])
        alignment = UIControlContentVerticalAlignmentFill;
    return alignment;
}
+ (UIControlContentHorizontalAlignment)toControlContentHorizontalAlignment:(NSString*)value {
    UIControlContentHorizontalAlignment alignment = UIControlContentHorizontalAlignmentLeft;
    
    if ([value isEqualToString:@"center"]) {
        alignment =  UIControlContentHorizontalAlignmentCenter;
    } else if ([value isEqualToString:@"right"]) {
        alignment =  UIControlContentHorizontalAlignmentRight;
    } else if ([value isEqualToString:@"fill"]) {
        alignment =  UIControlContentHorizontalAlignmentFill;
    }
    
    return alignment;
}
@end
