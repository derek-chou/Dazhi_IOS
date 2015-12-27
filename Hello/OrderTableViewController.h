//
//  OrderTableViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/12/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewController : UITableViewController
@property NSMutableArray *orderArray;
@property NSArray *currentOrders;
@property NSArray *historyOrders;
@property NSOperationQueue *opQueue;
@property int tabTag;
@property int orderBadge;
@property NSTimer *pollingTimer;

-(void)loadData;
-(void)loadOrderData:(NSString*)seq;
-(int) getBadge;

@end
