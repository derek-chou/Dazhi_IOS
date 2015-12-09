//
//  Product.m
//  Hello
//
//  Created by Derek Chou on 2015/12/8.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "Product.h"
#import "AppDelegate.h"
#import "Common.h"

@implementation Product

+ (Product *)getByID:(NSString*)prodID {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    //判斷資料是否存在
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:prodID, nil]
                                                    forKeys:[NSArray arrayWithObjects:@"PRODUCT_ID", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchProduct" substitutionVariables:dicCondition];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([fetchResult count] > 0) {
      return fetchResult[0];
    }
  } @catch (NSException * e) {
    NSLog(@"[Product getByID] Exception: %@", e);
    return nil;
  }
  return nil;
}

+ (void) addWithDic:(NSDictionary *)dic {
  if (![dic isKindOfClass:[NSDictionary class]]) {
    return;
  }
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    NSString *prodID = [Common getNSCFString:dic[@"_product_id"]];
    Product *product = [Product getByID:prodID];
    if (product == nil)
      product = [NSEntityDescription insertNewObjectForEntityForName:@"Product"
                                           inManagedObjectContext:app.managedObjectContext];
    product.userType = [Common getNSCFString:dic[@"_usertype"]];
    product.userID = [Common getNSCFString:dic[@"_userid"]];
    product.productID = [Common getNSCFString:dic[@"_product_id"]];
    product.title = [Common getNSCFString:dic[@"_title"]];
    product.content = [Common getNSCFString:dic[@"_content"]];
    product.price = [Common getNSCFString:dic[@"_price"]];
    product.currency = [Common getNSCFString:dic[@"_currency"]];
    product.cityCode = [Common getNSCFString:dic[@"_city"]];
    product.imageList = [Common getNSCFString:dic[@"_image"]];
    product.car = dic[@"_car"];
    product.drink = dic[@"_drink"];
    product.photo = dic[@"_photo"];
    product.smoke = dic[@"_smoke"];
    product.memo = [Common getNSCFString:dic[@"_memo"]];
    product.topicID = [Common getNSCFString:dic[@"_topic_id"]];    
    
    [app.managedObjectContext save:nil];
  } @catch (NSException * e) {
    NSLog(@"[User addUser] Exception: %@", e);
    return;
  }
  
}

@end
