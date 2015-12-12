//
//  Message.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MessageData.h"
#import "Message.h"

@implementation MessageData

- (void) setFromMsgObj:(Message*) msgObj otherType:(NSString*)type otherID:(NSString*)ID{
  //self.icon = dict[@"icon"];
  NSString *insertDT = msgObj.insertDT;
  NSString *readDT = msgObj.readDT;
  self.datetime = insertDT;
  NSArray *ary = [insertDT componentsSeparatedByString:@" "];
  self.date = [ary firstObject];
  
  self.content = msgObj.msg;
  
  self.otherType = type;
  self.otherID = ID;
  if ([type isEqual:msgObj.fromType] && [ID isEqual:msgObj.fromID]) {
    self.type = FROM_OTHER;
  } else
    self.type = FROM_ME;
  
  if (![readDT isEqualToString:@""] && self.type == FROM_ME) {
    NSArray *readDTary = [readDT componentsSeparatedByString:@" "];
    self.time = [readDTary lastObject];
    self.time = [self.time substringToIndex:5];
    self.time = [NSString stringWithFormat:@"%@\n%@", self.time, @"已讀"];
  } else {
    self.time = [ary lastObject];
    self.time = [self.time substringToIndex:5];
  }
  

}
@end
