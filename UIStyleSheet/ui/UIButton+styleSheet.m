//
//  UIButton+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-20.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIButton+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
#import "UIRenderer.h"

@implementation UIButton (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    if ([self.superview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
        return;
    }
    
    
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    
    typedef struct {
        __unsafe_unretained NSString* key;
        NSUInteger st;
    }ItemInfo;
    
    {
        ItemInfo infos[] = {
            {@"background-color",UIControlStateNormal},
            {@"background-color-highlighted", UIControlStateHighlighted},
            {@"background-color-disabled", UIControlStateDisabled},
            {@"background-color-selected", UIControlStateSelected},
            {@"background-color-selected-highlighted", UIControlStateSelected|UIControlStateHighlighted},
            {@"background-color-selected-disabled", UIControlStateSelected|UIControlStateDisabled}
        };
        
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setBackgroundImage:[UIStyleSheetConverter toImageFromColor:value] forState:infos[i].st];
        }
    }
    
    {
        ItemInfo infos[] = {
            {@"background-image",UIControlStateNormal},
            {@"background-image-highlighted", UIControlStateHighlighted},
            {@"background-image-disabled", UIControlStateDisabled},
            {@"background-image-selected", UIControlStateSelected},
            {@"background-image-selected-highlighted", UIControlStateSelected|UIControlStateHighlighted},
            {@"background-image-selected-disabled", UIControlStateSelected|UIControlStateDisabled}
        };
        
        for (int i = 0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setBackgroundImage:[UIStyleSheetConverter toImage:value] forState:infos[i].st];
        }
    }
    
    {
        ItemInfo infos[] = {
            {@"image",UIControlStateNormal},
            {@"image-highlighted", UIControlStateHighlighted},
            {@"image-disabled", UIControlStateDisabled},
            {@"image-selected", UIControlStateSelected},
            {@"image-selected-highlighted", UIControlStateSelected|UIControlStateHighlighted},
            {@"image-selected-disabled", UIControlStateSelected|UIControlStateDisabled}
        };
        
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setImage:[UIStyleSheetConverter toImage:value] forState:infos[i].st];
        }
    }
    
    {
        ItemInfo colors[] = {
            {@"text-color", UIControlStateNormal},
            {@"text-color-highlighted", UIControlStateHighlighted},
            {@"text-color-disabled", UIControlStateDisabled},
            {@"text-color-selected", UIControlStateSelected},
            {@"text-color-selected-highlighted", UIControlStateSelected|UIControlStateHighlighted},
            {@"text-color-selected-disabled", UIControlStateSelected|UIControlStateDisabled}
        };
        
        for (int i=0; i<sizeof(colors)/sizeof(colors[0]); ++i) {
            value = [style getValue:colors[i].key];
            if (value) [self setTitleColor:[UIStyleSheetConverter toColor:value] forState:colors[i].st];
        }
    }
    
    {
        ItemInfo colors[] = {
            {@"text-shadow-color", UIControlStateNormal},
            {@"text-shadow-color-highlighted", UIControlStateHighlighted},
            {@"text-shadow-color-disabled", UIControlStateDisabled},
            {@"text-shadow-color-selected", UIControlStateSelected},
            {@"text-shadow-color-selected-highlighted", UIControlStateSelected|UIControlStateHighlighted},
            {@"text-shadow-color-selected-disabled", UIControlStateSelected|UIControlStateDisabled}
        };
        
        for (int i=0; i<sizeof(colors)/sizeof(colors[0]); ++i) {
            value = [style getValue:colors[i].key];
            if (value) [self setTitleShadowColor:[UIStyleSheetConverter toColor:value] forState:colors[i].st];
        }
    }
    
    value = [style getValue:@"show-highlighted"];
    if (value)self.showsTouchWhenHighlighted = [UIStyleSheetConverter toBoolean:value];
    
    value = [style getValue:@"text-align"];
    if (value) [self setContentHorizontalAlignment:[UIStyleSheetConverter toControlContentHorizontalAlignment:value]];
    
    value = [style getValue:@"title-insets"];
    if (value) [self setTitleEdgeInsets:[UIStyleSheetConverter toEdgeInsets:value]];
    
    value = [style getValue:@"content-insets"];
    if (value) [self setContentEdgeInsets:[UIStyleSheetConverter toEdgeInsets:value]];
    
    value = [style getValue:@"text"];
    if (value) [self setTitle:[UIStyleSheetConverter toString:value] forState:UIControlStateNormal];
    
    value = [style getValue:@"font"];
    if (value) self.titleLabel.font = [UIStyleSheetConverter toFont:value];
}
@end
