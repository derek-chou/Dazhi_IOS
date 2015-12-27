//
//  Order.m
//  Hello
//
//  Created by Derek Chou on 2015/12/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "Order.h"
#import "AppDelegate.h"
#import "Common.h"

@implementation Order

+ (Order *)getByID:(NSString*)id {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  if([id isKindOfClass:[NSNull class]])
    return nil;
  
  @try {
    //判斷資料是否存在
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: id, nil] forKeys:[NSArray arrayWithObjects:@"ID", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchOrder"
                                                               substitutionVariables:dicCondition];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([fetchResult count] > 0) {
      return fetchResult[0];
    }
  } @catch (NSException * e) {
    NSLog(@"[Order getByID] Exception: %@", e);
    return nil;
  }
  return nil;
}

+ (NSArray *)getCurrent {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  NSDateFormatter *fmt = [NSDateFormatter new];
  NSDate *now = [NSDate date];
  fmt.dateFormat = @"yyyy/MM/dd";
  NSString *date = [fmt stringFromDate:now];

  @try {
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: date, nil]
                                                    forKeys:[NSArray arrayWithObjects:@"DATE", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchCurrentOrder"
                                                               substitutionVariables:dicCondition];

//    NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:@"orderID" ascending:YES
//      comparator:^(id a, id b) {
//        if ([a length] < [b length]) {
//          return NSOrderedAscending;
//        } else if ([a length] > [b length]) {
//          return NSOrderedDescending;
//        } else {
//          return NSOrderedSame;
//        }
//      }];
    
    NSSortDescriptor *sortByOrderID = [[NSSortDescriptor alloc] initWithKey:@"orderID"
                                                           ascending:NO ];
    NSSortDescriptor *sortByTravelDate = [[NSSortDescriptor alloc] initWithKey:@"travelDay"
                                                           ascending:YES ];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByTravelDate, sortByOrderID, nil];
    [fetch setSortDescriptors:sortDescriptors];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    return fetchResult;
  } @catch (NSException * e) {
    NSLog(@"[Order getCurrent] Exception: %@", e);
    return nil;
  }
  return nil;
}

+ (NSArray *)getHistory {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  NSDateFormatter *fmt = [NSDateFormatter new];
  NSDate *now = [NSDate date];
  fmt.dateFormat = @"yyyy/MM/dd";
  NSString *date = [fmt stringFromDate:now];
  
  @try {
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: date, nil]
                                                             forKeys:[NSArray arrayWithObjects:@"DATE", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchHistoryOrder"
                                                               substitutionVariables:dicCondition];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    return fetchResult;
  } @catch (NSException * e) {
    NSLog(@"[Order getHistory] Exception: %@", e);
    return nil;
  }
  return nil;
}

+ (void) updateWithArray:(NSMutableArray *)ary {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    for (NSDictionary *dic in ary) {
      NSNumber *orderNum = [Common getNSCFNumber:dic[@"_order_id"]];
      NSString *orderID = [NSString stringWithFormat:@"%010d", [orderNum intValue]];

      Order *order = [Order getByID:orderID];
      if (order == nil)
        order = [NSEntityDescription insertNewObjectForEntityForName:@"Order"
                                            inManagedObjectContext:app.managedObjectContext];
      
      order.orderID = [NSString stringWithFormat:@"%10@", orderID];
      order.buyerType = [Common getNSCFString:dic[@"_buyer_type"]];
      order.buyerID = [Common getNSCFString:dic[@"_buyer_id"]];
      order.sellerType = [Common getNSCFString:dic[@"_seller_type"]];
      order.sellerID = [Common getNSCFString:dic[@"_seller_id"]];
      order.productID = [Common getNSCFString:dic[@"_product_id"]];
      order.buyDT = [Common getNSCFString:dic[@"_buy_dt"]];
      order.sellerConfirmDT = [Common getNSCFString:dic[@"_seller_confirm_dt"]];
      order.buyerConfirmDT = [Common getNSCFString:dic[@"_buyer_confirm_dt"]];
      order.memo = [Common getNSCFString:dic[@"_memo"]];
      order.numberOfPeople = [Common getNSCFNumber:dic[@"_number_of_people"]];
      order.travelDay = [Common getNSCFString:dic[@"_travel_day"]];
      order.cancelDT = [Common getNSCFString:dic[@"_cancel_dt"]];
      NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
      f.numberStyle = NSNumberFormatterDecimalStyle;
      order.amount = [f numberFromString:[Common getNSCFString:dic[@"_amount"]]];
    }
    
    [app.managedObjectContext save:nil];
    
  } @catch (NSException * e) {
    NSLog(@"[Order updateWithArray] Exception: %@", e);
    return;
  }
}

+ (NSArray*) getOtherSide:(Order*)order {
  NSMutableArray *ary = [NSMutableArray new];
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  
  if ([order.sellerType isEqualToString:userType] && [order.sellerID isEqualToString:userID]) {
    [ary addObject:order.buyerType];
    [ary addObject:order.buyerID];
  } else if ([order.buyerType isEqualToString:userType] && [order.buyerID isEqualToString:userID]) {
    [ary addObject:order.sellerType];
    [ary addObject:order.sellerID];
  } else {
    [ary addObject:@""];
    [ary addObject:@""];
  }
  
  return ary;
}

@end
