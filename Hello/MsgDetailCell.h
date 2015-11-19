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

@interface MsgDetailCell : UITableViewCell {
UIButton  *_timeBtn;
UIImageView *_iconView;
UIButton *_contentBtn;
}
@property (nonatomic, strong) MessageFrame *messageFrame;
@end
