//
//  OrderReviewViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/24.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "OrderReviewViewController.h"
#import "Order.h"
#import "Product.h"
#import "User.h"
#import "Common.h"
#import "OrderDetailViewController.h"
#import "HCSStarRatingView.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"

@interface OrderReviewViewController ()

@end

@implementation OrderReviewViewController

static NSString *textPlacehold = @"寫下您要給對方的評價...";

- (void)viewDidLoad {
    [super viewDidLoad];
  Order *order = [Order getByID:_orderID];
  if (order == nil) {
    [Common alertTitle:@"error" Msg:@"訂單異常!!" View:self Back:true];
    return;
  }
  
  Product *prod = [Product getByID:order.productID];
  if (prod == nil) {
    [Common alertTitle:@"error" Msg:@"訂單異常!!" View:self Back:true];
    return;
  }
  
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  
  if (([order.buyerType isEqualToString:userType]) && ([order.buyerID isEqualToString:userID]))
    _role = ROLE_BUYER;
  else if (([order.sellerType isEqualToString:userType]) && ([order.sellerID isEqualToString:userID]))
    _role = ROLE_SELLER;
  else
    _role = ROLE_NONE;
  
  if ([order.buyerConfirmDT isEqualToString:@""] && [order.sellerConfirmDT isEqualToString:@""])
    _status = ORDER_NEW;
  else if (![order.buyerConfirmDT isEqualToString:@""] && ![order.sellerConfirmDT isEqualToString:@""])
    _status = ORDER_COMPLETE;
  else if (![order.sellerConfirmDT isEqualToString:@""])
    _status = ORDER_WAIT_BUYER_CONFIRM;
  else if (![order.buyerConfirmDT isEqualToString:@""])
    _status = ORDER_WAIT_SELLER_CONFIRM;
  else
    _status = ORDER_NONE;
  
  NSString *statusString;
  switch (_status) {
    case ORDER_NEW:
      statusString = @"等待賣方確認中";
      break;
    case ORDER_WAIT_SELLER_CONFIRM:
      statusString = @"等待賣方確認中";
      break;
    case ORDER_WAIT_BUYER_CONFIRM:
      statusString = @"等待買方確認中";
      break;
    case ORDER_COMPLETE:
      statusString = @"已完成";
      break;
      
    default:
      statusString = @"狀態異常";
      break;
  }
  
  User *buyer = [User getByType:order.buyerType AndID:order.buyerID];
  User *seller = [User getByType:order.sellerType AndID:order.sellerID];
  _productTitleLabel.text = prod.title;
  _productContentLabel.text = prod.content;
  _numbersOfPeopleLabel.text = [order.numberOfPeople stringValue];
  _travelDateLabel.text = order.travelDay;
  NSString *city = [Common getParameterByType:@"city" AndKey:prod.cityCode];
  city = [city stringByReplacingOccurrencesOfString:@"$" withString:@" "];
  _cityLabel.text = city;
  _productPriceLabel.text = prod.price;
  _amountLabel.text = [order.amount stringValue];
  _memoLabel.text = order.memo;
  if (buyer != nil)
    _buyerNameLabel.text = buyer.name;
  else
    [Common loadUserToLabel:_buyerNameLabel ByType:order.buyerType AndID:order.buyerID];
  
  if (seller != nil)
    _sellerNameLabel.text = seller.name;
  else
    [Common loadUserToLabel:_sellerNameLabel ByType:order.sellerType AndID:order.sellerID];
  _statusLabel.text = statusString;
  
  if (_status == ORDER_COMPLETE) {
    _sellerImage.image = [UIImage imageNamed:@"OrderConfirmCheck"];
    _buyerImage.image = [UIImage imageNamed:@"OrderConfirmCheck"];
    [self.confirmButton setTitle: @"取消" forState: UIControlStateNormal];
  } else if (_status == ORDER_WAIT_BUYER_CONFIRM)
    _sellerImage.image = [UIImage imageNamed:@"OrderConfirmCheck"];
  else if (_status == ORDER_WAIT_SELLER_CONFIRM)
    _buyerImage.image = [UIImage imageNamed:@"OrderConfirmCheck"];
  
  _reviewText.layer.borderColor = [UIColor grayColor].CGColor;
  _reviewText.layer.borderWidth = 1.0;
  _reviewText.layer.cornerRadius = 5.0;
  _reviewText.delegate = (id)self;
  _reviewText.text = textPlacehold;
  _reviewText.textColor = [UIColor lightGrayColor];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
  [self.view addGestureRecognizer:tapView];
  
  self.view.layer.zPosition = 1;
  [self.scrollView bringSubviewToFront:_confirmButton];
}

- (IBAction)onConfirmClick:(id)sender {
  /*
  "type":"FB",       (評價人）
  "id":"10153433568951071",
  "from_type":"FB",    （被評價人）
  "from_id":"RealMattRoloff",
  "score":10,
  "comment":"好倒油，讚!!!!",
  "order_id":1
  */
  
  if (_role == ROLE_NONE) {
    [Common alertTitle:@"系統錯誤" Msg:@"無法判定使用者角色" View:self Back:false];
    return;
  }
  Order *order = [Order getByID:_orderID];
  NSDictionary *params;
  if (_role == ROLE_BUYER) {
    params = @{@"type":order.buyerType, @"id":order.buyerID,
               @"from_type":order.sellerType, @"from_id":order.sellerID,
               @"score":[NSString stringWithFormat:@"%d", _rateScore], @"comment":_reviewText.text,
               @"orderID":order.orderID};
  } else {
    params = @{@"type":order.sellerType, @"id":order.sellerID,
               @"from_type":order.buyerType, @"from_id":order.buyerID,
               @"score":[NSString stringWithFormat:@"%d",_rateScore], @"comment":_reviewText.text,
               @"orderID":order.orderID};
  }
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "comment"];
  [manager POST:urlString parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"comment: %@", responseObject);
         
         [Common alertTitle:@"" Msg:@"評價送出成功" View:self Back:false];
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"comment Error: %@", error);
         [Common alertTitle:@"" Msg:@"評價送出失敗，請稍候再試" View:self Back:false];
       }];
  [self.reviewText resignFirstResponder];
}

- (void)tapView{
  [self.reviewText resignFirstResponder];
}

- (IBAction)ratingChange:(id)sender {
  float fRate = ((HCSStarRatingView*)sender).value;
  _rateScore = (int)(fRate * 2.0);
  
  _ratingLabel.text = [NSString stringWithFormat:@"(%d)", _rateScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:textPlacehold]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor]; //optional
  }
  [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""]) {
    textView.text = textPlacehold;
    textView.textColor = [UIColor lightGrayColor]; //optional
  }
  [textView resignFirstResponder];
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


@end
