//
//  MsgTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/17.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MsgTableViewController.h"
#import "ViewController.h"
#import "MsgViewCell.h"

@interface MsgTableViewController ()

@end

@implementation MsgTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  self.parentViewController.parentViewController.navigationItem.title = @"Hello";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"MsgCell";
  
  //cell如不存在，則建立之
  MsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[MsgViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  cell.msgLabel.text = [NSString stringWithFormat:@"Msg %li",(long)indexPath.row];
  [cell.photoButton setImage:[UIImage imageNamed:@"top5_c1.png"] forState:UIControlStateNormal];
  
  //畫圓框
  [cell.photoButton drawCircleButton:[UIColor redColor]];
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  UITableViewController *detailView = (UITableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MsgDetailView"];
  detailView.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:detailView animated:NO];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  if ([segue.identifier isEqualToString:@"PersonalView"]) {
//    NSLog(@"aaa");
//  }
}

@end
