//
//  IntroPageViewController.h
//  Hello
//
//  Created by Derek Chou on 2016/1/5.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroPageViewController : UIPageViewController<UIPageViewControllerDataSource>

@property NSArray *photoList;
@property NSArray *introStringList;

@end
