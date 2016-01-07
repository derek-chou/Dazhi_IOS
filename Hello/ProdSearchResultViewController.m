//
//  ProdSearchResultViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/10.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "ProdSearchResultViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ProductViewCell.h"
#import "ProductFooterViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "PersonalTableViewController.h"
#import "favorite.h"

@interface ProdSearchResultViewController ()

@end

@implementation ProdSearchResultViewController

- (void) loadProduct {
  self.productArray = [NSMutableArray arrayWithCapacity:20];
  NSString *urlString;
  NSDictionary *params;
  if (self.searchType == SEARCH_BY_TOPIC) {
    urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "product/byTopicID"];
    params = @{@"topicID":self.searchText};
  } else {
    urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "product/search"];
    self.searchText = [_searchText stringByReplacingOccurrencesOfString:@"%" withString:@""];
    params = @{@"str":self.searchText};
  }
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if ([responseObject count] == 0) {
           [Common alertTitle:@"sorry" Msg:@"未找到相關行程" View:self Back:true];
           
         }
         self.productArray = responseObject;
         [self prepareProduct];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
       }
   ];
  
  self.favoriteAry = [Favorite getAll];
}

- (void) prepareProduct {
  self.productDic = [NSMutableDictionary new];
  self.userDic = [NSMutableDictionary new];
  
  @try {
  //將取得的資料整理成[key - ary]
  for(NSDictionary* obj in self.productArray) {
    //NSString *key = [NSString stringWithFormat:@"%@_%@", obj[@"_usertype"], obj[@"_userid"]];
    NSArray *key = [NSArray arrayWithObjects:obj[@"_usertype"], obj[@"_userid"], nil];
    if ([self.productDic objectForKey:key]) {
      [self.productDic[key] addObject:obj];
    } else {
      NSMutableArray *ary = [NSMutableArray new];
      [ary addObject:obj];
      [self.productDic setObject:ary forKey:key];

      //放入User Dic中，待至server查詢
      [self.userDic setObject:[NSMutableArray new] forKey:key];
    }
  }

  //至server端查詢user data
  for (NSArray *key in self.userDic) {
    //判斷Core Data中是否有此使用者資訊
    NSDictionary *retDic = [self getUserData:key[0]:key[1]];
    if (retDic != nil) {
      [self.userDic[key] addObject:retDic];
      [self userDataFinish];
      continue;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:@{@"type":key[0], @"id":key[1]}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           if ([responseObject count] == 0) {
             return;
           }
           NSArray *retKey = [NSArray arrayWithObjects:responseObject[0][@"_type"], responseObject[0][@"_id"], nil];
       
           if ([self.userDic objectForKey:retKey]) {
             [self.userDic[retKey] addObject:responseObject[0]];
           }
           [User addWithDic:responseObject[0]];
           
           [self userDataFinish];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
           [self userDataFinish];
         }
     ];
  }
  } @catch (NSException * e) {
    NSLog(@"prepareProduct Exception: %@", e);
    return;
  }
}

- (NSDictionary *)getUserData:(NSString*)type :(NSString*)id {
  User *user = [User getByType:type AndID:id];
  
  if (user == nil) {
    return nil;
  } else {
    //NSString *age = user.age;
    NSDictionary *retDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:user.type, user.id, user.name, user.avgScore, user.scoreCount, user.gender, user.age, user.job, user.lang, user.link, user.level, nil] forKeys:[NSArray arrayWithObjects:@"_type", @"_id", @"_name", @"_avg_score", @"_count", @"_gender", @"_age", @"_job", @"_lang", @"_link", @"_level", nil]];
    return retDic;
  }
}

- (void) userDataFinish {
  bool bReload = YES;
  for (NSArray *key in self.userDic) {
    if ([self.userDic[key] count] == 0) {
      bReload = NO;
      break;
    }
  }
  
  if (bReload)
    [self.tableView reloadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self loadProduct];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //第一個section空白5單位
  [self.tableView setContentInset:UIEdgeInsetsMake(5,0,0,0)];
  
  //tableview的style改為grouped時,背景會自動改為灰色，透過以下二行將背景色改為白色
  [self.tableView setBackgroundView:nil];
  self.tableView.backgroundColor = [UIColor whiteColor];  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger sectionCnt = [self.productDic count];
  return sectionCnt;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *keys = [self.productDic allKeys];
  id aKey = [keys objectAtIndex:section];
  NSInteger rows = [self.productDic[aKey] count];
  return rows;
}

