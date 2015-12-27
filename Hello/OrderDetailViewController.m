//
//  OrderDetailViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/18.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Order.h"
#import "Product.h"
#import "Common.h"
#import "User.h"
#import "AFNetworking.h"
#import "OrderPayViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

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
}

- (void) buyerConfirm {
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
         NSLog(@"seller confirm: %@", responseObject);
         
         [Common alertTitle:@"" Msg:@"確認成功" View:self Back:false];
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"seller confirm err: %@", error);
         [Common alertTitle:@"" Msg:@"確認失敗，請稍候再試" View:self Back:false];
       }];
}

- (void) orderCancel {
  Order *order = [Order getByID:self.orderID];
  if (order == nil) {
    return;
  }
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "order/cancel"];
  NSDictionary *params = @{@"type":order.buyerType, @"id":order.buyerID,
                           @"orderID":order.orderID};
  [manager PUT:urlString parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"order cancel: %@", responseObject);
         if ([responseObject count] > 0) {
           NSString *result = [Common getNSCFString:responseObject[@"result"]];
           if ([result isEqualToString:@"fail"]) {
             [Common alertTitle:@"訂單取消失敗" Msg:[Common getNSCFString:responseObject[@"return_desc"]] View:self Back:false];
           } else
             [Common alertTitle:@"訂單取消成功" Msg:@"" View:self Back:false];
         }
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"order cancel err: %@", error);
         [Common alertTitle:@"" Msg:@"訂單取消失敗，請稍候再試" View:self Back:false];
       }];
}

- (IBAction)onConfirmClick:(id)sender {
  if (_role == ROLE_BUYER) {
    if (_status == ORDER_NEW) {
      [Common alertTitle:@"訂單確認" Msg:@"訂單等待對方確認中" View:self Back:false];
    } else if (_status == ORDER_WAIT_BUYER_CONFIRM) {
      UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
      OrderPayViewController *payView = (OrderPayViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"OrderPayView"];
      payView.hidesBottomBarWhenPushed = YES;
      payView.orderID = self.orderID;
      [self.navigationController pushViewController:payView animated:NO];
    }
  //賣方部份尚未驗證功能是否正確
  } else if (_role == ROLE_SELLER) {
    if (_status == ORDER_NEW) {
      [self buyerConfirm];
    } else if (_status == ORDER_WAIT_BUYER_CONFIRM) {
      [Common alertTitle:@"訂單確認" Msg:@"訂單等待對方確認中" View:self Back:false];
    }    
  }
  
  if (_status == ORDER_COMPLETE) {
    [self orderCancel];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
}

@end
