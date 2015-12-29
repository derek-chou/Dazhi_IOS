//
//  QuestionAndAnswerViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/28.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "QuestionAndAnswerViewController.h"

@interface QuestionAndAnswerViewController ()

@end

@implementation QuestionAndAnswerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
  NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
  [_webView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
