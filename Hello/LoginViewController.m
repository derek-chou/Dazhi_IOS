//
//  LoginViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/30.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"

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
    //jump to main page
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    MainTabBarController *mainView = (MainTabBarController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MainView"];
    mainView.hidesBottomBarWhenPushed = NO;
    //[self.navigationController pushViewController:mainView animated:NO];
    [self presentViewController:mainView animated:NO completion:nil];
    
    //[self.navigationController pushViewController:mainView animated:NO];
    //[self.navigationController presentViewController:mainView animated:NO completion:^(void){}];
    //[self addChildViewController:mainView];
  }

}

//- (void) onProfileUpdated:(NSNotification*)notification {
//  NSLog(@"profile : %@", [FBSDKProfile currentProfile]);
//  NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
//  NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
//}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:	(NSError *)error {
  if (error) {
    // Process error
    NSLog(@"Process error");
  } else if (result.isCancelled) {
    // Handle cancellations
    NSLog(@"Handle cancellations: %@, %@, %@", result, result.grantedPermissions, [FBSDKAccessToken currentAccessToken]);
  } else {
    FBSDKGraphRequest *fbRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                    parameters:@{@"fields": @"id, name, link, gender, email, birthday, locale"}];
    [fbRequest startWithCompletionHandler:
     ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
       if (!error) {
         //NSLog(@"user info : %@", result);
         NSLog(@"id : %@", [result objectForKey:@"id"]);
       } else {
         NSLog(@"error: %@", error);
       }
     }];
    
    if ([result.grantedPermissions containsObject:@"public_profile"]) {
      NSLog(@"with public_profile");
    } else {
      NSLog(@"without public_profile");
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
