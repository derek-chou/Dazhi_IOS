//
//  OrderPayViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/12/24.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPayViewController : UIViewController<UITextFieldDelegate>
@property IBOutlet UITextField *creditCard1;
@property IBOutlet UITextField *creditCard2;
@property IBOutlet UITextField *creditCard3;
@property IBOutlet UITextField *creditCard4;
@property IBOutlet UITextField *creditCardValidDate;
@property IBOutlet UITextField *creditCardCheckCode;
@property IBOutlet UIButton *confirmButton;
@property IBOutlet UILabel *amountLabel;

@property NSString *orderID;

@end
