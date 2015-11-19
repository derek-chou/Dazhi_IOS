//
//  Message.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void) setDict:(NSDictionary*) dict {
  _dict = dict;
  self.icon = dict[@"icon"];
  self.time = dict[@"time"];
  self.content = dict[@"content"];
  self.type = [dict[@"type"] intValue];
}
@end
