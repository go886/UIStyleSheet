//
//  FirstViewController.m
//  UIStyleSheetDemo
//
//  Created by go886 on 14-9-26.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "FirstViewController.h"
#import "SkinMgr.h"
#import "UIStyleSheet.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.btn setStyleName:@"skinbtn"];
    [self.btn addTarget:self action:@selector(onChangedSkin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onChangedSkin {
    NSArray* items = @[@"default",
                       @"test"];
    
    for (NSString* name in items) {
        if (![[SkinMgr instance].skinName isEqual:name]) {
            [[SkinMgr instance] setSkinName:name];
            break;
        }
    }
}
@end
