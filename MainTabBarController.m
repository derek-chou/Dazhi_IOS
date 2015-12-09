//
//  MainTabBarController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainTabBar.h"
#import "ViewController.h"
#import "UIButton+CustomBadge.h"
#import "CustomBadge.h"

@interface MainTabBarController ()<MainTabBarDelegate>

@end
@implementation MainTabBarController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _mainTabBar = [[MainTabBar alloc]initWithFrame:self.tabBar.bounds];
  _mainTabBar.delegate = self;
  _mainTabBar.backgroundColor = [UIColor lightTextColor];
  //使tabbar有透明效果
  //_mainTabBar.backgroundColor =  [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.1];

  [self.tabBar addSubview:_mainTabBar];
  
  CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:@"6"
                                                 withStringColor:[UIColor whiteColor]
                                                  withInsetColor:[UIColor blueColor]
                                                  withBadgeFrame:NO
                                             withBadgeFrameColor:[UIColor whiteColor]
                                                       withScale:.7
                                                     withShining:YES];
  [self.mainTabBar.MsgBadgeBtn setBadge:customBadge1];
  
  CustomBadge *customBadge2 = [CustomBadge customBadgeWithString:@"3"
                                                 withStringColor:[UIColor whiteColor]
                                                  withInsetColor:[UIColor redColor]
                                                  withBadgeFrame:NO
                                             withBadgeFrameColor:[UIColor whiteColor]
                                                       withScale:.7
                                                     withShining:YES];
  [self.mainTabBar.OrderBadgeBtn setBadge:customBadge2];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  //將tabbar置於最上方
  [self.tabBar invalidateIntrinsicContentSize];
  CGFloat tabSize = 49.0;
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (UIInterfaceOrientationIsLandscape(orientation))
    tabSize = 32.0;
  CGRect tabFrame = self.tabBar.frame;
  tabFrame.size.height = tabSize;
  
  CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  tabFrame.origin.y = self.view.frame.origin.y + statusBarHeight;
  //tabFrame.origin.y = statusBarHeight;
  self.tabBar.frame = tabFrame;
  
  //讓bar重畫，避開手機轉向時UI沒更新
  self.tabBar.translucent = NO;
  self.tabBar.translucent = YES;
  self.tabBar.opaque = NO;
}


-(void)changeTabBar:(NSInteger)from to:(NSInteger)to{
  UINavigationController *nav = (UINavigationController *)self.selectedViewController;
  ViewController *vc = (ViewController *)nav.viewControllers.firstObject;
  [vc changeTabBar:to];

}



@end

