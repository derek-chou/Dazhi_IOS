//
//  OrderTabBarController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/17.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "OrderTabBarController.h"

@interface OrderTabBarController ()

@end

@implementation OrderTabBarController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  [self.tabBar invalidateIntrinsicContentSize];
  
  CGFloat tabSize = 44.0;
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (UIInterfaceOrientationIsLandscape(orientation))
  {
    tabSize = 32.0;
  }
  CGRect tabFrame = self.tabBar.frame;
  tabFrame.size.height = tabSize;
  tabFrame.origin.y = self.view.frame.origin.y;
  self.tabBar.frame = tabFrame;
  
  self.tabBar.translucent = NO;
  self.tabBar.translucent = YES;

  UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
  [item setImage:nil];
  [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor grayColor], NSForegroundColorAttributeName,
                                [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName, nil]
                      forState:UIControlStateNormal];
  [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor redColor], NSForegroundColorAttributeName,
                                [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName, nil]
                      forState:UIControlStateSelected];
  
  item = [self.tabBar.items objectAtIndex:1];
  [item setImage:nil];
  [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor grayColor], NSForegroundColorAttributeName,
                                [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName, nil]
                      forState:UIControlStateNormal];
  [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor redColor], NSForegroundColorAttributeName,
                                [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName, nil]
                      forState:UIControlStateSelected];
  
  //for(UITabBarItem *tab in self.tabBar.items) {
//    [[UITabBarItem appearance]
//     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//        [UIColor blackColor], NSForegroundColorAttributeName,
//        [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName, nil]
//        forState:UIControlStateNormal];
  //}
  
//  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//   [UIColor whiteColor], NSForegroundColorAttributeName,
//   [UIFont fontWithName:@"Helvetica" size:tabFontSize],
//   NSFontAttributeName,
//   nil] forState:UIControlStateNormal];
}



@end
