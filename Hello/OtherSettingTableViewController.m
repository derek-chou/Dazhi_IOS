//
//  OtherSettingTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2016/1/28.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import "OtherSettingTableViewController.h"

@interface OtherSettingTableViewController ()

@end

@implementation OtherSettingTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  int row = (int)indexPath.row;
  
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  if (row == 0) {
    UIViewController *view = [mainStoryboard instantiateViewControllerWithIdentifier: @"NotifySettingView"];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
    return;
  }
}

@end
