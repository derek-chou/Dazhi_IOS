//
//  Order+CoreDataProperties.h
//  Hello
//
//  Created by Derek Chou on 2015/12/21.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Order.h"

NS_ASSUME_NONNULL_BEGIN

@interface Order (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *buyDT;
@property (nullable, nonatomic, retain) NSString *buyerConfirmDT;
@property (nullable, nonatomic, retain) NSString *buyerID;
@property (nullable, nonatomic, retain) NSString *buyerType;
@property (nullable, nonatomic, retain) NSString *cancelDT;
@property (nullable, nonatomic, retain) NSString *memo;
@property (nullable, nonatomic, retain) NSNumber *numberOfPeople;
@property (nullable, nonatomic, retain) NSString *orderID;
@property (nullable, nonatomic, retain) NSString *productID;
@property (nullable, nonatomic, retain) NSString *sellerConfirmDT;
@property (nullable, nonatomic, retain) NSString *sellerID;
@property (nullable, nonatomic, retain) NSString *sellerType;
@property (nullable, nonatomic, retain) NSString *travelDay;
@property (nullable, nonatomic, retain) NSNumber *amount;

@end

NS_ASSUME_NONNULL_END
