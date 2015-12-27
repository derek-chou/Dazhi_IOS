//
//  ProductDetailViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/16.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Product.h"
#import "Common.h"
#import "AFNetworking.h"
#import "MsgDetailViewController.h"
#import "User.h"
#import "MainTabBarController.h"
#import "OrderTableViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _bannerImagesArray = [NSMutableArray new];
  _product = [Product getByID:_productID];
  if (_product == nil) {
    NSString *url = [Common getSetting:@"Server URL"];
    NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "product/byProductID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:@{@"productID":_productID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if ([responseObject count]>0)
             [Product addWithDic:responseObject[0]];
           [self showData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
           [self showData];
         }
     ];
  } else
    [self showData];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  self.productImage.userInteractionEnabled = YES;
  UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapDetected)];
  doubleTap.numberOfTapsRequired = 2;
  [self.productImage setUserInteractionEnabled:YES];
  [self.productImage addGestureRecognizer:doubleTap];

  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
  [self.productImage addGestureRecognizer:tapGesture];
  
  [tapGesture requireGestureRecognizerToFail:doubleTap];
  self.numberOfPeopleText.delegate = (id)self;
  self.scrollView.contentSize = CGSizeMake(0, self.scrollView.contentSize.height);
  [self.scrollView setContentOffset: CGPointMake(0, self.scrollView.contentOffset.y)];
  self.scrollView.delegate = (id)self;
  
//  CGSize scrollableSize = CGSizeMake(320, myScrollableHeight);
//  [myScrollView setContentSize:scrollableSize];
  
  _datePicker = [[UIDatePicker alloc]init];
  [_datePicker setDate:[NSDate date]];
  _datePicker.datePickerMode = UIDatePickerModeDate;
  [_datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
  [self.travelDateText setInputView:_datePicker];
  
  UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)];
  [self.scrollView addGestureRecognizer:tapScrollView];
  [self updateTextField:nil];

}
- (IBAction)orderClick:(id)sender {
  if ([self.travelDateText.text length] < 10) {
    [Common alertTitle:@"" Msg:@"請選擇旅遊日期" View:self Back:false];
  }
  
  int numPeople = (int)self.numberOfPeopleSlider.value;
  float price = [_product.price floatValue];
  NSNumber *amount = [NSNumber numberWithFloat:(numPeople * price)];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "order"];
  NSDictionary *params = @{@"type":userType, @"id":userID,
                           @"productID":_product.productID, @"travelDay":self.travelDateText.text,
                           @"numberOfPeople":self.numberOfPeopleText.text,
                           @"memo":self.memoText.text,
                           @"amount":amount};
  [manager POST:urlString parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"orderClick: %@", responseObject);
          UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
          OrderTableViewController *orderView =(OrderTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"OrderCurrentView"];
          [orderView loadOrderData:@"0"];
          MainTabBarController *tabBar = (MainTabBarController*)self.parentViewController.tabBarController;
          [tabBar setOrderBadge:[NSString stringWithFormat:@"%d", [orderView getBadge]]];

          [Common alertTitle:@"" Msg:@"行程訂購成功" View:self Back:false];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          [Common alertTitle:@"" Msg:@"行程訂購失敗，請稍候再試" View:self Back:false];
        }];
  
}

-(void)tapScrollView{
  NSLog(@"single Tap on scrollView");
  
  [self.travelDateText resignFirstResponder];
  [self.memoText resignFirstResponder];
}

-(void)updateTextField:(id)sender
{
  UIDatePicker *picker = (UIDatePicker*)self.travelDateText.inputView;
  
  NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
  [timeFormatter setDateFormat:@"yyyy/MM/dd"];
  self.travelDateText.text = [timeFormatter stringFromDate:picker.date];
}

//不能左右scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//  if (scrollView.contentOffset.y != 0) {
//    CGPoint offset = scrollView.contentOffset;
//    offset.y = 0;
//    scrollView.contentOffset = offset;
//  }
  
  if (scrollView.contentOffset.x != 0) {
    CGPoint offset = scrollView.contentOffset;
    offset.x = 0;
    scrollView.contentOffset = offset;
  }
  //[scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
}

- (IBAction)dateChange:(id)sender {
  NSLog(@"%@", self.datePicker.date);
}

-(void)animationEffect {
  CABasicAnimation* rotationAnimation;
  rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 * 2 * 1 ];
  rotationAnimation.duration = 1;
  rotationAnimation.cumulative = YES;
  rotationAnimation.repeatCount = 1.0;
  rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  rotationAnimation.delegate = self;
  
  CABasicAnimation* translationAnimation;
  translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
  translationAnimation.toValue = [NSNumber numberWithFloat:-700];
  translationAnimation.duration = 1;
  translationAnimation.cumulative = YES;
  translationAnimation.repeatCount = 1.0;
  translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  translationAnimation.removedOnCompletion = NO;
  translationAnimation.fillMode = kCAFillModeForwards;
  
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.animations = [NSArray arrayWithObjects:rotationAnimation,translationAnimation, nil];
  group.delegate = self;
  group.removedOnCompletion = NO;
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  [self.productImage.layer addAnimation:group forKey:@"randt"];
}

