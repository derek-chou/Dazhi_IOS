//
//  TopicTableViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicTableViewController : UITableViewController<UISearchBarDelegate>

@property NSMutableArray *topicTexts;
@property UISearchBar *searchBar;
@property CGPoint lastContentOffset;
@end
