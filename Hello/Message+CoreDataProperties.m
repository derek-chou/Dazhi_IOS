//
//  Message+CoreDataProperties.m
//  Hello
//
//  Created by Derek Chou on 2015/12/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

@dynamic seqID;
@dynamic fromType;
@dynamic fromID;
@dynamic toType;
@dynamic toID;
@dynamic msg;
@dynamic insertDT;
@dynamic readDT;
@dynamic fromName;
@dynamic toName;

@end
