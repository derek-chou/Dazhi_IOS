//
//  CellPhoneViewController.m
//  Hello
//
//  Created by Derek Chou on 2016/1/6.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import "CellPhoneViewController.h"
#import "Common.h"
#import "SMSVerifyViewController.h"

@interface CellPhoneViewController ()

@end

@implementation CellPhoneViewController

int CellPhoneMaxLen = 10;
int CellPhoneMinLen = 6;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSArray *codesAry = @[@"台灣(+886)", @"中國(+86)", @"美國(+1)"];
  self.codesPicker = [[DownPicker alloc] initWithTextField:self.countryCodesField  withData:codesAry];
  [self.codesPicker addTarget:self
                       action:@selector(countryCodesSelected:)
             forControlEvents:UIControlEventValueChanged];
  self.countryCodesField.text = [codesAry firstObject];
  self.cellPhoneField.delegate = self;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyBoardWillShow:(NSNotification*) note {
  CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat ty = - rect.size.height;
  [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
    self.view.transform = CGAffineTransformMakeTranslation(0, ty);
  }];
}

- (void) keyBoardWillHide:(NSNotification*) note {
  [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
    self.view.transform = CGAffineTransformIdentity;
  }];
}

-(void)countryCodesSelected:(id)dp {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (BOOL) cellPhoneVerify {
  if ([_cellPhoneField.text length] > CellPhoneMaxLen || [_cellPhoneField.text length] < CellPhoneMinLen) {
    [_cellPhoneField becomeFirstResponder];
    [Common alertTitle:@"" Msg:@"請輸入正確的行動電話號碼" View:self Back:NO];
    return NO;
  }
  
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  SMSVerifyViewController *view = (SMSVerifyViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"SMSVerifyView"];
  view.cellPhoneNo = [self.countryCodesField.text stringByAppendingString: self.cellPhoneField.text];
  view.hidesBottomBarWhenPushed = NO;
  [self presentViewController:view animated:NO completion:nil];
  
  return YES;
}


- (IBAction)onNextStepClick:(id)sender {
  if (![self cellPhoneVerify]) {
    return;
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
  NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:textField.text];
  
  if (![numbersOnly isSupersetOfSet:characterSetFromTextField])
    return NO;
  
  if (textField.text.length >= CellPhoneMaxLen && range.length == 0) {
    return NO;
  } else
    return YES;
}


@end
