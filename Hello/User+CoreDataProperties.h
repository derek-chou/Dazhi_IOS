//
//  User+CoreDataProperties.h
//  Hello
//
//  Created by Derek Chou on 2015/11/20.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSString *avgScore;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *job;
@property (nullable, nonatomic, retain) NSString *lang;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *scoreCount;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *level;

@end

NS_ASSUME_NONNULL_END
