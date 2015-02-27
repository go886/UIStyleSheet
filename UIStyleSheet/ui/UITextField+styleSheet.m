//
//  UITextField+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UITextField+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UITextField (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"text-color"];
    if (value) self.textColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"font"];
    if (value) self.font = [UIStyleSheetConverter toFont:value];
    
    value = [style getValue:@"border-style"];
    if (value) self.borderStyle = [UIStyleSheetConverter toBorderStyle:value];
    
    value = [style getValue:@"placeholder"];
    if (value) self.placeholder = [UIStyleSheetConverter toString:value];
    
    value = [style getValue:@"minimum-font-size"];
    if (value) self.minimumFontSize = [UIStyleSheetConverter toFloat:value];
    
    value = [style getValue:@"vertical-align"];
    if (value) self.contentVerticalAlignment = [UIStyleSheetConverter toControlContentVerticalAlignment:value];
    
    value = [style getValue:@"horizontal-align"];
    if (value) self.contentHorizontalAlignment = [UIStyleSheetConverter toControlContentHorizontalAlignment:value];
}
@end
