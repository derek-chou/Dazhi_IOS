//
//  Message.h
//  Hello
//
//  Created by Derek Chou on 2015/12/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSManagedObject

+ (Message *)getBySeq:(NSString*)seq;
+ (NSString*)getMaxSeq;
+ (NSString*)getMaxNonReadSeqFromOtherType:(NSString*)otherType OtherID:(NSString*)otherID;
+ (NSArray*)getAll;
+ (NSArray*)getWithOtherType:(NSString*)otherType OtherID:(NSString*)otherID;

+ (void) updateWithArray:(NSMutableArray *)ary;

@end

NS_ASSUME_NONNULL_END

#import "Message+CoreDataProperties.h"
