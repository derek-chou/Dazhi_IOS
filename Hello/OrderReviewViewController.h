//
//  OrderReviewViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/12/24.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailViewController.h"
#import "HCSStarRatingView.h"

@interface OrderReviewViewController : UIViewController<UITextViewDelegate>
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
@property IBOutlet HCSStarRatingView *ratingView;
@property IBOutlet UILabel *ratingLabel;
@property IBOutlet UITextView *reviewText;

@property NSString *orderID;
@property RoleType role;
@property OrderStatus status;
@property int rateScore;

@end
