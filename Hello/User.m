//
//  User.m
//  Hello
//
//  Created by Derek Chou on 2015/11/13.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"
#import "Common.h"

@implementation User

+ (User *)getByType:(NSString*)type AndID:(NSString*)id {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  if([type isKindOfClass:[NSNull class]] || type == nil)
    return nil;
  if([id isKindOfClass:[NSNull class]] || id == nil)
    return nil;
  
  @try {
    //判斷資料是否存在
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:type, id, nil] forKeys:[NSArray arrayWithObjects:@"TYPE", @"ID", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchUser" substitutionVariables:dicCondition];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([fetchResult count] > 0) {
      return fetchResult[0];
    }
  } @catch (NSException * e) {
    NSLog(@"[User getUser] Exception: %@", e);
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
    NSString *type = [Common getNSCFString:dic[@"_type"]];
    NSString *userID = [Common getNSCFString:dic[@"_id"]];
    User *user = [User getByType:type AndID:userID];
    if (user == nil)
      user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                            inManagedObjectContext:app.managedObjectContext];
    user.type = [Common getNSCFString:dic[@"_type"]];
    user.id = [Common getNSCFString:dic[@"_id"]];
    user.name = [Common getNSCFString:dic[@"_name"]];
    user.avgScore = [Common getNSCFString:dic[@"_avg_score"]];
    user.scoreCount = [Common getNSCFString:dic[@"_count"]];
    user.gender = [Common getNSCFString:dic[@"_gender"]];
    NSString *age = [NSString stringWithFormat:@"%@", [Common getNSCFString:dic[@"_age"]]];
    user.age = age;
    user.job = [Common getNSCFString:dic[@"_job"]];
    user.lang = [Common getNSCFString:dic[@"_lang"]];
    user.link = [Common getNSCFString:dic[@"_link"]];
    user.level = [Common getNSCFString:dic[@"_level"]];
    user.desc = [Common getNSCFString:dic[@"_desc"]];
    
    [app.managedObjectContext save:nil];
  } @catch (NSException * e) {
    NSLog(@"[User addUser] Exception: %@", e);
    return;
  }
}

+ (void) addWithFavoriteArray:(NSMutableArray *)ary {
  if (![ary isKindOfClass:[NSMutableArray class]]) {
    return;
  }
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    for (NSDictionary *dic in ary) {
      NSString *type = [Common getNSCFString:dic[@"_favorite_type"]];
      NSString *userID = [Common getNSCFString:dic[@"_favorite_id"]];
      User *user = [User getByType:type AndID:userID];
      if (user == nil)
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:app.managedObjectContext];
      user.type = [Common getNSCFString:dic[@"_favorite_type"]];
      user.id = [Common getNSCFString:dic[@"_favorite_id"]];
      user.name = [Common getNSCFString:dic[@"_name"]];
      user.avgScore = [Common getNSCFString:dic[@"_avg_score"]];
      user.scoreCount = [Common getNSCFString:dic[@"_count"]];
      user.gender = [Common getNSCFString:dic[@"_gender"]];
      NSString *age = [NSString stringWithFormat:@"%@", [Common getNSCFString:dic[@"_age"]]];
      user.age = age;
      user.job = [Common getNSCFString:dic[@"_job"]];
      user.lang = [Common getNSCFString:dic[@"_lang"]];
      user.link = [Common getNSCFString:dic[@"_link"]];
      user.level = [Common getNSCFString:dic[@"_level"]];
      user.desc = [Common getNSCFString:dic[@"_desc"]];
      
      [app.managedObjectContext save:nil];
    }
  } @catch (NSException * e) {
    NSLog(@"[User addWithFavoriteDic] Exception: %@", e);
    return;
  }
}

@end
