//
//  SettingTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/17.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "SettingTableViewController.h"
#import "QuestionAndAnswerViewController.h"
#import "Common.h"
#import "PersonalSettingViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  int row = indexPath.row;
  NSString *fileName = @"";
  switch (row) {
    case 1: fileName = @"FAQ"; break;
    case 2: fileName = @"privacy"; break;
    case 3: fileName = @"standard"; break;
    case 4: fileName = @"about"; break;
    default: break;
  }
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  if (![fileName isEqualToString:@""]) {
    QuestionAndAnswerViewController *qaView = (QuestionAndAnswerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"QuestionAndAnswerView"];
    qaView.fileName = fileName;
    qaView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qaView animated:YES];
    return;
  }
  
  if (row == 0) {
    PersonalSettingViewController *psView = (PersonalSettingViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PersonalSettingView"];
    psView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:psView animated:YES];
    return;
  }
  
  [Common alertTitle:@"" Msg:@"Coming soon!!!!" View:self Back:NO];
}


@end
