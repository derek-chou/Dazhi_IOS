//
//  MessageFrame.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MessageFrame.h"

@implementation MessageFrame
- (void) setMessage:(MessageData *)message {
  _message = message;
  CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
  
  //日期位置
  if (_showDate) {
    CGFloat dateY = MARGIN;
    CGSize dateSize = [_message.datetime sizeWithAttributes:@{UIFontDescriptorSizeAttribute:@"16"}];
    CGFloat dateX = (screenW - dateSize.width) / 2;
    _dateFrame = CGRectMake(dateX, dateY, dateSize.width + DATE_MARGIN_W, dateSize.height + DATE_MARGIN_H);
  }
  
  //頭像位置
  CGFloat iconX = MARGIN;
  CGFloat iconY = CGRectGetMaxY(_dateFrame) + MARGIN;
  if (_message.type == FROM_ME) {
    //iconX = screenW - MARGIN - ICON_WH;
    iconX = screenW;
    _iconFrame = CGRectMake(iconX, iconY, 0, 0);
  } else {
    _iconFrame = CGRectMake(iconX, iconY, ICON_WH, ICON_WH);
  }
  
  //內容位置
  CGFloat contentX = CGRectGetMaxX(_iconFrame) + MARGIN;
  CGFloat contentY = iconY;
  NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:CONTENT_FONT, NSFontAttributeName, nil];
  CGSize contentSize = [_message.content boundingRectWithSize:CGSizeMake(CONTENT_W, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
  if (_message.type == FROM_ME) {
    contentX = iconX - MARGIN - contentSize.width - CONTENT_LEFT - CONTENT_RIGHT;
  }
  _contentFrame = CGRectMake(contentX, contentY, contentSize.width + CONTENT_LEFT + CONTENT_RIGHT, contentSize.height + CONTENT_TOP + CONTENT_BOTTOM);
  
  //time位置
  CGFloat timeX = CGRectGetMaxX(_contentFrame);
  //NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:TIME_FONT, NSFontAttributeName, nil];
  //CGSize timeSize = [_message.content boundingRectWithSize:CGSizeMake(TIME_W, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:timeDic context:nil].size;
  CGFloat timeY = contentY + contentSize.height - TIME_H;
  if (_message.type == FROM_ME) {
    timeX = contentX - TIME_W - TIME_LEFT - TIME_RIGHT;
  }
  _timeFrame = CGRectMake(timeX, timeY, TIME_W+TIME_LEFT+TIME_RIGHT, contentSize.height+TIME_TOP+TIME_BOTTOM);
  
  _cellHeight = MAX(CGRectGetMaxY(_contentFrame), CGRectGetMaxY(_iconFrame)) + MARGIN;
  //NSLog(@"222");
}

@end
