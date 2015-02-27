//
//  UIStyleSheetFileMonitor.h
//  UIStyleSheetLib
//
//  Created by go886 on 14/12/1.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIStyleSheetFileMonitor : NSObject
+(void)watch:(NSString*)path withCallback:(void(^)())handler;
@end
