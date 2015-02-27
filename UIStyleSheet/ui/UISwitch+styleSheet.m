//
//  UISwitch+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UISwitch+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"

@implementation UISwitch (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"on-tint-color"];
    if (value) self.onTintColor = [UIStyleSheetConverter toColor:value];
    
    if ([self respondsToSelector:@selector(setThumbTintColor:)]) {
        value = [style getValue:@"thumb-tint-color"];
        if (value) self.thumbTintColor = [UIStyleSheetConverter toColor:value];
    }

    
    if ([self respondsToSelector:@selector(onImage)]) {
        value = [style getValue:@"on-image"];
        if (value) self.onImage = [UIStyleSheetConverter toImage:value];
    }
    
    if ([self respondsToSelector:@selector(offImage)]) {
        value = [style getValue:@"off-image"];
        if (value) self.onImage = [UIStyleSheetConverter toImage:value];
    }
}
@end
