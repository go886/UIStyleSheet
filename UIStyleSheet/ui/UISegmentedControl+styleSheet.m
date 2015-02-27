//
//  UISegmentedControl+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UISegmentedControl+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"


@implementation UISegmentedControl (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    
    typedef struct {
        __unsafe_unretained NSString* key;
        NSUInteger st;
    }ItemInfo;
    
    
    {
        ItemInfo infos[] = {
            {@"background-image",UIControlStateNormal},
            {@"background-image-selected", UIControlStateSelected},
        };
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setBackgroundImage:[UIStyleSheetConverter toImage:value] forState:infos[i].st barMetrics:UIBarMetricsDefault];
        }
    }
    
    {
        ItemInfo infos[] = {
            {@"divider-image",UIControlStateNormal},
            {@"divider-image-selected", UIControlStateSelected},
        };
        for (int i=0; i<sizeof(infos)/sizeof(infos[0]); ++i) {
            value = [style getValue:infos[i].key];
            if (value) [self setDividerImage:[UIStyleSheetConverter toImage:value]
                         forLeftSegmentState:infos[i].st
                           rightSegmentState:infos[i].st
                                  barMetrics:UIBarMetricsDefault];
        }
    }
    
    NSDictionary *titleTextAttributes = [style titleTextAttributesWithSuffix:nil];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        [self setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    NSDictionary *selectedSegmentAttributeOverrides = [style titleTextAttributesWithSuffix:@"selected"];
    if ([[selectedSegmentAttributeOverrides allKeys] count] > 0) {
        NSMutableDictionary *selectedTitleTextAttributes = [titleTextAttributes mutableCopy];
        [selectedTitleTextAttributes addEntriesFromDictionary:selectedSegmentAttributeOverrides];
        [self setTitleTextAttributes:[selectedTitleTextAttributes copy] forState:UIControlStateSelected];
    }
}
@end
