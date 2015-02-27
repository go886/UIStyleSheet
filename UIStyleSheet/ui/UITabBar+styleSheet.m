//
//  UITabBar+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UITabBar+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
#import "UIRenderer.h"
@implementation UITabBar (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"background-image"];
    if (value) [self setBackgroundImage:[UIStyleSheetConverter toImage:value]];
    
    if ([self respondsToSelector:@selector(setBarTintColor:)]) {
        value = [style getValue:@"bar-tint-color"];
        if (value) self.barTintColor = [UIStyleSheetConverter toColor:value];
    }
    
    
    value = [style getValue:@"selected-image"];
    if (value) [self setSelectionIndicatorImage:[UIStyleSheetConverter toImage:value]];
    
    if ([self respondsToSelector:@selector(setShadowImage:)]) {
        value = [style getValue:@"shadow-image"];
        if (value) [self setShadowImage:[UIStyleSheetConverter toImage:value]];
    }
    
    UIImage* img = [style gradientImage:@"background-color" frame:self.bounds];
    if (img) self.backgroundImage = img;
}
@end
