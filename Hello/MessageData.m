//
//  Message.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MessageData.h"

@implementation MessageData

- (void) setFromDict:(NSDictionary*) dict otherType:(NSString*)type otherID:(NSString*)ID{
  //self.icon = dict[@"icon"];
  NSString *datetime = dict[@"_insert_dt"];
  self.datetime = datetime;
  NSArray *ary = [datetime componentsSeparatedByString:@" "];
  self.date = [ary firstObject];
  self.time = [ary lastObject];
  self.time = [self.time substringToIndex:5];
  self.content = dict[@"_msg"];
  
  self.otherType = type;
  self.otherID = ID;
  if ([type isEqual:dict[@"_from_type"]] && [ID isEqual:dict[@"_from_id"]]) {
    self.type = FROM_OTHER;
  } else
    self.type = FROM_ME;
}
@end
