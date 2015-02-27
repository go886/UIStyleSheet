//
//  UITableView+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UITableView+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
#import "UIRenderer.h"

@implementation UITableView (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"row-height"];
    if (value) self.rowHeight = [UIStyleSheetConverter toFloat:value];
    
    value = [style getValue:@"separator-color"];
    if (value) self.separatorColor = [UIStyleSheetConverter toColor:value];

    value = [style getValue:@"separator-style"];
    if (value) self.separatorStyle = [UIStyleSheetConverter toSeparatorStyle:value];
    
    if ([self respondsToSelector:@selector(sectionIndexColor)]) {
        value = [style getValue:@"section-index-color"];
        if (value) self.sectionIndexColor = [UIStyleSheetConverter toColor:value];
    }
    
    if ([self respondsToSelector:@selector(sectionIndexBackgroundColor)]) {
        value = [style getValue:@"section-index-background-color"];
        if (value) self.sectionIndexBackgroundColor = [UIStyleSheetConverter toColor:value];
    }
    
    if ([self respondsToSelector:@selector(sectionIndexTrackingBackgroundColor)]) {
        value = [style getValue:@"section-index-track-background-color"];
        if (value) self.sectionIndexTrackingBackgroundColor = [UIStyleSheetConverter toColor:value];
    }
    
    UIImage* img = [style gradientImage:@"background-color" frame:self.bounds];
    if (img) self.backgroundView = [[UIImageView alloc] initWithImage:img];
}
@end
