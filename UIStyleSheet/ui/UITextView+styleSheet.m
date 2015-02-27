//
//  UITextView+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UITextView+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UITextView (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"font"];
    if (value) self.font = [UIStyleSheetConverter toFont:value];
    
    value = [style getValue:@"text-color"];
    if (value) self.textColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"text-align"];
    if (value) self.textAlignment = [UIStyleSheetConverter toTextAlignment:value];
    
    value = [style getValue:@"content-inset"];
    if (value) self.contentInset = [UIStyleSheetConverter toEdgeInsets:value];
}
@end
