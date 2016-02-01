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
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(didTapOnTableView:)];
  [self.view addGestureRecognizer:tap];
}

-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
  [self.cellPhoneField resignFirstResponder];
  [self.countryCodesField resignFirstResponder];
}

- (void) keyBoardWillShow:(NSNotification*) note {
  CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat ty = - rect.size.height;
  [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
    int deviceHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9 && deviceHeight <= 480) {
//      [self.view setCenter:CGPointMake(rect.size.width/2, floor((rect.size.height - ty)/2))];
//      CGSize appSize = [[UIScreen mainScreen] applicationFrame].size;
//      CGFloat scale = [UIScreen mainScreen].scale;
      CGAffineTransform affineMatrix = CGAffineTransformMakeTranslation(0, -ceil(ty/4));
      CGAffineTransform affineMatrix1 = CGAffineTransformMakeTranslation(0, ceil(ty/2));
      CGAffineTransform affineMatrix2 = CGAffineTransformTranslate(affineMatrix, 0, ceil(ty/4));
      affineMatrix = CGAffineTransformScale(affineMatrix, 0.5, 0.5);
      affineMatrix1 = CGAffineTransformScale(affineMatrix, 1, 1);
      affineMatrix2 = CGAffineTransformScale(affineMatrix2, 0.5, 0.5);
      //self.view.transform = affineMatrix;
//      self.view.transform = affineMatrix2;
    
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
