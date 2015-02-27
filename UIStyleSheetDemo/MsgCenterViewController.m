//
//  MsgCenterViewController.m
//  UIStyleSheet
//
//  Created by go886 on 14-9-27.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import "MsgCenterViewController.h"
#import "UIStyleSheet.h"

@implementation MsgCenterViewController {
    NSArray* items;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    
    items = @[@{@"title":@"1", @"img":@"skin/default/icon.png"},
              @{@"title":@"1", @"img":@"skin/default/icon.png"},
              @{@"title":@"1", @"img":@"skin/default/icon.png"},
              @{@"title":@"1", @"img":@"skin/default/icon.png"},
              @{@"title":@"1", @"img":@"skin/default/icon.png"},
              @{@"title":@"1", @"img":@"skin/default/icon.png"}
              ];
    
    
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView* tableview = [UITableView new];
    tableview.frame = self.view.bounds;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.detailTextLabel.styleName = @"detail";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row:%d", indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"detail:%d", indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"skin/default/icon.png"];
    
    
    
    return cell;
}

#pragma UITableViewDelegate
@end
