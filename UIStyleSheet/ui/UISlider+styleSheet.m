//
//  UISlider+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UISlider+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"

@implementation UISlider (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"value"];
    if (value) self.value = [UIStyleSheetConverter toFloat:value];
    
    value = [style getValue:@"minimum-value"];
    if (value) self.minimumValue = [UIStyleSheetConverter toFloat:value];
    
    value = [style getValue:@"maximum-value"];
    if (value) self.maximumValue = [UIStyleSheetConverter toFloat:value];
   
    value = [style getValue:@"minimum-track-tint-color"];
    if (value) self.minimumTrackTintColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"maximum-track-tint-color"];
    if (value) self.maximumTrackTintColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"thumb-tint-color"];
    if (value) self.thumbTintColor = [UIStyleSheetConverter toColor:value];
    
    value = [style getValue:@"minimum-value-image"];
    if (value) self.minimumValueImage = [UIStyleSheetConverter toImage:value];
    
    value = [style getValue:@"maximum-value-image"];
    if (value) self.maximumValueImage = [UIStyleSheetConverter toImage:value];
    
    typedef struct {
        __unsafe_unretained NSString* key;
        NSUInteger st;
    }ItemInfo;
    
    {
        ItemInfo infos[] = {
            {@"thumb-image", UIControlStateNormal},
            {@"thumb-image-highlighted", UIControlStateHighlighted},
            {@"thumb-image-selected", UIControlStateSelected},
            {@"thumb-image-disabled", UIControlStateDisabled}
        };
        
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setThumbImage:[UIStyleSheetConverter toImage:value] forState:infos[i].st];
        }
    }
    
    {
        ItemInfo infos[] = {
            {@"minimum-track-image", UIControlStateNormal},
            {@"minimum-track-image-highlighted", UIControlStateHighlighted},
            {@"minimum-track-image-selected", UIControlStateSelected},
            {@"minimum-track-image-disabled", UIControlStateDisabled}
        };
        
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setMinimumTrackImage:[UIStyleSheetConverter toImage:value] forState:infos[i].st];
        }
    }
    
    {
        ItemInfo infos[] = {
            {@"maximum-track-image", UIControlStateNormal},
            {@"maximum-track-image-highlighted", UIControlStateHighlighted},
            {@"maximum-track-image-selected", UIControlStateSelected},
            {@"maximum-track-image-disabled", UIControlStateDisabled}
        };
        
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setMaximumTrackImage:[UIStyleSheetConverter toImage:value] forState:infos[i].st];
        }
    }
}
@end
