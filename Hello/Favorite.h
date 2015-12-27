//
//  Favorite.h
//  Hello
//
//  Created by Derek Chou on 2015/12/26.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Favorite : NSManagedObject

+ (void) addWithArray:(NSMutableArray *)ary;
+ (Favorite *)getByType:(NSString*)type AndID:(NSString*)id;
+ (NSArray*) getAll;

@end

NS_ASSUME_NONNULL_END

#import "Favorite+CoreDataProperties.h"