- (IBAction)onFavoriteClick:(id)sender {
  NSLog(@"favorite click");
  UIButton *btn = (UIButton*)sender;
  NSArray *info = btn.accessibilityElements;
  if (info == nil) {
    return;
  }
  
  NSString *type = info[0];
  NSString *_id = info[1];
  NSString *status = info[2];

  NSArray *newInfo;
  if ([status isEqualToString:@"Favorite"]) {
    [btn setImage:[UIImage imageNamed:@"NonFavorite"] forState:UIControlStateNormal];
    newInfo = @[type, _id, @"NonFavorite"];
    [Common changeFavoriteToView:self ByType:type AndID:_id isFavorite:NO];
  } else {
    [btn setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    newInfo = @[type, _id, @"Favorite"];
    [Common changeFavoriteToView:self ByType:type AndID:_id isFavorite:YES];
  }
  [btn setAccessibilityElements:newInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"ProductCell";
  
  ProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[ProductViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  //NSInteger rowsInSection = [tableView numberOfRowsInSection:indexPath.section];
  NSInteger row = indexPath.row;
  NSArray *keys = [self.productDic allKeys];
  id aKey = [keys objectAtIndex:indexPath.section];
  NSDictionary *prodDic = self.productDic[aKey][row];
  cell.titleLabel.text = [NSString stringWithFormat:@"%@", prodDic[@"_title"]];
  cell.descLabel.text = [NSString stringWithFormat:@"%@", prodDic[@"_content"]];
  cell.feeLabel.text = [NSString stringWithFormat:@"$%@", prodDic[@"_price"]];
  cell.carImage.image = ([prodDic[@"_car"]boolValue]) ? [UIImage imageNamed:@"Car"] : [UIImage imageNamed:@"NonCar"];
  cell.drinkImage.image = ([prodDic[@"_drink"]boolValue]) ? [UIImage imageNamed:@"Drink"] : [UIImage imageNamed:@"NonDrink"];
  cell.roomImage.image = ([prodDic[@"_photo"]boolValue]) ? [UIImage imageNamed:@"Room"] : [UIImage imageNamed:@"NonRoom"];
  cell.smokeImage.image = ([prodDic[@"_smoke"]boolValue]) ? [UIImage imageNamed:@"Smoke"] : [UIImage imageNamed:@"NonSmoke"];
  
  NSArray *userKeys = [self.userDic allKeys];
  id userKey = [userKeys objectAtIndex:indexPath.section];
  NSDictionary *userDic;
  NSInteger valueCnt = [[self.userDic objectForKey:userKey] count];
  NSString *btnStatus = @"NonFavorite";
  if ( valueCnt > 0) {
    userDic = self.userDic[userKey][0];
    if ([Favorite getByType:userDic[@"_type"] AndID:userDic[@"_id"]]) {
      [cell.favoriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
      btnStatus = @"Favorite";
    } else {
      [cell.favoriteButton setImage:[UIImage imageNamed:@"NonFavorite"] forState:UIControlStateNormal];
      btnStatus = @"NonFavorite";
    }
    
    NSArray *info = @[userDic[@"_type"], userDic[@"_id"], btnStatus];
    [cell.favoriteButton setAccessibilityElements: info];
  }
  //cell.favoriteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
  //[cell.favoriteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
  cell.favoriteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
  cell.favoriteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
  
  NSString *imgList = [Common getNSCFString:prodDic[@"_image"]];
  if ([imgList isEqualToString:@""]) {
    return cell;
  }
  NSString *imgURL = [[prodDic[@"_image"] componentsSeparatedByString:@","] lastObject];
  
  NSString *imgFileName = [[imgURL componentsSeparatedByString:@"/"] lastObject];
  NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
  //check img exist
  BOOL imgExist = [[NSFileManager defaultManager] fileExistsAtPath:imgFullName];
  
  __weak ProductViewCell *weakCell = cell;
  if(!imgExist){
    [Common downloadImage:imgURL To:cell.productImage Cell:weakCell SavePath:imgFullName];
  } else {
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFullName];
    
    weakCell.productImage.image = img;
    [weakCell setNeedsLayout];
  }
  return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  static NSString *cellID = @"SectionFooter";
  
  //NSArray *keys = [self.productDic allKeys];
  ProductFooterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil){
    cell = [[ProductFooterViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  cell.backgroundColor = [UIColor whiteColor];

  NSArray *keys = [self.userDic allKeys];
  id aKey = [keys objectAtIndex:section];
  NSDictionary *dic;
  NSInteger valueCnt = [[self.userDic objectForKey:aKey] count];
  if ( valueCnt > 0) {
    @try{
      dic = self.userDic[aKey][0];
    
      cell.nameLabel.text = dic[@"_name"];
      cell.scoreCountLabel.text = [NSString stringWithFormat:@"(%@)", dic[@"_count"]];
      int score = [dic[@"_avg_score"] intValue];
      cell.star1Image.image = (score >= 2) ? [UIImage imageNamed:@"Star full"] : ((score >= 1) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
      cell.star2Image.image = (score >= 4) ? [UIImage imageNamed:@"Star full"] : ((score >= 3) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
      cell.star3Image.image = (score >= 6) ? [UIImage imageNamed:@"Star full"] : ((score >= 5) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
      cell.star4Image.image = (score >= 8) ? [UIImage imageNamed:@"Star full"] : ((score >= 7) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
      cell.star5Image.image = (score >= 10) ? [UIImage imageNamed:@"Star full"] : ((score >= 9) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
      
      cell.genderImage.image = ([dic[@"_gender"] isEqual: @"female"]) ? [UIImage imageNamed:@"Female"] : [UIImage imageNamed:@"Male"];

      //_age, _job, _lang有可能是null
      //為什麼NSNull的exception抓不到？
      cell.ageLabel.text = [NSString stringWithFormat:@"%@", (dic[@"_age"] == [NSNull null]) ? @"" : dic[@"_age"]];
      NSString *job = ([dic[@"_job"] isKindOfClass:[NSNull class]]) ? @"" : [NSString stringWithFormat:@"%@", dic[@"_job"]];
      job = [[job componentsSeparatedByString:@","] firstObject];
      job = [Common getParameterByType:@"job" AndKey:job];
      cell.jobLabel.text = job;
      
      NSString *lang = ([dic[@"_lang"] isKindOfClass:[NSNull class]]) ? @"" : [NSString stringWithFormat:@"%@", dic[@"_lang"]];
      NSArray *ary = [lang componentsSeparatedByString:@","];
      NSString *langResult = @"";
      for (NSString *str in ary) {
        NSString *tmp = [langResult stringByAppendingString:[Common getParameterByType:@"lang" AndKey:str]];
        langResult = tmp;
      
        if (![str isEqual: [ary lastObject]])
          langResult = [langResult stringByAppendingString:@","];
      }
      cell.langLabel.text = langResult;
      

      //CGRect oldFrame = cell.photoButton.frame;
      CGFloat xPosition = self.tableView.frame.size.width * 0.77;
      
      CircleButton *photoBtn = [[CircleButton alloc] initWithFrame:CGRectMake(xPosition, -25, 50, 50)];
      [photoBtn drawCircleButton:[Common getUserLevelColor:[dic[@"_level"] intValue]]];
      [photoBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
      [photoBtn setUserInteractionEnabled:NO];
      // add to a view
      cell.clipsToBounds = NO;
      [cell addSubview:photoBtn];
      [cell bringSubviewToFront:photoBtn];
      
      NSString *imgURL = [Common getPhotoURLByType:dic[@"_type"] AndID:dic[@"_id"]];
      NSString *imgFileName = [[imgURL componentsSeparatedByString:@"//"] lastObject];
      imgFileName = [imgFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
      NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
      //check img exist
      BOOL imgExist = [[NSFileManager defaultManager] fileExistsAtPath:imgFullName];
      __weak ProductFooterViewCell *weakCell = cell;
      if(!imgExist){
        [Common downloadImage:imgURL ToBtn:photoBtn Cell:weakCell SavePath:imgFullName];
      } else {
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFullName];
        
        [photoBtn setImage:img forState:UIControlStateNormal];
        [weakCell setNeedsLayout];
      }
      
      cell.tag = section;
      UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(handleGesture:)];
      [singleTapRecognizer setDelegate:(id)self];
      singleTapRecognizer.numberOfTouchesRequired = 1;
      singleTapRecognizer.numberOfTapsRequired = 1;
      [cell addGestureRecognizer:singleTapRecognizer];
    } @catch (NSException * e) {
      NSLog(@"viewForFooterInSection Exception: %@", e);
    }

  }
  
  return cell;
}

-(void) handleGesture:(UIGestureRecognizer *)gestureRecognizer {
  NSArray *keys = [self.userDic allKeys];
  ProductFooterViewCell *footer = (ProductFooterViewCell*)gestureRecognizer.view;
  id aKey = [keys objectAtIndex:footer.tag];
  NSDictionary *dic;
  NSInteger valueCnt = [[self.userDic objectForKey:aKey] count];
  if ( valueCnt > 0) {
    dic = self.userDic[aKey][0];
  
  
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    PersonalTableViewController *personalView = (PersonalTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PersonalView"];
    personalView.hidesBottomBarWhenPushed = YES;
    personalView.personType = dic[@"_type"];
    personalView.personID = dic[@"_id"];
    [self.navigationController pushViewController:personalView animated:YES];
  }

}

//計算中英文混合的字串長度，中文算2
- (int)calcStringLength:(NSString*)strtemp
{
  int strlength = 0;
  char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
  for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
    if (*p) {
      p++;
      strlength++;
    }
    else {
      p++;
    }
    
  }
  return strlength;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  UIViewController *prodDetailView = (UIViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ProductDetailViewController"];
  prodDetailView.hidesBottomBarWhenPushed = YES;
  NSInteger row = indexPath.row;
  NSArray *keys = [self.productDic allKeys];
  id aKey = [keys objectAtIndex:indexPath.section];
  NSDictionary *prodDic = self.productDic[aKey][row];
//  NSString *naviTitle = [NSString stringWithFormat:@"%@(%@)", prodDic[@"_title"], prodDic[@"_product_id"]];
  NSString *naviTitle = [NSString stringWithFormat:@"%@", prodDic[@"_title"]];
  //prodDetailView.navigationItem.title = [NSString stringWithFormat:@"%@", naviTitle];
//  int naviTitleLen = [naviTitle length];
//  int len = MIN(naviTitleLen, 17);
//  if (len == 17)
//    naviTitle = [NSString stringWithFormat:@"%@...", [naviTitle substringToIndex:14]];
  //naviTitle = [naviTitle substringToIndex:len];
  //self.navigationItem.title = @"back";
  
  //prodDetailView.navigationItem.title = naviTitle;
  self.navigationItem.title = naviTitle;
  [(ProductDetailViewController *)prodDetailView setProductID:prodDic[@"_product_id"]];

  [self.navigationController pushViewController:prodDetailView animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  self.navigationItem.title = @"";
}
-(IBAction)buttonClicked:(id)sender {
  NSLog(@"click");
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//  return 90.f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.1f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
 
      //每個section的第一個row顯示Favorite按鈕,最後一個row顯示photo按鈕
      ((ProductViewCell*)cell).favoriteButton.hidden = NO;
      //((ProductViewCell*)cell).photoButton.hidden = NO;
    } else if (rowIdx == 0) {
      CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
      addLine = YES;

      ((ProductViewCell*)cell).favoriteButton.hidden = NO;
      //((ProductViewCell*)cell).photoButton.hidden = YES;
    } else if (rowIdx == rowsInSection-1) {
      CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
      CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));

      ((ProductViewCell*)cell).favoriteButton.hidden = YES;
      //((ProductViewCell*)cell).photoButton.hidden = NO;
    } else {
      CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
      CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
      CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
      //CGPathAddRect(pathRef, nil, bounds);
      addLine = YES;

      ((ProductViewCell*)cell).favoriteButton.hidden = YES;
      //((ProductViewCell*)cell).photoButton.hidden = YES;
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
