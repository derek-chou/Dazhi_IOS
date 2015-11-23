//
//  Message.h
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
  FROM_ME = 0,
  FROM_OTHER = 1
} MessageType;

@interface Message : NSObject
- (void) setFromDict:(NSDictionary*) dict otherType:(NSString*)type otherID:(NSString*)ID;

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *datetime;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) MessageType type;
@property (nonatomic) UIImageView *iconImage;
@property (nonatomic, copy) NSString *otherType;
@property (nonatomic, copy) NSString *otherID;
@end
