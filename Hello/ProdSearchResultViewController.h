//
//  ProdSearchResultViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  SEARCH_BY_TOPIC = 0,
  SEARCH_BY_KEYWORD = 1
} SearchType;

@interface ProdSearchResultViewController : UITableViewController

@property NSMutableArray *productArray;
@property NSMutableDictionary *productDic;
@property NSMutableDictionary *userDic;

@property SearchType searchType;
@property NSString *searchText;
//@property(nonatomic,retain) UIView *tableFooterView;

@end
