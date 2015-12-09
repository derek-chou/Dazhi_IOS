//
//  Order.h
//  Hello
//
//  Created by Derek Chou on 2015/12/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Order : NSManagedObject

+ (Order *)getByID:(NSString*)id;
+ (NSArray *)getCurrent;
+ (NSArray *)getHistory;
+ (void) updateWithArray:(NSMutableArray *)ary;

@end

NS_ASSUME_NONNULL_END

#import "Order+CoreDataProperties.h"
