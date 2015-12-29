//
//  Common.m
//  Hello
//
//  Created by Derek Chou on 2015/11/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "Common.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "Parameter.h"
#import "User.h"

@implementation Common

+ (Common *)instance {
  static dispatch_once_t onceToken;
  static Common *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [Common new];
  });
  return instance;
}

- (id)init {
  self = [super init];
  return self;
}

+ (void)downloadImage:(NSString*)UrlString To:(__weak UIImageView*)view Cell:(UITableViewCell*) cell SavePath:(NSString*)path {
  if (UrlString == nil)
    return;
  
  if ([UrlString length]) {
    //UIImage *placeholderImage = [UIImage imageNamed:@"top5_a1.png"];
    UIImage *placeholderImage = [UIImage imageNamed:@"loding.gif"];
    NSURL *url = [NSURL URLWithString:UrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFImageResponseSerializer *serializer = [[AFImageResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes
                                         setByAddingObject:@"image/jpg"];
    view.imageResponseSerializer = serializer;
    
    
    [view setImageWithURLRequest:request placeholderImage:placeholderImage
              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {                
                view.image = image;
                [view setHidden:NO];
                
                [cell setNeedsLayout];
                
                //NSString *imgFileName = [[UrlString componentsSeparatedByString:@"/"] lastObject];
                //NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
                NSData *imgData = UIImagePNGRepresentation(image);
                if([imgData writeToFile:path atomically:YES])
                  NSLog(@"downloadImage to UIImageView 圖片存檔成功");
                else
                  NSLog(@"downloadImage to UIImageView 圖片存檔失敗");
              }
              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"Error: %@", error);
              }
     ];
  } else {
    view.image = [UIImage imageNamed:@"loading.gif"];
  }

}

+ (void)downloadImage:(NSString*)UrlString ToBtn:(__weak UIButton*)btn Cell:(UITableViewCell*) cell SavePath:(NSString*)path {
  if (UrlString == nil)
    return;
  
  if ([UrlString length]) {
    UIImage *placeholderImage = [UIImage imageNamed:@"loading.gif"];
    NSURL *url = [NSURL URLWithString:UrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFImageResponseSerializer *serializer = [[AFImageResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes
                                         setByAddingObject:@"image/jpg"];
    btn.imageView.imageResponseSerializer = serializer;
    
    
    [btn.imageView setImageWithURLRequest:request placeholderImage:placeholderImage
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
               [btn setImage:image forState:UIControlStateNormal];
               [cell setNeedsLayout];
               
               NSData *imgData = UIImagePNGRepresentation(image);
               if([imgData writeToFile:path atomically:YES])
                 NSLog(@"downloadImage to UIButton 圖片存檔成功");
               else
                 NSLog(@"downloadImage to UIButton 圖片存檔失敗");
             }
             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
               NSLog(@"Error: %@", error);
             }
     ];
  } else {
    [btn setImage:[UIImage imageNamed:@"loading.gif"] forState:UIControlStateNormal];
  }
}

+ (NSString*)getSetting:(NSString*)key{
  NSString *path = [NSString stringWithFormat:@"%@/Documents/Setting.plist", NSHomeDirectory()];
  
  NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//  [self setSettingForKey:@"fff" Value:@"123"];
  return [plist objectForKey:key];
}

+ (void)setSettingForKey:(NSString*)key Value:(NSString*)value {
  NSString* plistPath = nil;
  NSFileManager* manager = [NSFileManager defaultManager];
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *documentsDirectory = [paths objectAtIndex:0];
//  NSLog(@"path:%@",documentsDirectory);
//  NSLog(@"path2:%@", NSHomeDirectory());
//  if ((plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:
//                   [NSString stringWithFormat:@"%@/Documents/Setting.plist", NSHomeDirectory()]]))
  plistPath = [NSString stringWithFormat:@"%@/Documents/Setting.plist", NSHomeDirectory()];
  {
    if ([manager isWritableFileAtPath:plistPath])
    {
      NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
      [infoDict setObject:value forKey:key];
      [infoDict writeToFile:plistPath atomically:NO];
      [manager setAttributes:[NSDictionary dictionaryWithObject:[NSDate date]
              forKey:NSFileModificationDate] ofItemAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
    }
  }
}

+ (NSString*)getParameterByType:(NSString*)type AndKey:(NSString*)key {
  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  NSDictionary *dicCondition = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:type, key, nil] forKeys:[NSArray arrayWithObjects:@"TYPE", @"KEY", nil]];
  NSFetchRequest *fetch = [app.managedObjectModel fetchRequestFromTemplateWithName:@"FetchParameter"
                                                             substitutionVariables:dicCondition];
  
  NSArray *fetchResult = [app.managedObjectContext executeFetchRequest:fetch error:nil];
  if ([fetchResult count] > 0){
    Parameter *param = fetchResult[0];
    return param.value;
  }
  return @"";
}

