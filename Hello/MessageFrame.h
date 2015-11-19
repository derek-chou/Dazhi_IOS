//
//  MessageFrame.h
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Message.h"

#define MARGIN 10
#define ICON_WH 40
#define TIME_FONT [UIFont systemFontOfSize:12]
#define TIME_MARGIN_W 10
#define TIME_MARGIN_H 10
#define CONTENT_FONT [UIFont systemFontOfSize:16]
#define CONTENT_W [UIScreen mainScreen].bounds.size.width * 0.6
#define CONTENT_H 40
#define CONTENT_LEFT 15
#define CONTENT_RIGHT 10
#define CONTENT_TOP 10
#define CONTENT_BOTTOM 10

@interface MessageFrame : NSObject
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect dateFrame;
@property (nonatomic, assign, readonly) CGRect contentFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) Message *message;
@property (nonatomic, assign) BOOL showDate;
@end
