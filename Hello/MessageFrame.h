//
//  MessageFrame.h
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageData.h"

#define MARGIN 8
#define ICON_WH 40
#define DATE_FONT [UIFont systemFontOfSize:11]
#define DATE_MARGIN_W 10
#define DATE_MARGIN_H 10

#define CONTENT_FONT [UIFont systemFontOfSize:14]
#define CONTENT_W [UIScreen mainScreen].bounds.size.width * 0.6
#define CONTENT_H 40
#define CONTENT_LEFT 15
#define CONTENT_RIGHT 10
#define CONTENT_TOP 10
#define CONTENT_BOTTOM 10

#define TIME_FONT [UIFont systemFontOfSize:9]
#define TIME_W 30
#define TIME_H 10
#define TIME_LEFT 0
#define TIME_RIGHT 0
#define TIME_TOP 0
#define TIME_BOTTOM 0

@interface MessageFrame : NSObject
@property (nonatomic, assign, readonly) CGRect dateFrame;
@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect contentFrame;
@property (nonatomic, assign, readonly) CGRect timeFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) MessageData *message;
@property (nonatomic, assign) BOOL showDate;
@end
