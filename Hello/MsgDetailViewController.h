//
//  MsgDetailViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"
#import "MessageData.h"

@interface MsgDetailViewController : UIViewController<UITextFieldDelegate> {
  IBOutlet UITableView *tableV;
  IBOutlet UITextField *messageField;
  NSMutableArray *_allMessageFrame;
}
@property NSArray *msgAry;
@property NSString *otherType;
@property NSString *otherID;
@end
