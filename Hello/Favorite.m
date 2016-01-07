//
//  Favorite.m
//  Hello
//
//  Created by Derek Chou on 2015/12/26.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "Favorite.h"
#import "AppDelegate.h"
#import "Common.h"

@implementation Favorite

+ (Favorite *)getByType:(NSString*)type AndID:(NSString*)id {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  if([type isKindOfClass:[NSNull class]] || type == nil)
    return nil;
  if([id isKindOfClass:[NSNull class]] || id == nil)
    return nil;
  
  @try {
    //判斷資料是否存在
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:type, id, nil] forKeys:[NSArray arrayWithObjects:@"TYPE", @"ID", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchFavorite" substitutionVariables:dicCondition];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([fetchResult count] > 0) {
      return fetchResult[0];
    }
  } @catch (NSException * e) {
    NSLog(@"[Favorite getUser] Exception: %@", e);
    return nil;
  }
  return nil;
}

+ (void) addWithArray:(NSMutableArray *)ary {
  if (![ary isKindOfClass:[NSArray class]]) {
    return;
  }
  
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchAllFavorite"
                substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:@"", [NSNull null], nil]];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    for (Favorite *favorite in fetchResult) {
      [app.managedObjectContext deleteObject:favorite];
    }
    
    for (NSDictionary *dic in ary) {
      Favorite *favorite = [Favorite getByType:dic[@"_favorite_type"] AndID:dic[@"_favorite_id"]];
      if (favorite == nil) {
        favorite = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite"
                                           inManagedObjectContext:app.managedObjectContext];

        favorite.type = [Common getNSCFString:dic[@"_favorite_type"]];
        favorite.id = [Common getNSCFString:dic[@"_favorite_id"]];
        favorite.insertDT = [Common getNSCFString:dic[@"_name"]];
        
        [app.managedObjectContext save:nil];
      }
    }
  } @catch (NSException * e) {
    NSLog(@"[Favorite addWithDic] Exception: %@", e);
    return;
  }
}

+ (void)addWithType:(NSString*)type AndID:(NSString*)_id {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  if ([Favorite getByType:type AndID:_id]) {
    return;
  }
  Favorite *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite"
                                           inManagedObjectContext:app.managedObjectContext];
  
  favorite.type = type;
  favorite.id = _id;
  
  [app.managedObjectContext save:nil];
}

+ (void)deleteWithType:(NSString*)type AndID:(NSString*)_id {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  Favorite *favorite = [Favorite getByType:type AndID:_id];
  if (favorite)
    [app.managedObjectContext deleteObject:favorite];
}

+ (NSMutableArray*) getAll {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  @try {
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchAllFavorite"
                                                               substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:@"", [NSNull null], nil]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"insertDT"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetch setSortDescriptors:sortDescriptors];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    return [NSMutableArray arrayWithArray:fetchResult];
  } @catch (NSException * e) {
    NSLog(@"[Favorite getAll] Exception: %@", e);
    return nil;
  }
  return nil;
}

@end
