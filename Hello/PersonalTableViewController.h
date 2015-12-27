//
//  PersonalTableViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/12/25.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"
#import "HCSStarRatingView.h"

@interface PersonalTableViewController : UITableViewController
@property NSString *personType;
@property NSString *personID;
@property NSMutableArray *productArray;
@end
