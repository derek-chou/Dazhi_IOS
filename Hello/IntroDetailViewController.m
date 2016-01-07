//
//  IntroDetailViewController.m
//  Hello
//
//  Created by Derek Chou on 2016/1/5.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import "IntroDetailViewController.h"

@interface IntroDetailViewController ()

@end

@implementation IntroDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.introPhoto.image = [UIImage imageNamed:self.introPhotoName];
  self.introLabel.text = self.introString;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
