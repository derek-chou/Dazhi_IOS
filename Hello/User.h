//
//  User.h
//  Hello
//
//  Created by Derek Chou on 2015/11/13.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

+ (void) addWithDic:(NSDictionary *)dic;
+ (void) addWithFavoriteArray:(NSMutableArray *)ary;
+ (User *)getByType:(NSString*)type AndID:(NSString*)id;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
