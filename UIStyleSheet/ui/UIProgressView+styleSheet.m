//
//  UIProgressView+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIProgressView+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"


@implementation UIProgressView (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"progress"];
    if (value) self.progress = [UIStyleSheetConverter toFloat:value];
    
    value = [style getValue:@"progress-tint-color"];
    if (value) self.progressTintColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"progress-image"];
    if (value) self.progressImage = [UIStyleSheetConverter toImage:value];
    
    value = [style getValue:@"track-tint-color"];
    if (value) self.trackTintColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"track-image"];
    if (value) self.trackImage = [UIStyleSheetConverter toImage:value];
}
@end
