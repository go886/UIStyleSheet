//
//  UIToolbar+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIToolbar+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"

@implementation UIToolbar (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    if ([self respondsToSelector:@selector(barTintColor)]) {
        value = [style getValue:@"bar-tint-color"];
        if (value) self.barTintColor = [UIStyleSheetConverter toColor:value];
    }
    
    typedef struct {
        __unsafe_unretained NSString* key;
        NSUInteger st;
    }ItemInfo;
    
    {
        ItemInfo infos[] = {
            {@"background-image",UIToolbarPositionAny},
            {@"background-image-top", UIToolbarPositionTop},
            {@"background-image-bottom", UIToolbarPositionBottom},
            {@"background-image-top-landscape", UIToolbarPositionTop},
            {@"background-image-bottom-landscape", UIToolbarPositionBottom},
        };
        
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setBackgroundImage:[UIStyleSheetConverter toImage:value] forToolbarPosition:infos[i].st barMetrics:UIBarMetricsDefault];
        }
    }
    
    if ([self respondsToSelector:@selector(setShadowImage:forToolbarPosition:)]) {
        ItemInfo infos[] = {
            {@"shadow-image",UIToolbarPositionAny},
            {@"shadow-image-top", UIToolbarPositionTop},
            {@"shadow-image-bottom", UIToolbarPositionBottom}
        };
        
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setShadowImage:[UIStyleSheetConverter toImage:value] forToolbarPosition:infos[i].st];
        }
    }
}
@end
