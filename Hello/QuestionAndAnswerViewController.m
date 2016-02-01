//
//  QuestionAndAnswerViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/28.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "QuestionAndAnswerViewController.h"
#import "Common.h"

@interface QuestionAndAnswerViewController ()

@end

@implementation QuestionAndAnswerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
//  NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//  [_webView loadHTMLString:htmlString baseURL:nil];
  NSString *serverURL = [Common getSetting:@"Server URL"];
  NSString *url;
  if ([self.fileName isEqualToString:@"setting"]) {
    //serverURL = @"http://127.0.0.1:8080/";
    url = [NSString stringWithFormat:@"%@setting/personalInfo", serverURL];
  } else
    url = [NSString stringWithFormat:@"%@setting/%@?lang=zh_TW", serverURL, self.fileName];
  
  NSURL* nsUrl = [NSURL URLWithString:url];
//  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:nsUrl
                          cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

  if ([self.fileName isEqualToString:@"setting"]) {
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"type=%@&id=%@",
                            [Common getSetting:@"User Type"], [Common getSetting:@"User ID"]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
