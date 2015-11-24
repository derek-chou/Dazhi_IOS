//
//  FavoriteTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/6.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "FavoriteTableViewController.h"
#import "ViewController.h"
#import "FavoriteViewCell.h"
#import "Common.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface FavoriteTableViewController () {
  //UITableView *_tableView;
  //CGFloat _lastPosition;
  //CGRect _viewDefaultFrame;
  //CGRect _tabbarDefaultFrame;
}
@end

@implementation FavoriteTableViewController

- (void) loadFavoriteArray
{
  if (_favoriteArray == nil) {
    _favoriteArray = [NSMutableArray arrayWithCapacity:20];
  }
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "favorite"];
  
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:@{@"type":userType, @"id":userID}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [self.favoriteArray addObjectsFromArray:responseObject];
         [self.tableView reloadData];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
       }
   ];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self loadFavoriteArray];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  self.parentViewController.parentViewController.navigationItem.title = @"Hello";
  /*
  if (CGRectIsEmpty(_tabbarDefaultFrame) ) {
    ViewController *vc = (ViewController *)self.parentViewController.parentViewController;
    _tabbarDefaultFrame = vc.tabBarController.tabBar.frame;
  }
  //_tableView.frame = _viewDefaultFrame;
  self.parentViewController.parentViewController.tabBarController.tabBar.frame = _tabbarDefaultFrame;
   */
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
  /*
  //_tableView.frame = _viewDefaultFrame;
  self.parentViewController.parentViewController.tabBarController.tabBar.frame = _tabbarDefaultFrame;
   */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _favoriteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *cellID = @"FavoriteCell";

  //cell如不存在，則建立之
  FavoriteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[FavoriteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  NSDictionary *dic = _favoriteArray[indexPath.row];
  cell.nameLabel.text = dic[@"_name"];
  __weak FavoriteViewCell *weakCell = cell;
  //取得使用者頭像
  NSString *photoURL = [Common getPhotoURLByType:dic[@"_favorite_type"] AndID:dic[@"_favorite_id"]];
  NSString *photoFileName = [[photoURL componentsSeparatedByString:@"//"] lastObject];
  photoFileName = [photoFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
  NSString *photoFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), photoFileName];
  //check img exist
  BOOL photoExist = [[NSFileManager defaultManager] fileExistsAtPath:photoFullName];
  if(!photoExist){
    [Common downloadImage:photoURL ToBtn:weakCell.photoButton Cell:weakCell SavePath:photoFullName];
  } else {
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:photoFullName];
    
    [weakCell.photoButton setImage:img forState:UIControlStateNormal];
    [weakCell setNeedsLayout];
  }
  //畫圓框
  [cell.photoButton drawCircleButton:[Common getUserLevelColor:[dic[@"_level"] intValue]]];
  
  cell.scoreCountLabel.text = [NSString stringWithFormat:@"(%@)", dic[@"_count"]];
  int score = [dic[@"_avg_score"] intValue];
  cell.star1Image.image = (score >= 2) ? [UIImage imageNamed:@"Star full"] : ((score >= 1) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star2Image.image = (score >= 4) ? [UIImage imageNamed:@"Star full"] : ((score >= 3) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star3Image.image = (score >= 6) ? [UIImage imageNamed:@"Star full"] : ((score >= 5) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star4Image.image = (score >= 8) ? [UIImage imageNamed:@"Star full"] : ((score >= 7) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star5Image.image = (score >= 10) ? [UIImage imageNamed:@"Star full"] : ((score >= 9) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.genderImage.image = ([dic[@"_gender"] isEqual: @"female"]) ? [UIImage imageNamed:@"Female"] : [UIImage imageNamed:@"Male"];
  
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
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  UITableViewController *personalView = (UITableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PersonalView"];
  personalView.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:personalView animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
