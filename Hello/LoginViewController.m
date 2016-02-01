//
//  LoginViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/30.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "AFNetworking.h"
#import "Common.h"
#import "CellPhoneViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  FBSDKLoginButton *loginBtn = [FBSDKLoginButton new];
  loginBtn.delegate = self;
  CGRect viewFrame = self.view.frame;
  float height = viewFrame.size.height;
  float width = viewFrame.size.width;
  CGRect rect = CGRectMake(width / 6, height * 2/3, width * 2/3, width * 2/3 * 1/5);
  loginBtn.frame = rect;
  //loginBtn.center = self.view.center;
  loginBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];
  [self.view addSubview:loginBtn];
  NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
  NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
  NSLog(@"token: %@", [FBSDKAccessToken currentAccessToken]);
//  [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if ([FBSDKAccessToken currentAccessToken]) {
    [self jumpToMainPage];
  }
}

- (void)jumpToMainPage {
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  CellPhoneViewController *view = (CellPhoneViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CellPhoneInputView"];
  view.hidesBottomBarWhenPushed = NO;
  [self presentViewController:view animated:NO completion:nil];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:	(NSError *)error {
  if (error) {
    // Process error
    NSLog(@"Process error");
    [Common alertTitle:@"error" Msg:@"FB登入失敗" View:self Back:false];
  } else if (result.isCancelled) {
    // Handle cancellations
    NSLog(@"Handle cancellations: %@, %@, %@", result, result.grantedPermissions, [FBSDKAccessToken currentAccessToken]);
  } else {
    FBSDKGraphRequest *fbRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                    parameters:@{@"fields": @"id, name, link, gender, email, birthday, locale"}];
    [fbRequest startWithCompletionHandler:
     ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         //NSLog(@"user info : %@", result);
         NSString *type = @"FB";
         NSString *_id = [result objectForKey:@"id"];
         NSString *name = [result objectForKey:@"name"];
         NSString *link = [result objectForKey:@"link"];
         NSString *gender = [result objectForKey:@"gender"];
         NSString *email = [result objectForKey:@"email"];
         NSString *birthday = ([result objectForKey:@"birthday"] == nil) ? @"" : [result objectForKey:@"birthday"];
         NSString *locale = [result objectForKey:@"locale"];
//         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//         manager.requestSerializer = [AFJSONRequestSerializer serializer];
//       
//         NSString *url = [Common getSetting:@"Server URL"];
//         NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "user"];
//         NSDictionary *params = @{@"type":type, @"id":_id,
//                                  @"name":name, @"link":link,
//                                  @"gender":gender, @"email":email,
//                                  @"birthday":birthday, @"locale":locale};
//         [manager POST:urlString parameters:params
//               success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                 NSLog(@"add user: %@", responseObject);
//               }
//               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                 NSLog(@"add user error: %@", error);
//                 [Common alertTitle:@"error" Msg:@"加入系統失敗" View:self Back:false];
//               }];
         [Common setSettingForKey:@"User Type" Value:type];
         [Common setSettingForKey:@"User ID" Value:_id];
         [Common setSettingForKey:@"User Name" Value:name];
         [Common setSettingForKey:@"User Link" Value:link];
         [Common setSettingForKey:@"User Gender" Value:gender];
         [Common setSettingForKey:@"User Email" Value:email];
         [Common setSettingForKey:@"User Birthday" Value:birthday];
         [Common setSettingForKey:@"User Locale" Value:locale];
       
       [self jumpToMainPage];
     }];
  }
  
  NSLog(@"fb login complete!!");
  NSLog(@"token: %@", [FBSDKAccessToken currentAccessToken]);
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  NSLog(@"fb logout!!");
}

- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
  NSLog(@"fb will login");
  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
