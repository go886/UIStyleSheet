//
//  UIImageView+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIImageView+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UIImageView (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"image"];
    if (value) self.image = [UIStyleSheetConverter toImage:value];
    
    value = [style getValue:@"highlighted-image"];
    if (value) self.highlightedImage = [UIStyleSheetConverter toImage:value];
    
    value = [style getValue:@"highlighted"];
    if (value) self.highlighted = [UIStyleSheetConverter toBoolean:value];
    
    if ([self respondsToSelector:@selector(setTintColor:)]) {
        value = [style getValue:@"tint-color"];
        if (value) self.tintColor = [UIStyleSheetConverter toColor:value];
    }
}
@end
