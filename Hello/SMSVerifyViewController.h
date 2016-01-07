//
//  SMSVerifyViewController.h
//  Hello
//
//  Created by Derek Chou on 2016/1/6.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSVerifyViewController : UIViewController

@property IBOutlet UILabel *cellPhoneLabel;
@property IBOutlet UITextField *smsVerifyCodeField;
@property NSString *cellPhoneNo;

@end
