//
//  SMSVerifyViewController.m
//  Hello
//
//  Created by Derek Chou on 2016/1/6.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import "SMSVerifyViewController.h"
#import "AFNetworking.h"
#import "Common.h"

@interface SMSVerifyViewController ()

@end

@implementation SMSVerifyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  self.cellPhoneLabel.text = self.cellPhoneNo;
  
  int rand =  arc4random() % 1000000;
  self.smsVerifyCodeField.text = [NSString stringWithFormat:@"%06d", rand];
  
}

- (IBAction)onConfirmClick:(id)sender {
  NSString *type = [Common getSetting:@"User Type"];
  NSString *_id = [Common getSetting:@"User ID"];
  NSString *name = [Common getSetting:@"User Name"];
  NSString *link = [Common getSetting:@"User Link"];
  NSString *gender = [Common getSetting:@"User Gender"];
  NSString *email = [Common getSetting:@"User Email"];
  NSString *birthday = [Common getSetting:@"User Birthday"];
  NSString *locale = [Common getSetting:@"User Locale"];
  
  NSArray *tmpAry = [self.cellPhoneNo componentsSeparatedByString:@"("];
  NSString *phone = [NSString stringWithFormat:@"(%@", [tmpAry lastObject]];

  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "user"];
  NSDictionary *params = @{@"type":type, @"id":_id,
                           @"name":name, @"link":link,
                           @"gender":gender, @"email":email,
                           @"birthday":birthday, @"locale":locale,
                           @"phone":phone};
  [manager POST:urlString parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"add user: %@", responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"add user error: %@", error);
          [Common alertTitle:@"error" Msg:@"加入系統失敗" View:self Back:false];
        }];
  
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  UIViewController *view = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainView"];
  view.hidesBottomBarWhenPushed = NO;
  [self presentViewController:view animated:NO completion:nil];
}

- (void) keyBoardWillShow:(NSNotification*) note {
  int deviceHeight =  [[UIScreen mainScreen] bounds].size.height;
  
  CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat ty = - rect.size.height;
  [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
    if ([UIDevice currentDevice].systemVersion.floatValue < 9 && deviceHeight <= 480) {
    } else {
      self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }
  }];
}

- (void) keyBoardWillHide:(NSNotification*) note {
  [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
    self.view.transform = CGAffineTransformIdentity;
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
