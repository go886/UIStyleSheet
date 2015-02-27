//
//  UIStyleSheetFileMonitor.m
//  UIStyleSheetLib
//
//  Created by go886 on 14/12/1.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "UIStyleSheetFileMonitor.h"

@implementation UIStyleSheetFileMonitor
+(void)watch:(NSString*)path withCallback:(void(^)())callback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    int fileDescriptor = open([path UTF8String], O_EVTONLY);
    
    __block dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,fileDescriptor,
                                                              DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND,
                                                              queue);
    dispatch_source_set_event_handler(source, ^
                                      {
                                          unsigned long flags = dispatch_source_get_data(source);
                                          if (flags) {
                                              dispatch_source_cancel(source);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  callback();
                                              });
                                              
                                              [self watch:path withCallback:callback];
                                          }
                                      });
    dispatch_source_set_cancel_handler(source, ^(void)
                                       {
                                           close(fileDescriptor);
                                       });
    dispatch_resume(source);
}

@end
