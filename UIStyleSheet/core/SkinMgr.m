//
//  SkinMgr.m
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "SkinMgr.h"
#import "UIStyleSheet.h"
#import "UIStyleSheetSwizzler.h"
#import "UIStyleSheetFileMonitor.h"


@implementation SkinMgr
+(instancetype)instance {
    static SkinMgr* __instance;
    if (!__instance) {
        [[UIStyleSheetSwizzler new] swizzlerAll];
        __instance = [SkinMgr new];
    }
    
    return __instance;
}

-(NSString*)skinDir {
    if (!_skinDir) {
        _skinDir = [[NSBundle mainBundle] pathForResource:@"skin" ofType:nil];
    }
    return _skinDir;
}

-(void)setSkinName:(NSString *)skinName {
    _skinName = skinName;
    
    NSString* curSkinDir = [self.skinDir stringByAppendingPathComponent:skinName];
    NSString* skinFileName = [curSkinDir stringByAppendingPathComponent:@"skin.css"];
    
    NSLog(@"setSkinName:%@", skinFileName);
    [UIStyleSheet setDefaultStyleSheet:[UIStyleSheet initWithFile:skinFileName]];
    
    if (self.enabledAutoUpdate) {
        [UIStyleSheetFileMonitor watch:skinFileName withCallback:^{
            [UIStyleSheet setDefaultStyleSheet:[UIStyleSheet initWithFile:skinFileName]];
        }];
    }
}
@end
