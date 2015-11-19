//
//  MsgDetailCell.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MsgDetailCell.h"

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
    
    _timeBtn = [UIButton new];
    [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _timeBtn.titleLabel.font = TIME_FONT;
    _timeBtn.enabled = NO;
    [_timeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_timeBtn];
    
    _iconView = [UIImageView new];
    [self.contentView addSubview:_iconView];
    
    _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _contentBtn.titleLabel.font = CONTENT_FONT;
    _contentBtn.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentBtn];
  }
  return self;
}

- (void) setMessageFrame:(MessageFrame *)messageFrame {
  _messageFrame = messageFrame;
  Message *message = _messageFrame.message;
  
  [_timeBtn setTitle:message.time forState:UIControlStateNormal];
  _timeBtn.frame = _messageFrame.dateFrame;
  
  _iconView.image = [UIImage imageNamed:message.icon];
  _iconView.frame = _messageFrame.iconFrame;
  
  [_contentBtn setTitle:message.content forState:UIControlStateNormal];
  _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(CONTENT_TOP, CONTENT_LEFT, CONTENT_BOTTOM, CONTENT_RIGHT);
  _contentBtn.frame = _messageFrame.contentFrame;
  
  if (message.type == FROM_ME) {
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(CONTENT_TOP, CONTENT_RIGHT, CONTENT_BOTTOM, CONTENT_LEFT);
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
