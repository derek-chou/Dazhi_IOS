//
//  User.m
//  Hello
//
//  Created by Derek Chou on 2015/11/13.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"

@implementation User

// Insert code here to add functionality to your managed object subclass
+ (User *)getUser:(NSString*)type :(NSString*)id {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  if([type isKindOfClass:[NSNull class]])
    return nil;
  if([id isKindOfClass:[NSNull class]])
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

+ (void) addUser:(NSDictionary *)dic {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    User *user;
    user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:app.managedObjectContext];
    user.type = dic[@"_type"];
    user.id = dic[@"_id"];
    user.name = (dic[@"_name"] == [NSNull null]) ? @"" : dic[@"_name"];
    user.avgScore = (dic[@"_avg_score"] == [NSNull null]) ? @"" : dic[@"_avg_score"];
    user.scoreCount = (dic[@"_count"] == [NSNull null]) ? @"" : dic[@"_count"];
    user.gender = (dic[@"_gender"] == [NSNull null]) ? @"" : dic[@"_gender"];
    NSString *age = [NSString stringWithFormat:@"%@", (dic[@"_age"] == [NSNull null]) ? @"" : dic[@"_age"]];
    user.age = age;
    user.job = (dic[@"_job"] == [NSNull null]) ? @"" : dic[@"_job"];
    user.lang = (dic[@"_lang"] == [NSNull null]) ? @"" : dic[@"_lang"];
    user.link = (dic[@"_link"] == [NSNull null]) ? @"" : dic[@"_link"];
    user.level = (dic[@"_level"] == [NSNull null]) ? @"" : dic[@"_level"];
    
    [app.managedObjectContext save:nil];
  } @catch (NSException * e) {
    NSLog(@"[User addUser] Exception: %@", e);
    return;
  }
}


@end
