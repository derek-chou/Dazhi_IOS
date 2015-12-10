//
//  MsgTableViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/17.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgTableViewController : UITableViewController
@property NSMutableArray *messageTexts;
@property NSMutableDictionary *messageGroup;
@property NSMutableDictionary *groupBadge;
@property NSString *msgBadge;

- (void)timerEvent:(NSTimer *)timer;
@property NSTimer *timer;
-(void)startTimer;
@end
