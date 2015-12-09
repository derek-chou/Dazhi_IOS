//
//  Product+CoreDataProperties.h
//  Hello
//
//  Created by Derek Chou on 2015/12/8.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userType;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *productID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSString *cityCode;
@property (nullable, nonatomic, retain) NSString *imageList;
@property (nullable, nonatomic, retain) NSNumber *car;
@property (nullable, nonatomic, retain) NSNumber *drink;
@property (nullable, nonatomic, retain) NSNumber *photo;
@property (nullable, nonatomic, retain) NSNumber *smoke;
@property (nullable, nonatomic, retain) NSString *memo;
@property (nullable, nonatomic, retain) NSString *topicID;

@end

NS_ASSUME_NONNULL_END
