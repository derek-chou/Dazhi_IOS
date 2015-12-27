//
//  Favorite+CoreDataProperties.h
//  Hello
//
//  Created by Derek Chou on 2015/12/26.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Favorite.h"

NS_ASSUME_NONNULL_BEGIN

@interface Favorite (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *insertDT;

@end

NS_ASSUME_NONNULL_END
