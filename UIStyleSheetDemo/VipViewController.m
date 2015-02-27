//
//  VipViewController.m
//  UIStyleSheet
//
//  Created by go886 on 14-9-27.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "VipViewController.h"

@implementation VipViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView* v = [UIWebView new];
    [v loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    v.frame = self.view.bounds;
    [self.view addSubview:v];
}
@end
