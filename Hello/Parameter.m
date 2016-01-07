//
//  Parameter.m
//  Hello
//
//  Created by Derek Chou on 2015/11/16.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "Parameter.h"
#import "AppDelegate.h"

@implementation Parameter

+ (NSArray *)getByType:(NSString*)type {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  if([type isKindOfClass:[NSNull class]] || type == nil)
    return nil;
  
  @try {
    //判斷資料是否存在
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:type, nil] forKeys:[NSArray arrayWithObjects:@"TYPE", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchParameterByType" substitutionVariables:dicCondition];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([fetchResult count] > 0) {
      return fetchResult;
    }
  } @catch (NSException * e) {
    NSLog(@"[User getUser] Exception: %@", e);
    return nil;
  }
  return nil;
}

@end
