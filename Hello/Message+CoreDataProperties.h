//
//  Message+CoreDataProperties.h
//  Hello
//
//  Created by Derek Chou on 2015/12/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *seqID;
@property (nullable, nonatomic, retain) NSString *fromType;
@property (nullable, nonatomic, retain) NSString *fromID;
@property (nullable, nonatomic, retain) NSString *toType;
@property (nullable, nonatomic, retain) NSString *toID;
@property (nullable, nonatomic, retain) NSString *msg;
@property (nullable, nonatomic, retain) NSString *insertDT;
@property (nullable, nonatomic, retain) NSString *readDT;
@property (nullable, nonatomic, retain) NSString *fromName;
@property (nullable, nonatomic, retain) NSString *toName;

@end

NS_ASSUME_NONNULL_END
