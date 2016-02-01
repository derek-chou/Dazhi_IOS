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
#import "MainTabBarController.h"
#import "MainTabBar.h"
#import "ViewController.h"
#import "WebViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //None seperator line when cell is empty
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  int screenHeight = UIScreen.mainScreen.bounds.size.height;
  int screenWidth = UIScreen.mainScreen.bounds.size.width;
  UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-104, screenWidth, 40.0)];
  UIButton *changeModeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  changeModeButton.frame = CGRectMake(0, 0, screenWidth, 40.0);
  [changeModeButton setBackgroundColor:[[UIColor alloc]initWithRed:160.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
  [changeModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [changeModeButton setTitle:@"切換導遊模式" forState:UIControlStateNormal];
  [changeModeButton addTarget:self action:@selector(changeModeClick:) forControlEvents:UIControlEventTouchUpInside];
  // add to a view
  [bottomView addSubview:changeModeButton];
  [self.view addSubview:bottomView];
  
  self.userMode = VISITOR_MODE;
}

- (void)changeModeClick:(id)sender {
  
  ViewController *viewController = (ViewController*)self.parentViewController.parentViewController;
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  WebViewController *view1 = (WebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"WebViewController"];
  view1.webPage = @"http://www.cnn.com";
  WebViewController *view2 = (WebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"WebViewController"];
  view2.webPage = @"http://www.appledaily.com.tw/animation/";
  WebViewController *view3 = (WebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"WebViewController"];
  view3.webPage = @"http://www.yahoo.com";
  WebViewController *view4 = (WebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"WebViewController"];
  view4.webPage = @"http://www.ithome.com.tw/";
  if(self.visitorPages == nil)
    self.visitorPages = viewController.controllers;
  if(self.guidePages == nil)
    self.guidePages = @[view1, view2, view3, view4, [self.visitorPages lastObject]];
  
  MainTabBarController *tabBarController = (MainTabBarController*)[self tabBarController];
  MainTabBar *tabBar = tabBarController.mainTabBar;
  
  if (self.userMode == VISITOR_MODE) {
    self.userMode = GUIDE_MODE;
    [tabBar.TopicBtn setImage:[UIImage imageNamed:@"top5_f1.png"] forState:UIControlStateNormal];
    [tabBar.TopicBtn setImage:[UIImage imageNamed:@"top5_f2.png"] forState:UIControlStateSelected];
    [tabBar.FavoriteBtn setImage:[UIImage imageNamed:@"top5_g1.png"] forState:UIControlStateNormal];
    [tabBar.FavoriteBtn setImage:[UIImage imageNamed:@"top5_g2.png"] forState:UIControlStateSelected];
    [tabBar.MsgBtn setImage:[UIImage imageNamed:@"top5_h1.png"] forState:UIControlStateNormal];
    [tabBar.MsgBtn setImage:[UIImage imageNamed:@"top5_h2.png"] forState:UIControlStateSelected];
    [tabBar.OrderBtn setImage:[UIImage imageNamed:@"top5_i1.png"] forState:UIControlStateNormal];
    [tabBar.OrderBtn setImage:[UIImage imageNamed:@"top5_i2.png"] forState:UIControlStateSelected];
    [tabBar.SettingBtn setImage:[UIImage imageNamed:@"top5_j1.png"] forState:UIControlStateNormal];
    [tabBar.SettingBtn setImage:[UIImage imageNamed:@"top5_j2.png"] forState:UIControlStateSelected];
    [(UIButton*)sender setTitle:@"切換遊客模式" forState:UIControlStateNormal];
    viewController.controllers = self.guidePages;
  } else {
    self.userMode = VISITOR_MODE;
    [tabBar.TopicBtn setImage:[UIImage imageNamed:@"top5_a1.png"] forState:UIControlStateNormal];
    [tabBar.TopicBtn setImage:[UIImage imageNamed:@"top5_a2.png"] forState:UIControlStateSelected];
    [tabBar.FavoriteBtn setImage:[UIImage imageNamed:@"top5_b1.png"] forState:UIControlStateNormal];
    [tabBar.FavoriteBtn setImage:[UIImage imageNamed:@"top5_b2.png"] forState:UIControlStateSelected];
    [tabBar.MsgBtn setImage:[UIImage imageNamed:@"top5_c1.png"] forState:UIControlStateNormal];
    [tabBar.MsgBtn setImage:[UIImage imageNamed:@"top5_c2.png"] forState:UIControlStateSelected];
    [tabBar.OrderBtn setImage:[UIImage imageNamed:@"top5_d1.png"] forState:UIControlStateNormal];
    [tabBar.OrderBtn setImage:[UIImage imageNamed:@"top5_d2.png"] forState:UIControlStateSelected];
    [tabBar.SettingBtn setImage:[UIImage imageNamed:@"top5_e1.png"] forState:UIControlStateNormal];
    [tabBar.SettingBtn setImage:[UIImage imageNamed:@"top5_e2.png"] forState:UIControlStateSelected];
    [(UIButton*)sender setTitle:@"切換導遊模式" forState:UIControlStateNormal];
    viewController.controllers = self.visitorPages;
  }
  [tabBar btnClick:tabBar.TopicBtn];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
  //self.versionCell.textLabel.text = [NSString stringWithFormat:@"%@.%@", ver, build];

  UILabel *lbl = [UILabel new];
  lbl.text = [NSString stringWithFormat:@"%@.%@", ver, build];
  CGSize size = [[UIScreen mainScreen] bounds].size;
  lbl.frame = CGRectMake(size.width - 70, size.height - 125, 30, 10);
  lbl.lineBreakMode = NSLineBreakByWordWrapping;
  CGSize maximumLabelSize = CGSizeMake(lbl.frame.size.width, lbl.frame.size.width);
  CGSize expectSize = [lbl sizeThatFits:maximumLabelSize];
  lbl.frame = CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, expectSize.width, expectSize.height);
  [self.tableView addSubview:lbl];
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
  int row = (int)indexPath.row;
  NSString *fileName = @"";
  switch (row) {
    case 0: fileName = @"setting"; break;
    case 1: fileName = @"FAQ"; break;
    case 2: fileName = @"privacy"; break;
    case 3: fileName = @"rules"; break;
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
  } else if (row == 5) {
    UIViewController *view = [mainStoryboard instantiateViewControllerWithIdentifier: @"OtherSettingView"];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
    return;
  }
  //NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  //[Common alertTitle:@"" Msg:ver View:self Back:NO];
}


@end
