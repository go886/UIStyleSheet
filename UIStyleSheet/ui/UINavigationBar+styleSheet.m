//
//  UINavigationBar+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UINavigationBar+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
#import "UIRenderer.h"

@implementation UINavigationBar (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    if ([self respondsToSelector:@selector(setBarTintColor:)]) {
        value = [style getValue:@"bar-tint-color"];
        if (value) self.barTintColor = [UIStyleSheetConverter toColor:value];
    }
    
    value = [style getValue:@"background-image"];
    if (value) [self setBackgroundImage:[UIStyleSheetConverter toImage:value] forBarMetrics:UIBarMetricsDefault];
    
    if ([self respondsToSelector:@selector(setShadowImage:)]) {
        value = [style getValue:@"shadow-image"];
        if (value) [self setShadowImage:[UIStyleSheetConverter toImage:value]];
    }
    
    value = [style getValue:@"title-vertical-offset"];
    if (value) [self setTitleVerticalPositionAdjustment:[UIStyleSheetConverter toFloat:value] forBarMetrics:UIBarMetricsDefault];
    
    value = [style getValue:@"bar-background-color-top"];
    if (value) {
        UIImage *gradientImage = [UIRenderer
                                  gradientImageWithTop:[UIStyleSheetConverter toColor:[style getValue:@"bar-background-color-top"]]
                                  bottom:[UIStyleSheetConverter toColor:[style getValue:@"bar-background-color-bottom"]]
                                  frame:self.bounds];
        [self setBackgroundImage:gradientImage forBarMetrics:UIBarMetricsDefault];
    }else {
        value = [style getValue:@"bar-background-color"];
        if (value) [self setBackgroundImage:[UIRenderer colorImage:[UIStyleSheetConverter toColor:value] withFrame:self.bounds] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    NSDictionary *titleTextAttributes = [style titleTextAttributesWithSuffix:nil];
    if ([[titleTextAttributes allKeys] count] > 0) {
        self.titleTextAttributes = titleTextAttributes;
    }
}
@end
