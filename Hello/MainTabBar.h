//
//  MainTabBar.h
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol MainTabBarDelegate <NSObject>

-(void)changeTabBar:(NSInteger)from to:(NSInteger)to;

@end

@interface MainTabBar : UIView

@property (nonatomic , weak) id<MainTabBarDelegate> delegate;
@property (nonatomic) UIButton *selectedBtn;

@property (nonatomic) UIButton *TopicBtn;
@property (nonatomic) UIButton *FavoriteBtn;
@property (nonatomic) UIButton *MsgBtn;
@property (nonatomic) UIButton *OrderBtn;
@property (nonatomic) UIButton *SettingBtn;

@property (nonatomic) UIButton *MsgBadgeBtn;
@property (nonatomic) UIButton *OrderBadgeBtn;

-(void) btnClick:(UIButton *)button;

@end