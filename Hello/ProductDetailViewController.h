//
//  ProductDetailViewController.h
//  Hello
//
//  Created by Derek Chou on 2015/12/16.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductDetailViewController : UIViewController

@property NSString *productID;

@property IBOutlet UIImageView *productImage;
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *contentLabel;
@property IBOutlet UILabel *maxNumberLabel;
@property IBOutlet UILabel *periodLabel;
@property IBOutlet UILabel *cityLabel;
@property IBOutlet UILabel *priceLabel;
@property IBOutlet UITextField *numberOfPeopleText;
@property IBOutlet UISlider *numberOfPeopleSlider;
@property IBOutlet UIDatePicker *datePicker;
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UITextField *travelDateText;
@property IBOutlet UILabel *totalPriceLabel;
@property IBOutlet UITextField *memoText;

@property NSMutableArray *bannerImagesArray;
@property NSTimer *bannerTimer;
@property int currentImageIndex;
@property Product *product;

- (void)displayNextImage;
-(void)tapDetected;

@end
