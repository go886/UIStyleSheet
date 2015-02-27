//
//  UIStepper+styleSheet.m
//  UIStyleSheet
//
//  Created by go886 on 14-10-8.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIStepper+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UIStepper (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    
    typedef struct {
        __unsafe_unretained NSString* key;
        NSUInteger st;
    }ItemInfo;
    
    if ([self respondsToSelector:@selector(setBackgroundImage:forState:)]) {
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
}
@end
