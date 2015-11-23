//
//  MsgDetailCell.h
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"
#import "Message.h"
#import "CircleButton.h"

@interface MsgDetailCell : UITableViewCell {
  UIButton  *_dateBtn;
  UIButton *_contentBtn;
  UIButton *_timeBtn;
}
@property CircleButton *iconBtn;
@property (nonatomic, strong) MessageFrame *messageFrame;
@end
