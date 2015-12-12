//
//  ViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "ViewController.h"
#import "MainTabBarController.h"
#import "MainTabBar.h"

#import "TopicTableViewController.h"
#import "FavoriteTableViewController.h"
#import "MsgTableViewController.h"
#import "OrderTabBarController.h"
#import "SettingTableViewController.h"
#import "Message.h"

@interface ViewController ()<UIScrollViewDelegate>
{
  
}
@end

@implementation ViewController

MsgTableViewController *msgView;
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.isPageScrollingFlag = NO;
  self.hasAppearedFlag = NO;
  self.currentPageIndex = 0;
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
  self.pageViewController.delegate = self;
  self.pageViewController.dataSource = self;
  
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  
  TopicTableViewController *topicView = (TopicTableViewController*)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"TopicView"];
  FavoriteTableViewController *favoriteView = (FavoriteTableViewController*)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"FavoriteView"];
  msgView = (MsgTableViewController*)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"MsgView"];
  OrderTabBarController *orderView = (OrderTabBarController*)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"OrderView"];
  SettingTableViewController *setView = (SettingTableViewController*)[mainStoryboard
                                          instantiateViewControllerWithIdentifier: @"SettingView"];
  
  _controllers = @[topicView, favoriteView, msgView, orderView, setView];
  
  //定時取Msg
  //[msgView startTimer];
  //[(MainTabBarController*)self.tabBarController setMsgBadge:[msgView msgBadge]];

  //msgView = [MsgTableViewController new];
  //[msgView loadView];
  
  [self.pageViewController setViewControllers:@[topicView] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
  [self addChildViewController:self.pageViewController];
  
  [self.view addSubview:self.pageViewController.view];
  
  CGRect pageViewRect = self.view.bounds;
  //status bar(20)加上tab bar(49)的高度=69
  pageViewRect.origin.y += 69;
  pageViewRect.size.height -= 69;
  self.pageViewController.view.frame = pageViewRect;
  
  //先以Timer來暫代APNS(push server)
  [msgView prepareMessageGroup];
  [(MainTabBarController*)self.tabBarController setMsgBadge:[msgView msgBadge]];
  //[self timerPolling:_pollingTimer];
  _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                            target:self
                                          selector:@selector(timerPolling:)
                                          userInfo:nil
                                           repeats:true];
}

-(void)timerPolling:(NSTimer *)timer {
  NSString *lastSeq = [Message getMaxSeq];
  int seq = [lastSeq integerValue];
  seq++;
  [msgView loadMessageTexts:[NSString stringWithFormat:@"%d", seq]];
  [(MainTabBarController*)self.tabBarController setMsgBadge:[msgView msgBadge]];
}


-(void)viewWillAppear:(BOOL)animated {
  if (!self.hasAppearedFlag) {
    [self setupPageViewController];
    self.hasAppearedFlag = YES;
  }
}

-(void)setupPageViewController {
  self.pageViewController = (UIPageViewController*)self.childViewControllers.firstObject;
  self.pageViewController.delegate = self;
  self.pageViewController.dataSource = self;
  
  [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
  [self syncScrollView];
}

-(void)segmentedControlChange:(UISegmentedControl * )segmentedControl{
  if (!self.isPageScrollingFlag) {
    NSInteger tempIndex = self.currentPageIndex;
    __weak typeof(self) weakSelf = self;
    
    //由左拖到右
    if (segmentedControl.selectedSegmentIndex > tempIndex) {
      //%%% scroll through all the objects between the two points
      for (int i = (int)tempIndex+1; i<=segmentedControl.selectedSegmentIndex; i++) {
        [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
          
          //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
          //then it updates the page that it's currently on
          if (complete) {
            [weakSelf updateCurrentPageIndex:i];
          }
        }];
      }
    }
    //由右拖到左
    else if (segmentedControl.selectedSegmentIndex < tempIndex) {
      for (int i = (int)tempIndex-1; i >= segmentedControl.selectedSegmentIndex; i--) {
        [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
          if (complete) {
            [weakSelf updateCurrentPageIndex:i];
          }
        }];
      }
    }
  }
}

-(void)changeTabBar:(NSInteger)index{
  if (!self.isPageScrollingFlag) {
    
    NSInteger tempIndex = self.currentPageIndex;
    
    __weak typeof(self) weakSelf = self;
    
    //由左拖到右
    if (index > tempIndex) {
      //%%% scroll through all the objects between the two points
      for (int i = (int)tempIndex+1; i<=index; i++) {
        [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
          
          //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
          //then it updates the page that it's currently on
          if (complete) {
            [weakSelf updateCurrentPageIndex:i];
          }
        }];
      }
    }
    //由右拖到左
    else if (index < tempIndex) {
      for (int i = (int)tempIndex-1; i >= index; i--) {
        [self.pageViewController setViewControllers:@[[_controllers objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
          if (complete) {
            [weakSelf updateCurrentPageIndex:i];
          }
        }];
      }
    }
  }
}

-(void)updateCurrentPageIndex:(int)newIndex {
  self.currentPageIndex = newIndex;
}

#pragma mark - UIPageViewController delegate methods
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
  if (completed) {
    self.currentPageIndex = [_controllers indexOfObject:[pageViewController.viewControllers lastObject]];
    MainTabBarController *mainTabBarVC =  (MainTabBarController *)self.tabBarController;
    MainTabBar *mainTabBar = mainTabBarVC.mainTabBar;
    UIButton *btn = (UIButton *)[mainTabBar viewWithTag:self.currentPageIndex+1000];
    [mainTabBar btnClick:btn];
    
  }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
  NSUInteger index = [_controllers indexOfObject:viewController];
  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }
  index--;
  
  return _controllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
  NSUInteger index = [_controllers indexOfObject:viewController];
  
  if (index == NSNotFound) {
    return nil;
  }
  index++;
  if (index == [_controllers count]) {
    return nil;
  }
  return _controllers[index];
}

-(void)syncScrollView {
  for (UIView* view in self.pageViewController.view.subviews){
    if([view isKindOfClass:[UIScrollView class]]) {
      self.pageScrollView = (UIScrollView *)view;
      self.pageScrollView.delegate = self;
    }
  }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  self.isPageScrollingFlag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  self.isPageScrollingFlag = NO;
}



@end