+ (NSString*)getPhotoURLByType:(NSString*)type AndID:(NSString*)id {
  NSString *imgURL = @"";
  if ([type isEqualToString:@"FB"])
    imgURL = [NSString stringWithFormat:@"%@%@%@", @"http://graph.facebook.com/", id, @"/picture?type=large"];
  else {
    //for 微信
    imgURL = [NSString stringWithFormat:@"%@%@%@", @"http://graph.ws.com/", id, @"/picture?type=large"];
  }
  return imgURL;
}

+ (UIColor*) getUserLevelColor:(int) level {
  UIColor *color;
  switch (level) {
    case 1:
      color = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1];
      break;
    case 2:
      color = [UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:51.0/255.0 alpha:1];
      break;
    case 3:
      color = [UIColor colorWithRed:201.0/255.0 green:1.0/255.0 blue:255.0/255.0 alpha:1];
      break;
      
    default:
      color = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1];
      break;
  }
  return color;
}

+ (NSString*) getNSCFString:(NSObject*)obj {
  return ([obj isKindOfClass:[NSNull class]]) ? @"" : (NSString*)obj;
}

+ (NSNumber*) getNSCFNumber:(NSObject*)obj {
  return ([obj isKindOfClass:[NSNull class]]) ? 0 : (NSNumber*)obj;
}

+(void)alertTitle:(NSString*)title Msg:(NSString*)msg View:(UIViewController*)view Back:(BOOL)isBack {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action){
                                                  [view dismissViewControllerAnimated:YES completion:nil];
                                                  if (isBack) {
                                                    [view.navigationController popViewControllerAnimated:YES];
                                                  }
                                                }];
  [alert addAction:okAct];
  [view presentViewController:alert animated:YES completion:nil];
  
}

+ (void) loadUserToLabel:(UILabel*)lbl ByType:(NSString*)userType AndID:(NSString*)userID {
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "user"];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:@{@"type":userType, @"id":userID}
       success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if ([responseObj count] > 0) {
           [User addWithDic:responseObj[0]];
           
           lbl.text = [Common getNSCFString:responseObj[0][@"_name"]];
         }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"loadUserByType Error: %@", error);
       }
   ];
}

+ (void) loadUserByType:(NSString*)userType AndID:(NSString*)userID {
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "user"];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:@{@"type":userType, @"id":userID}
       success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if ([responseObj count] > 0) {
           [User addWithDic:responseObj[0]];
         }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"loadUserByType Error: %@", error);
       }
   ];
}

+ (NSString*) convertLangCodeToString:(NSString*)langCode {
  NSArray *ary = [langCode componentsSeparatedByString:@","];
  NSString *langResult = @"";
  NSMutableArray *langStrAry = [NSMutableArray new];
  for (NSString *str in ary) {
    NSString *langStr = [Common getParameterByType:@"lang" AndKey:str];
    if ([langStr isEqualToString:@""])
      continue;
    
    [langStrAry addObject:langStr];
  }
  langResult = [langStrAry componentsJoinedByString:@","];
  
  return langResult;
}

+ (NSString*) convertJobCodeToString:(NSString*)jobCode {
  NSString *job = jobCode;
  job = [[job componentsSeparatedByString:@","] firstObject];
  job = [Common getParameterByType:@"job" AndKey:job];
  return job;
}

+ (void) loadUserBySelf {
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  
  [Common loadUserByType:userType AndID:userID];
}

@end
