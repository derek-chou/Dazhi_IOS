//
//  ViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property(nonatomic,strong) UIPageViewController *pageViewController;
@property(nonatomic,assign) BOOL isPageScrollingFlag;
@property(nonatomic,copy)   NSArray *controllers;
@property(nonatomic,assign) NSUInteger currentPageIndex;
@property(nonatomic,strong) UIScrollView *pageScrollView;
@property(nonatomic,assign) BOOL hasAppearedFlag;

-(void)changeTabBar:(NSInteger)index;

@end

