//
//  IntroPageViewController.m
//  Hello
//
//  Created by Derek Chou on 2016/1/5.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import "IntroPageViewController.h"
#import "IntroDetailViewController.h"
#import "MainTabBarController.h"

@interface IntroPageViewController ()

@end

@implementation IntroPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  _photoList = [[NSArray alloc] initWithObjects:@"intro1.png", @"intro2.png", @"intro3.png", @"intro4.png", nil];
  _introStringList = [[NSArray alloc] initWithObjects:
                      @"跟著HELLO!!的好友一起探索全世界",
                      @"發現HELLO!!裏的有趣旅程與好友",
                      @"透過HELLO!!跟好友規畫你的完美旅程",
                      @"讓HELLO!!協助你開始新的旅行",
                      nil];
  
  self.dataSource = self;
  
  IntroDetailViewController *startViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageDetailView"];
  startViewController.introPhotoName = [_photoList objectAtIndex:0];
  startViewController.introString = [_introStringList objectAtIndex:0];
  NSArray *viewControllers = @[startViewController];
  [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  NSString *value =  ((IntroDetailViewController*) viewController).introPhotoName;
  
  NSUInteger Index = [_photoList indexOfObject:value];
  if (Index == 0) {
    return nil;
  }
  
  IntroDetailViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageDetailView"];
  newViewController.introPhotoName = [_photoList objectAtIndex:(Index - 1)];
  newViewController.introString = [_introStringList objectAtIndex:(Index - 1)];
  
  return newViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSString *value =  ((IntroDetailViewController*) viewController).introPhotoName;
  
  NSUInteger Index = [_photoList indexOfObject:value];
  if (Index == [_photoList count] - 1) {
    //最後一頁，再翻頁時則跳至主頁面
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    MainTabBarController *mainView = (MainTabBarController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MainView"];
    mainView.hidesBottomBarWhenPushed = NO;
    //[self.navigationController pushViewController:mainView animated:NO];
    [self presentViewController:mainView animated:NO completion:nil];
    
    return nil;
  }
  
  IntroDetailViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageDetailView"];
  newViewController.introPhotoName = [_photoList objectAtIndex:(Index + 1)];
  newViewController.introString = [_introStringList objectAtIndex:(Index + 1)];
  
  return newViewController;
}

@end
