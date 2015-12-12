//
//  Message.m
//  Hello
//
//  Created by Derek Chou on 2015/12/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "Message.h"
#import "AppDelegate.h"
#import "Common.h"

@implementation Message

+ (Message *)getBySeq:(NSString*)seq {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  if([seq isKindOfClass:[NSNull class]])
    return nil;
  
  @try {
    //判斷資料是否存在
    NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: seq, nil] forKeys:[NSArray arrayWithObjects:@"SEQ_ID", nil]];
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchMessageBySeq"
                                                               substitutionVariables:dicCondition];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([fetchResult count] > 0) {
      return fetchResult[0];
    }
  } @catch (NSException * e) {
    NSLog(@"[Message getBySeq] Exception: %@", e);
    return nil;
  }
  return nil;
}

+ (NSString*)getMaxSeq {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message"
                                              inManagedObjectContext:app.managedObjectContext];
    [request setEntity:entity];
    
    //NSPredicate *p1 = [NSPredicate predicateWithFormat:@"readDT==''"];
    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"seqID==max(seqID)"];
    
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1]];
    request.sortDescriptors = [NSArray array];
    
    NSArray *array = [app.managedObjectContext executeFetchRequest:request error:nil];
    if ([array count] > 0) {
      return ((Message*)array[0]).seqID;
    }
  } @catch (NSException * e) {
    NSLog(@"[Message getMaxSeq] Exception: %@", e);
    return @"0";
  }
  return @"0";
}

+ (NSString*)getMaxNonReadSeqFromOtherType:(NSString*)otherType OtherID:(NSString*)otherID {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message"
                                              inManagedObjectContext:app.managedObjectContext];
    [request setEntity:entity];
    
    NSString *userType = [Common getSetting:@"User Type"];
    NSString *userID = [Common getSetting:@"User ID"];
    NSString *pred = [NSString stringWithFormat:@"(fromType='%@' and fromID='%@' and toType='%@' and toID='%@')",
                      otherType, otherID, userType, userID];
    NSPredicate *p1 = [NSPredicate predicateWithFormat:pred];
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"readDT==''"];
    
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    request.sortDescriptors = [NSArray array];
    
    NSArray *array = [app.managedObjectContext executeFetchRequest:request error:nil];
    Message *msgObj = [array lastObject];
    if (msgObj) {
      return msgObj.seqID;
    }
  } @catch (NSException * e) {
    NSLog(@"[Message getMaxSeq] Exception: %@", e);
    return @"0";
  }
  return @"0";
}

+ (NSArray*)getWithOtherType:(NSString*)otherType OtherID:(NSString*)otherID {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message"
                                              inManagedObjectContext:app.managedObjectContext];
    [request setEntity:entity];
    
    NSString *pred = [NSString stringWithFormat:@"(fromType='%@' and fromID='%@') or (toType='%@' and toID='%@')",
                      otherType, otherID, otherType, otherID];
    NSPredicate *p1 = [NSPredicate predicateWithFormat:pred];
    
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1]];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"seqID"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];

//    request.sortDescriptors = [NSArray array];
    
    NSArray *array = [app.managedObjectContext executeFetchRequest:request error:nil];
    return array;
  } @catch (NSException * e) {
    NSLog(@"[Message getMaxSeq] Exception: %@", e);
    return nil;
  }
  return nil;
}

+ (void) updateWithArray:(NSMutableArray *)ary {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  @try {
    for (NSDictionary *dic in ary) {
      Message *msg = [Message getBySeq:dic[@"_seq_id"]];
      if (msg == nil)
        msg = [NSEntityDescription insertNewObjectForEntityForName:@"Message"
                                      inManagedObjectContext:app.managedObjectContext];
      msg.seqID = [Common getNSCFString:dic[@"_seq_id"]];
      msg.fromType = [Common getNSCFString:dic[@"_from_type"]];
      msg.fromID = [Common getNSCFString:dic[@"_from_id"]];
      msg.toType = [Common getNSCFString:dic[@"_to_type"]];
      msg.toID = [Common getNSCFString:dic[@"_to_id"]];
      msg.msg = [Common getNSCFString:dic[@"_msg"]];
      msg.insertDT = [Common getNSCFString:dic[@"_insert_dt"]];
      msg.readDT = [Common getNSCFString:dic[@"_read_dt"]];
      msg.fromName = [Common getNSCFString:dic[@"_from_name"]];
      msg.toName = [Common getNSCFString:dic[@"_to_name"]];
    }
    
    [app.managedObjectContext save:nil];
    
  } @catch (NSException * e) {
    NSLog(@"[Message updateWithArray] Exception: %@", e);
    return;
  }
}

+ (NSArray*) getAll {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  @try {
    NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchAllMessage"
                substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:@"", [NSNull null], nil]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"seqID"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetch setSortDescriptors:sortDescriptors];
    
    NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
    return fetchResult;
  } @catch (NSException * e) {
    NSLog(@"[Message getAll] Exception: %@", e);
    return nil;
  }
  return nil;
}

@end
