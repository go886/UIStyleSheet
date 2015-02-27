//
//  UITableViewCell+sheetStyle.m
//  test_CSS
//
//  Created by go886 on 14-9-24.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UITableViewCell+styleSheet.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetConverter.h"
#import "UIRenderer.h"
@implementation UITableViewCell (styleSheet)
-(void)applyStyleSheet:(UIStyleSheet *)style {
    [super applyStyleSheet:style];
    
    NSString* value = nil;
    value = [style getValue:@"selected-style"];
    if (value) {
        UITableViewCellSelectionStyle selectStyle = UITableViewCellSelectionStyleNone;
        if ([@"blue" isEqualToString:value])
            selectStyle = UITableViewCellSelectionStyleBlue;
        else if([@"gray" isEqualToString:value])
            selectStyle = UITableViewCellSelectionStyleGray;
        else if([@"default" isEqualToString:value])
            selectStyle = UITableViewCellSelectionStyleDefault;
        
        self.selectionStyle = selectStyle;
    }
    
    UIImage* img = [style gradientImage:@"background-color" frame:self.bounds];
    if (img) self.backgroundView = [[UIImageView alloc] initWithImage:img];
    
    img = [style gradientImage:@"background-color-selected" frame:self.bounds];
    if (img) self.selectedBackgroundView = [[UIImageView alloc] initWithImage:img];

    
    value = [style getValue:@"background-color-selected"];
    if (value) self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIStyleSheetConverter toImageFromColor:value]];
    else {
        img = [style gradientImage:@"background-color-selected" frame:self.bounds];
        if (img) self.selectedBackgroundView = [[UIImageView alloc] initWithImage:img];
    }
    
//    value = [style getValue:@"font"];
//    if (value) self.textLabel.font = [UIStyleSheetConverter toFont:value];
}
@end
