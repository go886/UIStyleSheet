//
//  UISearchBar+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UISearchBar+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
#import "UIRenderer.h"
@implementation UISearchBar (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"text"];
    if (value) self.text = [UIStyleSheetConverter toString:value];
    
    value = [style getValue:@"prompt"];
    if (value) self.prompt = [UIStyleSheetConverter toString:value];
    
    value = [style getValue:@"placeholder"];
    if (value) self.placeholder = [UIStyleSheetConverter toString:value];
    
    
    value = [style getValue:@"bar-background-color"];
    if (value) [self setBackgroundImage:[UIStyleSheetConverter toImageFromColor:value]];
    
    UIImage* img = [style gradientImage:@"bar-background-color" frame:self.bounds];
    if (img) self.backgroundImage = img;
    
    value = [style getValue:@"background-image"];
    if (value) self.backgroundImage = [UIStyleSheetConverter toImage:value];
    
    value = [style getValue:@"scope-background-color"];
    if (value) self.scopeBarBackgroundImage = [UIStyleSheetConverter toImageFromColor:value];
    
    value = [style getValue:@"scope-background-image"];
    if (value) self.scopeBarBackgroundImage = [UIStyleSheetConverter toImage:value];
    
    NSDictionary *titleTextAttributes = [style titleTextAttributesWithSuffix:nil];
    if ([titleTextAttributes allKeys].count) {
        [self setScopeBarButtonTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    if ([self respondsToSelector:@selector(setBarTintColor:)]) {
        value = [style getValue:@"bar-tint-color"];
        if (value) self.barTintColor = [UIStyleSheetConverter toColor:value];
    }
}
@end
