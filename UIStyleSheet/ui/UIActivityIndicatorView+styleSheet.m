//
//  UIActivityIndicatorView+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIActivityIndicatorView+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UIActivityIndicatorView (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"indicator"];
    if (value) {
        UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
        if ([@"gray" isEqualToString:value]) {
            indicatorStyle = UIActivityIndicatorViewStyleGray;
        }else if([@"white" isEqualToString:value]) {
            indicatorStyle = UIActivityIndicatorViewStyleWhite;
        }
        self.activityIndicatorViewStyle = indicatorStyle;
    }
    
    value = [style getValue:@"auto-stop"];
    if (value) self.hidesWhenStopped = [UIStyleSheetConverter toBoolean:value];
    
    value = [style getValue:@"color"];
    if (value) self.color = [UIStyleSheetConverter toColor:value];
}
@end
