//
//  Product.h
//  Hello
//
//  Created by Derek Chou on 2015/12/8.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSManagedObject

+ (Product *)getByID:(NSString*)prodID;
+ (void) addWithDic:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END

#import "Product+CoreDataProperties.h"
