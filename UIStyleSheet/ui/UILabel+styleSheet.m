//
//  UILabel+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UILabel+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UILabel (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    UIView* superView = self.superview;
    if ([superView isKindOfClass:NSClassFromString(@"UINavigationItemView")] ||
        [superView isKindOfClass:NSClassFromString(@"_UIToolbarNavigationButton")]) {
        return;
    }
    
    
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    
    value = [style getValue:@"number-lines"];
    if (value) self.numberOfLines = [UIStyleSheetConverter toInteger:value];
    
    value = [style getValue:@"text"];
    if (value) self.text = [UIStyleSheetConverter toString:value];
    
    value = [style getValue:@"font"];
    if (value) self.font = [UIStyleSheetConverter toFont:value];
    
    value = [style getValue:@"text-color"];
    if (value) self.textColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"text-color-highlighted"];
    if (value) self.highlightedTextColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"text-auto-fit"];
    if (value) self.adjustsFontSizeToFitWidth = [UIStyleSheetConverter toBoolean:value];
    
    value = [style getValue:@"align"];
    if (value) self.textAlignment = [UIStyleSheetConverter toTextAlignment:value];
}
@end