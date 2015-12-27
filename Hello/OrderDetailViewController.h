//
//  OrderDetailViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/12/18.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  ROLE_NONE = 0,
  ROLE_BUYER = 1,
  ROLE_SELLER = 2
} RoleType;

typedef enum {
  ORDER_NONE = 0,
  ORDER_NEW = 1,
  ORDER_WAIT_BUYER_CONFIRM = 2,
  ORDER_WAIT_SELLER_CONFIRM = 3,
  ORDER_COMPLETE = 4
} OrderStatus;

@interface OrderDetailViewController : UIViewController
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UILabel *productTitleLabel;
@property IBOutlet UILabel *productContentLabel;
@property IBOutlet UILabel *numbersOfPeopleLabel;
@property IBOutlet UILabel *travelDateLabel;
@property IBOutlet UILabel *cityLabel;
@property IBOutlet UILabel *productPriceLabel;
@property IBOutlet UILabel *amountLabel;
@property IBOutlet UILabel *memoLabel;
@property IBOutlet UILabel *buyerNameLabel;
@property IBOutlet UILabel *sellerNameLabel;
@property IBOutlet UILabel *statusLabel;
@property IBOutlet UIImageView *buyerImage;
@property IBOutlet UIImageView *sellerImage;
@property IBOutlet UIButton *confirmButton;

@property NSString *orderID;
@property RoleType role;
@property OrderStatus status;
@end
