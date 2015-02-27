//
//  UIStyleSheetSwizzler.m
//  test_CSS
//
//  Created by go886 on 14-9-23.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIStyleSheetSwizzler.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>

#import "UIStyleSheet.h"
#import "UIStyleSheet+insider.h"

@implementation UIStyleSheetSwizzler
-(void)swizzlerAll {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        SEL oldSelector = NSSelectorFromString(@"willMoveToWindow:");
        Method oldMethod = class_getInstanceMethod([UIView class], oldSelector);
        
        void (*oldImplementation)(id, SEL, id) = (typeof(oldImplementation))method_getImplementation(oldMethod);
        void(^newBlock)(id,id) = ^(__unsafe_unretained UIView *obj, __unsafe_unretained UIWindow* window) {
            oldImplementation(obj, oldSelector, window);
            [obj applyUIForWindow:window];
        };
        IMP newImplementation = imp_implementationWithBlock(newBlock);
        class_replaceMethod([UIView class], oldSelector, newImplementation, method_getTypeEncoding(oldMethod));
    });
}
@end
