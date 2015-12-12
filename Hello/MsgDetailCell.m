//
//  MsgDetailCell.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MsgDetailCell.h"
#import "Common.h"
#import "User.h"

@implementation MsgDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style  reuseIdentifier:reuseIdentifier];
  
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    
    _dateBtn = [UIButton new];
    [_dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _dateBtn.titleLabel.font = DATE_FONT;
    _dateBtn.enabled = NO;
    [_dateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_dateBtn];
    
    _iconBtn = [CircleButton new];
    [self.contentView addSubview:_iconBtn];
    
    _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _contentBtn.titleLabel.font = CONTENT_FONT;
    _contentBtn.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentBtn];
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _timeBtn.titleLabel.font = TIME_FONT;
    _timeBtn.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:_timeBtn];
    
  }
  return self;
}

- (void) setMessageFrame:(MessageFrame *)messageFrame {
  _messageFrame = messageFrame;
  MessageData *message = _messageFrame.message;
  
  [_dateBtn setTitle:message.date forState:UIControlStateNormal];
  _dateBtn.frame = _messageFrame.dateFrame;
  
  //_iconView.image = [UIImage imageNamed:message.icon];
  [_iconBtn setImage:message.iconImage.image forState:UIControlStateNormal];
  //畫圓框
  int userLevel = 0;
  User *user = [User getByType:message.otherType AndID:message.otherID];
  if (user != nil)
    userLevel = [user.level intValue];
  
  _iconBtn.frame = _messageFrame.iconFrame;
  [_iconBtn drawCircleButton:[Common getUserLevelColor:userLevel]];
  
  [_contentBtn setTitle:message.content forState:UIControlStateNormal];
  _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(CONTENT_TOP, CONTENT_LEFT, CONTENT_BOTTOM, CONTENT_RIGHT);
  _contentBtn.frame = _messageFrame.contentFrame;
  if (message.type == FROM_ME) {
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(CONTENT_TOP, CONTENT_RIGHT, CONTENT_BOTTOM, CONTENT_LEFT);
  }

  [_timeBtn setTitle:message.time forState:UIControlStateNormal];
  _timeBtn.titleLabel.numberOfLines = 0;
  _timeBtn.contentEdgeInsets = UIEdgeInsetsMake(TIME_TOP, TIME_LEFT, TIME_BOTTOM, TIME_RIGHT);
  _timeBtn.frame = _messageFrame.timeFrame;
  if (message.type == FROM_ME) {
    _timeBtn.contentEdgeInsets = UIEdgeInsetsMake(TIME_TOP, TIME_RIGHT, TIME_BOTTOM, TIME_LEFT);
  }
  
  UIImage *normal, *focused;
  if (message.type == FROM_ME) {
    normal = [UIImage imageNamed:@"MsgGreen"];
    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.4  topCapHeight:normal.size.height * 0.7];
    focused = [UIImage imageNamed:@"MsgGray"];
    focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.4  topCapHeight:focused.size.height * 0.7];
  } else {
    normal = [UIImage imageNamed:@"MsgGray"];
    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.4 topCapHeight:normal.size.height * 0.7];
    focused = [UIImage imageNamed:@"MsgGray"];
    focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.4 topCapHeight:focused.size.height * 0.7];
  }
  [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
  [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
}

@end
