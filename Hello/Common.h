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
+ (void)setSettingForKey:(NSString*)key Value:(NSString*)value;
+ (NSString*)getParameterByType:(NSString*)type AndKey:(NSString*)key;

+ (NSString*)getPhotoURLByType:(NSString*)type AndID:(NSString*)id;
+ (UIColor*) getUserLevelColor:(int) level;

+ (NSString*) getNSCFString:(NSObject*)obj;
+ (NSNumber*) getNSCFNumber:(NSObject*)obj;
+ (void)alertTitle:(NSString*)title Msg:(NSString*)msg View:(UIViewController*)view Back:(BOOL)isBack;

+ (void) loadUserByType:(NSString*)userType AndID:(NSString*)userID;
+ (void) loadUserToLabel:(UILabel*)lbl ByType:(NSString*)userType AndID:(NSString*)userID;

+ (NSString*) convertLangCodeToString:(NSString*)langCode;
+ (NSString*) convertJobCodeToString:(NSString*)jobCode;
@end
