//
//  UIStyleSheetConverter.h
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef __IPHONE_6_0 // iOS6 and later
#   define kTextAlignment           NSTextAlignment
#   define kTextAlignmentCenter     NSTextAlignmentCenter
#   define kTextAlignmentLeft       NSTextAlignmentLeft
#   define kTextAlignmentRight      NSTextAlignmentRight
#else // older versions
#   define kTextAlignment           UITextAlignment
#   define kTextAlignmentCenter     UITextAlignmentCenter
#   define kTextAlignmentLeft       UITextAlignmentLeft
#   define kTextAlignmentRight      UITextAlignmentRight
#endif

@interface UIStyleSheetConverter : NSObject
+ (BOOL)toBoolean:(id)value;
+ (float)toFloat:(id)value;
+ (NSInteger)toInteger:(id)value;
+ (CGSize)toSize:(NSString*)value;
+ (CGPoint)toPoint:(NSString*)value;
+ (CGRect)toRect:(NSString*)value;
+ (UIOffset)toOffset:(NSString*)value;
+ (UIEdgeInsets)toEdgeInsets:(NSString*)value;
+ (UIFont*)toFont:(NSString*)value;
+ (UIColor*)toColor:(NSString*)value;
+ (UIColor*)toColorFromImage:(NSString*)value;
+ (UIImage*)toImage:(NSString*)value;
+ (UIImage*)toImageFromColor:(NSString*)value;
+ (NSString*)toString:(NSString*)value;

+ (UITextBorderStyle)toBorderStyle:(NSString*)value;
+ (UITableViewCellSeparatorStyle)toSeparatorStyle:(NSString*)value;
+ (UIViewContentMode)toViewContentMode:(NSString*)value;
+ (kTextAlignment)toTextAlignment:(NSString*)value;
+ (UIControlContentVerticalAlignment)toControlContentVerticalAlignment:(NSString*)value;
+ (UIControlContentHorizontalAlignment)toControlContentHorizontalAlignment:(NSString*)value;
@end
