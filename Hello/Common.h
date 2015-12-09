//
//  Common.h
//  Hello
//
//  Created by Derek Chou on 2015/11/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Order.h"

@interface Common : NSObject {
}

+ (Common *)instance;
+ (void)downloadImage:(NSString*)UrlString To:(UIImageView*)imageView Cell:(UITableViewCell*) cell SavePath:(NSString*)path;
+ (void)downloadImage:(NSString*)UrlString ToBtn:(UIButton*)btn Cell:(UITableViewCell*) cell SavePath:(NSString*)path;
+ (NSString*)getSetting:(NSString*)key;
+ (NSString*)getParameterByType:(NSString*)type AndKey:(NSString*)key;

+ (NSString*)getPhotoURLByType:(NSString*)type AndID:(NSString*)id;
+ (UIColor*) getUserLevelColor:(int) level;

+ (NSString*) getNSCFString:(NSObject*)obj;
+ (NSNumber*) getNSCFNumber:(NSObject*)obj;
+ (NSArray*) getOtherSide:(Order*)order;

@end
