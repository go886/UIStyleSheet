//
//  UIActionSheet+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIActionSheet+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
@implementation UIActionSheet (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"acton-style"];
    if (value) {
        if ([value isEqualToString:@"trans"]) {
            self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        }else if([value isEqualToString:@"opaque"]) {
            self.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        }else if([value isEqualToString:@"default"]) {
            self.actionSheetStyle = UIActionSheetStyleDefault;
        }else {
            self.actionSheetStyle = UIActionSheetStyleAutomatic;
        }
    }
}
@end
