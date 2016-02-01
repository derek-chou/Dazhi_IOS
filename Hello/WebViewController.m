//
//  WebViewController.m
//  Hello
//
//  Created by Derek Chou on 2016/2/1.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import "WebViewController.h"
#import "Common.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *serverURL = [Common getSetting:@"Server URL"];
  NSString *url = self.webPage;
//  if ([self.webPage isEqualToString:@"setting"]) {
//    //serverURL = @"http://127.0.0.1:8080/";
//    url = [NSString stringWithFormat:@"%@setting/personalInfo", serverURL];
//  } else
//    url = [NSString stringWithFormat:@"%@setting/%@?lang=zh_TW", serverURL, self.webPage];
  
  NSURL* nsUrl = [NSURL URLWithString:url];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsUrl
                                                         cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
  
//  if ([self.webPage isEqualToString:@"setting"]) {
//    [request setHTTPMethod:@"POST"];
//    NSString *postString = [NSString stringWithFormat:@"type=%@&id=%@",
//                            [Common getSetting:@"User Type"], [Common getSetting:@"User ID"]];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//  }
  
  [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
