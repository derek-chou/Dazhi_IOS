//
//  MsgViewCell.h
//  Hello
//
//  Created by Derek Chou on 2015/11/17.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"

@interface MsgViewCell : UITableViewCell

@property IBOutlet UILabel *nameLabel;
@property IBOutlet UILabel *msgLabel;
@property IBOutlet UILabel *datetimeLabel;
@property IBOutlet CircleButton *photoButton;

@end
