//
//  UIScrollView+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIScrollView+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UIScrollView (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"indicator-style"];
    if (value) {
        UIScrollViewIndicatorStyle indicatorStyle = UIScrollViewIndicatorStyleDefault;
        if ([@"black" isEqualToString:value]) {
            indicatorStyle = UIScrollViewIndicatorStyleBlack;
        }else if([@"white" isEqualToString:value]) {
            indicatorStyle = UIScrollViewIndicatorStyleWhite;
        }
        self.indicatorStyle = indicatorStyle;
    }
    
    
}
@end
