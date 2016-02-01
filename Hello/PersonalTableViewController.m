//
//  PersonalTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/25.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "PersonalTableViewController.h"
#import "PersonalCell.h"
#import "PersonalHeaderCell.h"
#import "Common.h"
#import "User.h"
#import "Product.h"
#import "AFNetworking.h"
#import "ProductDetailViewController.h"
#import "MsgDetailViewController.h"
#import "ReviewCell.h"
#import "ReviewHeaderCell.h"

@interface PersonalTableViewController ()

@end

@implementation PersonalTableViewController

- (void) loadProduct {
  self.productArray = [NSMutableArray arrayWithCapacity:20];
  NSString *urlString;
  NSDictionary *params;
  urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "product/byID"];
  params = @{@"type":_personType, @"id":_personID, @"seq":@"0"};
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.productArray = responseObject;
         [self.tableView reloadData];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"loadProduct Error: %@", error);
       }
   ];
}

- (void) loadReview {
  self.reviewArray = [NSMutableArray arrayWithCapacity:20];
  NSString *urlString;
  NSDictionary *params;
  urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "comment"];
  params = @{@"type":_personType, @"id":_personID, @"seq":@"0"};
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.reviewArray = responseObject;
         
//         CGRect frame = self.tableV.frame;
//         int height = 25 + (40 * [responseObject count]);
//         CGRect rect = CGRectMake(frame.origin.x, 0, frame.size.width, height);
//         self.tableV.frame = rect;
         [self.tableV reloadData];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"loadReview Error: %@", error);
       }
   ];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _tableV.dataSource = self;
  _tableV.delegate = self;
  
  [self.tableView setBackgroundView:nil];
  self.tableView.backgroundColor = [UIColor whiteColor];
  
  [self loadProduct];
  [self loadReview];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.tableV) {
    return [self.reviewArray count];
  } else
    return [self.productArray count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  _beginScrollView = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if(_beginScrollView == nil)
    _beginScrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
//  if (scrollView == self.tableV)
//    self.tableView.contentOffset = scrollView.contentOffset;
//  else if (scrollView == self.tableView)
//    self.tableV.contentOffset = scrollView.contentOffset;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView == _tableV) {
    static NSString *reviewCellID = @"ReviewCell";
    
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewCellID];
    if (cell == nil) {
      cell = [[ReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewCellID];
    }
    
    NSInteger row = indexPath.row;
    NSDictionary *reviewDic = self.reviewArray[row];
    NSString *comment = [Common getNSCFString:reviewDic[@"_comment"]];
    if ([comment isEqualToString:@""]) {
      comment = @" ";
    }
    cell.reviewLabel.text = comment;
    cell.reviewDTLabel.text = reviewDic[@"_insert_dt"];
    
    NSString *reviewUserType = [Common getNSCFString:reviewDic[@"_from_type"]];
    NSString *reviewUserID = [Common getNSCFString:reviewDic[@"_from_id"]];
    
    NSString *imgURL = [Common getPhotoURLByType:reviewUserType AndID:reviewUserID];
    NSString *imgFileName = [[imgURL componentsSeparatedByString:@"//"] lastObject];
    imgFileName = [imgFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
    //check img exist
    BOOL imgExist = [[NSFileManager defaultManager] fileExistsAtPath:imgFullName];
    __weak ReviewCell *weakCell = cell;
    if(!imgExist){
      [Common downloadImage:imgURL ToBtn:cell.photoBtn Cell:weakCell SavePath:imgFullName];
    } else {
      UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFullName];
      
      [cell.photoBtn setImage:img forState:UIControlStateNormal];
      [weakCell setNeedsLayout];
    }
    [cell.photoBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    User *user = [User getByType:reviewUserType AndID:reviewUserID];
    if (user == nil) {
      [Common loadUserByType:reviewUserType AndID:reviewUserID];
      [cell.photoBtn drawCircleButton:[Common getUserLevelColor:0]];
    } else
      [cell.photoBtn drawCircleButton:[Common getUserLevelColor:[user.level intValue]]];

    return cell;
  } else {
    static NSString *cellID = @"PersonalCell";

    PersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
      cell = [[PersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSInteger row = indexPath.row;
    NSDictionary *prodDic = self.productArray[row];
    
    NSString *imgList = [Common getNSCFString:prodDic[@"_image"]];
    if ([imgList isEqualToString:@""]) {
      return cell;
    }
    NSString *imgURL = [[prodDic[@"_image"] componentsSeparatedByString:@","] lastObject];
    
    NSString *imgFileName = [[imgURL componentsSeparatedByString:@"/"] lastObject];
    NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
    //check img exist
    BOOL imgExist = [[NSFileManager defaultManager] fileExistsAtPath:imgFullName];
    
    __weak PersonalCell *weakCell = cell;
    if(!imgExist){
      [Common downloadImage:imgURL To:cell.photoView Cell:weakCell SavePath:imgFullName];
    } else {
      UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFullName];
      
      weakCell.photoView.image = img;
      [weakCell setNeedsLayout];
    }
    
    cell.priceLabel.text = [Common getNSCFString:prodDic[@"_price"]];
    cell.titleLabel.text = [Common getNSCFString:prodDic[@"_title"]];
    cell.contentLabel.text = [Common getNSCFString:prodDic[@"_content"]];
    cell.carImage.image = ([prodDic[@"_car"]boolValue]) ? [UIImage imageNamed:@"Car"] : [UIImage imageNamed:@"NonCar"];
    cell.drinkImage.image = ([prodDic[@"_drink"]boolValue]) ? [UIImage imageNamed:@"Drink"] : [UIImage imageNamed:@"NonDrink"];
    cell.roomImage.image = ([prodDic[@"_photo"]boolValue]) ? [UIImage imageNamed:@"Room"] : [UIImage imageNamed:@"NonRoom"];
    cell.smokeImage.image = ([prodDic[@"_smoke"]boolValue]) ? [UIImage imageNamed:@"Smoke"] : [UIImage imageNamed:@"NonSmoke"];

    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (tableView == self.tableView)
    return 180.0f;
  else
    return 25.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (tableView == _tableV) {
    static NSString *reviewHeadCellID = @"ReviewHeaderCell";
    
    ReviewHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewHeadCellID];
    if (cell == nil){
      cell = [[ReviewHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewHeadCellID];
    }
    
    cell.reviewCountLabel.text = [NSString stringWithFormat:@"%d 評論", [self.reviewArray count]];
    return cell;
  } else {
    static NSString *headCellID = @"PersonalHeaderCell";

    PersonalHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headCellID];
    if (cell == nil){
      cell = [[PersonalHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headCellID];
    }
    
    NSString *imgURL = [Common getPhotoURLByType:_personType AndID:_personID];
    NSString *imgFileName = [[imgURL componentsSeparatedByString:@"//"] lastObject];
    imgFileName = [imgFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
    //check img exist
    BOOL imgExist = [[NSFileManager defaultManager] fileExistsAtPath:imgFullName];
    __weak PersonalHeaderCell *weakCell = cell;
    if(!imgExist){
      [Common downloadImage:imgURL ToBtn:cell.photoButton Cell:weakCell SavePath:imgFullName];
    } else {
      UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFullName];
      
      [cell.photoButton setImage:img forState:UIControlStateNormal];
      [weakCell setNeedsLayout];
    }
    
    User *user = [User getByType:_personType AndID:_personID];
    if (user == nil)
      [Common loadUserByType:_personType AndID:_personID];
    [cell.photoButton drawCircleButton:[Common getUserLevelColor:[user.level intValue]]];
    [cell.photoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];

    cell.scoreRating.value = [user.avgScore floatValue] / 2;
    cell.reviewCount.text = [NSString stringWithFormat:@"(%@)", user.scoreCount];
    if ([user.gender isEqualToString:@"male"])
      cell.gender.image = [UIImage imageNamed:@"Male"];
    else
      cell.gender.image = [UIImage imageNamed:@"Female"];
    cell.name.text = user.name;
    cell.age.text = user.age;
    cell.job.text = [Common convertJobCodeToString:user.job];
    cell.lang.text = [Common convertLangCodeToString:user.lang];
    cell.desc.text = [NSString stringWithFormat:@"個人說明 : %@", user.desc];

    return cell;
  }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  UIViewController *prodDetailView = (UIViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ProductDetailViewController"];
  prodDetailView.hidesBottomBarWhenPushed = YES;
  NSInteger row = indexPath.row;
  NSDictionary *prodDic = self.productArray[row];
  //NSString *naviTitle = [NSString stringWithFormat:@"%@", prodDic[@"_title"]];

  //self.navigationItem.title = naviTitle;
  [(ProductDetailViewController *)prodDetailView setProductID:prodDic[@"_product_id"]];
  
  [self.navigationController pushViewController:prodDetailView animated:YES];
}

- (IBAction)onSendMessageClick:(id)sender {
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  MsgDetailViewController *detailView = (MsgDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MsgDetailView"];
  detailView.hidesBottomBarWhenPushed = YES;
  
  detailView.otherType = _personType;
  detailView.otherID = _personID;
  [self.navigationController pushViewController:detailView animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == _tableV) {
    return;
  }
  //畫section邊框
  if ([cell respondsToSelector:@selector(tintColor)]) {
    CGFloat cornerRadius = 8.f;
    cell.backgroundColor = UIColor.clearColor;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    BOOL addLine = NO;
    NSInteger rowIdx = indexPath.row;
    NSInteger rowsInSection = [tableView numberOfRowsInSection:indexPath.section];
    
    if (rowIdx == 0 && rowIdx == rowsInSection-1) {
      CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
      
    } else if (rowIdx == 0) {
      CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
      addLine = YES;
    } else if (rowIdx == rowsInSection-1) {
      CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
      CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
      CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
      //CGPathAddRect(pathRef, nil, bounds);
      addLine = YES;
    }
    
    layer.path = pathRef;
    CFRelease(pathRef);
    //set the border color
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    //set the border width
    layer.lineWidth = 2;
    layer.fillColor = [UIColor colorWithWhite:1.f alpha:1.0f].CGColor;
    
    if (addLine == YES) {
      CALayer *lineLayer = [[CALayer alloc] init];
      CGFloat lineHeight = (3.f / [UIScreen mainScreen].scale);
      lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width - 10, lineHeight);
      lineLayer.backgroundColor = tableView.separatorColor.CGColor;
      [layer addSublayer:lineLayer];
    }
    
    UIView *testView = [[UIView alloc] initWithFrame:bounds];
    [testView.layer insertSublayer:layer atIndex:0];
    testView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = testView;
  }
}


@end
