//
//  OrderPayViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/24.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "OrderPayViewController.h"
#import "Order.h"
#import "Product.h"
#import "Common.h"
#import "AFNetworking.h"

@interface OrderPayViewController ()

@end

@implementation OrderPayViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _creditCard1.delegate = self;
  _creditCard2.delegate = self;
  _creditCard3.delegate = self;
  _creditCard4.delegate = self;
  _creditCardCheckCode.delegate = self;
  _creditCardValidDate.delegate = self;
  
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
  [self.view addGestureRecognizer:tapView];

  Order *order = [Order getByID:_orderID];
  if (order == nil) {
    return;
  }
  Product *prod = [Product getByID:order.productID];
  if (prod == nil) {
    return;
  }
  
  NSString *amount = [NSString stringWithFormat:@"%@ $%@", prod.currency, order.amount];
  self.amountLabel.text = amount;
}

- (void)tapView{
  [self.creditCard1 resignFirstResponder];
  [self.creditCard2 resignFirstResponder];
  [self.creditCard3 resignFirstResponder];
  [self.creditCard4 resignFirstResponder];
  [self.creditCardValidDate resignFirstResponder];
  [self.creditCardCheckCode resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) checkInputField {
  BOOL showMsg = NO;
  if ([_creditCard1.text length] != 4) {
    [_creditCard1 becomeFirstResponder];
    showMsg = YES;
  } else if ([_creditCard2.text length] != 4) {
    [_creditCard2 becomeFirstResponder];
    showMsg = YES;
  } else if ([_creditCard3.text length] != 4) {
    [_creditCard3 becomeFirstResponder];
    showMsg = YES;
  } else if ([_creditCard4.text length] != 4) {
    [_creditCard4 becomeFirstResponder];
    showMsg = YES;
  } else if ([_creditCardValidDate.text length] != 6) {
    [_creditCardValidDate becomeFirstResponder];
    showMsg = YES;
  } else if ([_creditCardCheckCode.text length] != 3) {
    [_creditCardCheckCode becomeFirstResponder];
    showMsg = YES;
  }
  
  if (showMsg) {
    [Common alertTitle:@"" Msg:@"請輸入正確的信用卡資訊" View:self Back:NO];
    return NO;
  }
  return YES;
}

- (IBAction)onConfirmClick:(id)sender {
  if (![self checkInputField])
    return;
  
  Order *order = [Order getByID:self.orderID];
  if (order == nil) {
    return;
  }
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "order/buyerConfirm"];
  NSDictionary *params = @{@"type":order.buyerType, @"id":order.buyerID,
                           @"orderID":order.orderID};
  [manager PUT:urlString parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"buyer confirm: %@", responseObject);
          
          [Common alertTitle:@"" Msg:@"付款成功" View:self Back:false];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          [Common alertTitle:@"" Msg:@"付款失敗，請稍候再試" View:self Back:false];
        }];
  
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  int MaxLen = 0;
  if (textField == _creditCard1 || textField == _creditCard2 || textField == _creditCard3 || textField == _creditCard4){
    MaxLen = 4;
  }
  
  if (textField == _creditCardCheckCode) {
    MaxLen = 3;
  }

  if (textField == _creditCardValidDate) {
    MaxLen = 6;
  }
  
  NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
  NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:textField.text];
  
  if (![numbersOnly isSupersetOfSet:characterSetFromTextField])
    return NO;
  
  if (textField.text.length >= MaxLen && range.length == 0) {

    return NO;
  } else
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
  NSInteger nextTag = textField.tag + 1;
  UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
  if (nextResponder) {
    [nextResponder becomeFirstResponder];
  } else {
    [textField resignFirstResponder];
  }
  return NO;
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


@end
