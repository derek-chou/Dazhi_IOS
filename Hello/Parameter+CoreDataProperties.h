//
//  Parameter+CoreDataProperties.h
//  Hello
//
//  Created by Derek Chou on 2015/11/16.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Parameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Parameter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *key;
@property (nullable, nonatomic, retain) NSString *value;

@end

NS_ASSUME_NONNULL_END
