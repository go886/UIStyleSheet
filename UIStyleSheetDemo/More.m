//
//  More.m
//  UIStyleSheet
//
//  Created by go886 on 14-9-26.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "More.h"
#import "MsgCenterViewController.h"
#import "VipViewController.h"
@implementation More
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
}
-(IBAction)onMsgCenter:(id)sender {
    [self.navigationController pushViewController:[MsgCenterViewController new] animated:YES];
}
-(IBAction)onVip:(id)sender {
    [self.navigationController pushViewController:[VipViewController new] animated:YES];
}
-(IBAction)onHuoDong:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
@end