- (void)setBannerImagesArray {

  self.currentImageIndex = 0;
  self.productImage.image = [self.bannerImagesArray objectAtIndex:self.currentImageIndex];
  self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                target:self
                                              selector:@selector(displayNextImage)
                                              userInfo:nil
                                               repeats:YES];
  
}

- (void)displayNextImage {
  self.currentImageIndex = (self.currentImageIndex + 1) % self.bannerImagesArray.count;
  //NSLog(@"Current Image Index %d", self.currentImageIndex);
  //[self animationEffect];
  self.productImage.image = [self.bannerImagesArray objectAtIndex:self.currentImageIndex];
}

-(void)stopBannerTimer {
  if (self.bannerTimer != nil) {
    [self.bannerTimer invalidate];
    self.bannerTimer = nil;
  }
}

-(void)tapDetected{
  NSLog(@"single Tap on imageview");

  if (self.bannerTimer != nil) {
    [self stopBannerTimer];
  } else {
    [self setBannerImagesArray];
  }
  
//  if ([self.productImage isAnimating])
//    [self.productImage stopAnimating];
//  else
//    [self.productImage startAnimating];
}

-(void)doubleTapDetected{
  NSLog(@"double Tap on imageview");
  //[self stopBannerTimer];
//  if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
//    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
//  else
//    [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
//
}

- (void)showData {
  _product = [Product getByID:_productID];
  if (_product == nil) {
    [Common alertTitle:@"error" Msg:@"找不到此行程相關資訊" View:self Back:false];
    return;
  }
  NSArray *imgAry = [_product.imageList componentsSeparatedByString:@","];
  self.productImage.animationImages = [NSArray array];
  
  for (NSString *imgUrl in imgAry) {
    NSString *imgFileName = [[imgUrl componentsSeparatedByString:@"/"] lastObject];
    NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
    //check img exist
    BOOL imgExist = [[NSFileManager defaultManager] fileExistsAtPath:imgFullName];
    
    if(!imgExist){
      //UIImageView *imageViewTmp = [UIImageView new];
      //[Common downloadImage:imgUrl To:imageViewTmp Cell:nil SavePath:imgFullName];
      
      NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                         [NSString stringWithFormat:@"%@",imgUrl]]];
      //NSData *imgData = UIImagePNGRepresentation(image);
      UIImage *image = [UIImage imageWithData:imageData];
      [imageData writeToFile:imgFullName atomically:YES];

      [_bannerImagesArray addObject:image];
    } else {
      UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFullName];
      
      //self.productImage.image = img;
      [_bannerImagesArray addObject:img];
    }
  }
  //self.productImage.image = [self.productImage.animationImages firstObject];
  //self.productImage.animationRepeatCount = 0;
  //self.productImage.animationDuration = 10;
  
  //[self.productImage startAnimating];
  if ([_bannerImagesArray count] > 0)
    self.productImage.image = _bannerImagesArray[0];
  [self setBannerImagesArray];
  
  self.titleLabel.text = [NSString stringWithFormat:@"  %@", _product.title];
  self.contentLabel.text = _product.content;
  self.maxNumberLabel.text = [_product.maxNumber stringValue];
  self.periodLabel.text = [NSString stringWithFormat:@"%@ hr", _product.period];
  NSString *city = [Common getParameterByType:@"city" AndKey:_product.cityCode];
  city = [city stringByReplacingOccurrencesOfString:@"$" withString:@" "];
  self.cityLabel.text = city;
  self.priceLabel.text = [NSString stringWithFormat:@"%@ $%.1f", _product.currency, [_product.price floatValue]];
  self.numberOfPeopleSlider.maximumValue = [_product.maxNumber floatValue];
  self.totalPriceLabel.text = self.priceLabel.text;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  BOOL editable = YES;
  if (textField == self.numberOfPeopleText) {
    editable = NO;
  }
  
  return editable;
}

- (IBAction)slideChange:(id)sender {
  if (_product == nil) {
    return;
  }
  int numPeople = (int)self.numberOfPeopleSlider.value;
  self.numberOfPeopleText.text = [NSString stringWithFormat:@"%i", numPeople];
  float price = [_product.price floatValue];
  
  self.totalPriceLabel.text = [NSString stringWithFormat:@"%@ $%.1f", _product.currency,(numPeople * price)];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  //[self.productImage startAnimating];
  
}

- (IBAction)sendMsgClick:(id)sender {
  if (_product == nil) {
    return;
  }
  
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  MsgDetailViewController *detailView = (MsgDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MsgDetailView"];
  detailView.hidesBottomBarWhenPushed = YES;
  
  detailView.otherType = _product.userType;
  detailView.otherID = _product.userID;
  [self.navigationController pushViewController:detailView animated:NO];
  
  User *user = [User getByType:_product.userType AndID:_product.userID];
  if (user != nil)
    detailView.navigationItem.title = user.name;

}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self stopBannerTimer];
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
