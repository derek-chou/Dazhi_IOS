//
//  SettingTableViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/17.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  VISITOR_MODE = 0,
  GUIDE_MODE = 1
} UserMode;

@interface SettingTableViewController : UITableViewController
@property (weak) IBOutlet UITableViewCell *versionCell;
@property UserMode userMode;
@property NSArray *visitorPages;
@property NSArray *guidePages;
@end
