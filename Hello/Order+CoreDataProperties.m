//
//  Order+CoreDataProperties.m
//  Hello
//
//  Created by Derek Chou on 2015/12/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Order+CoreDataProperties.h"

@implementation Order (CoreDataProperties)

@dynamic orderID;
@dynamic buyerType;
@dynamic buyerID;
@dynamic sellerType;
@dynamic sellerID;
@dynamic productID;
@dynamic buyDT;
@dynamic sellerConfirmDT;
@dynamic buyerConfirmDT;
@dynamic memo;
@dynamic numberOfPeople;
@dynamic travelDay;
@dynamic cancelDT;

@end
