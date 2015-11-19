//
//  MainTabBar.m
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MainTabBar.h"

@interface MainTabBar ()
{
  //UIButton *_selectedBtn;
}
@end


@implementation MainTabBar

-(instancetype)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    int tagIndex = 0;
    
    _TopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _TopicBtn.tag = tagIndex++ + 1000;
    [_TopicBtn setImage:[UIImage imageNamed:@"top5_a1.png"] forState:UIControlStateNormal];
    [_TopicBtn setImage:[UIImage imageNamed:@"top5_a2.png"] forState:UIControlStateSelected];
    _FavoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _FavoriteBtn.tag = tagIndex++ + 1000;
    [_FavoriteBtn setImage:[UIImage imageNamed:@"top5_b1.png"] forState:UIControlStateNormal];
    [_FavoriteBtn setImage:[UIImage imageNamed:@"top5_b2.png"] forState:UIControlStateSelected];
    _MsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _MsgBtn.tag = tagIndex++ + 1000;
    [_MsgBtn setImage:[UIImage imageNamed:@"top5_c1.png"] forState:UIControlStateNormal];
    [_MsgBtn setImage:[UIImage imageNamed:@"top5_c2.png"] forState:UIControlStateSelected];
    _OrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _OrderBtn.tag = tagIndex++ + 1000;
    [_OrderBtn setImage:[UIImage imageNamed:@"top5_d1.png"] forState:UIControlStateNormal];
    [_OrderBtn setImage:[UIImage imageNamed:@"top5_d2.png"] forState:UIControlStateSelected];
    _SettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SettingBtn.tag = tagIndex++ + 1000;
    [_SettingBtn setImage:[UIImage imageNamed:@"top5_e1.png"] forState:UIControlStateNormal];
    [_SettingBtn setImage:[UIImage imageNamed:@"top5_e2.png"] forState:UIControlStateSelected];
    _MsgBadgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_MsgBadgeBtn setUserInteractionEnabled:NO];
    _OrderBadgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_OrderBadgeBtn setUserInteractionEnabled:NO];
    
    int tabWidth = frame.size.width/tagIndex;
    int tabHeight = frame.size.height;
    _TopicBtn.frame = CGRectMake(0, 0, tabWidth, tabHeight);
    _FavoriteBtn.frame = CGRectMake(tabWidth, 0, tabWidth, tabHeight);
    _MsgBtn.frame = CGRectMake(tabWidth*2, 0, tabWidth, tabHeight);
    _MsgBadgeBtn.frame = CGRectMake(tabWidth*1.75, tabHeight*0.25, tabWidth, tabHeight);
    _OrderBtn.frame = CGRectMake(tabWidth*3, 0, tabWidth, tabHeight);
    _OrderBadgeBtn.frame = CGRectMake(tabWidth*2.75, tabHeight*0.25, tabWidth, tabHeight);
    _SettingBtn.frame = CGRectMake(tabWidth*4, 0, tabWidth, tabHeight);
    [self addSubview:_TopicBtn];
    [self addSubview:_FavoriteBtn];
    [self addSubview:_MsgBtn];
    [self addSubview:_OrderBtn];
    [self addSubview:_SettingBtn];
    [self addSubview:_MsgBadgeBtn];
    [self addSubview:_OrderBadgeBtn];
    
    [_TopicBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_FavoriteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_MsgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_OrderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_SettingBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self btnClick:_TopicBtn];
  }
  return self;
}

-(void) btnClick:(UIButton *)button{
  self.selectedBtn.selected = NO;
  button.selected = YES;
  self.selectedBtn = button;
  [self.delegate changeTabBar:self.selectedBtn.tag-1000 to:button.tag-1000];
  
  //將所有button的layer顏色改為透明
  for( UIButton *btn in self.subviews){
    for (CALayer *layer in btn.layer.sublayers) {
      if([layer.name isEqual: @"underline"]){
        layer.backgroundColor = [UIColor clearColor].CGColor;
      }
    }
  }
  
  bool finded = NO;
  //找到border並將其改為紅色
  for (CALayer *layer in button.layer.sublayers) {
    if([layer.name isEqual: @"underline"]){
      finded = YES;
      layer.backgroundColor = [UIColor colorWithRed:165.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1].CGColor;
    }
  }
  
  //找不到時，則新增一個border
  if(!finded) {
    CALayer *border = [CALayer layer];
    border.name = @"underline";
    border.backgroundColor = [UIColor colorWithRed:165.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1].CGColor;
    int btnWidth = button.frame.size.width;
    int btnHeight = button.frame.size.height;
    border.frame = CGRectMake(0, btnHeight - 3, btnWidth, 3);
    [button.layer addSublayer:border];
  }
  
}



@end

