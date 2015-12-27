//
//  MainTabBarController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBar.h"

@interface MainTabBarController : UITabBarController

@property (nonatomic, strong) MainTabBar *mainTabBar;
//@property (nonatomic, copy) NSString *badgeValue;

- (void)setMsgBadge:(NSString*)badge;
- (void)setOrderBadge:(NSString*)badge;
-(void)changeTabBar:(NSInteger)from to:(NSInteger)to;

@end
