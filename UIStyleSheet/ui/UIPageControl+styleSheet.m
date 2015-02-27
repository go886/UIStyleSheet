//
//  UIPageControl+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIPageControl+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UIPageControl (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"page"];
    if (value) self.currentPage = [UIStyleSheetConverter toInteger:value];
    
    value = [style getValue:@"hide-single-page"];
    if (value) self.hidesForSinglePage = [UIStyleSheetConverter toBoolean:value];
    
    if ([self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        value = [style getValue:@"tint-color"];
        if (value) self.pageIndicatorTintColor = [UIStyleSheetConverter toColor:value];
    }
    
    if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
        value = [style getValue:@"current-page-indicator-tint-color"];
        if (value) self.currentPageIndicatorTintColor = [UIStyleSheetConverter toColor:value];
    }
}
@end
