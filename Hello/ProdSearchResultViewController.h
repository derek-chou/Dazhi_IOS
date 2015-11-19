//
//  ProdSearchResultViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/11/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProdSearchResultViewController : UITableViewController

@property NSMutableArray *productArray;
@property NSMutableDictionary *productDic;
@property NSString *topicID;
@property NSMutableDictionary *userDic;
//@property(nonatomic,retain) UIView *tableFooterView;

@end
