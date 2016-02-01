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
#import "PersonalTableViewController.h"
#import "Favorite.h"
#import "User.h"

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
         [self.favoriteText addObjectsFromArray:responseObject];
         [Favorite addWithArray:responseObject];
         [User addWithFavoriteArray:responseObject];
         
         self.favoriteArray = (NSMutableArray*)[Favorite getAll];
         [self.tableView reloadData];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.favoriteArray = (NSMutableArray*)[Favorite getAll];
         [self.tableView reloadData];
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
  self.favoriteArray = (NSMutableArray*)[Favorite getAll];
  [self.tableView reloadData];
  
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
  
  Favorite *favorite = _favoriteArray[indexPath.row];
  User *user = [User getByType:favorite.type AndID:favorite.id];
  cell.nameLabel.text = user.name;
  __weak FavoriteViewCell *weakCell = cell;
  //取得使用者頭像
  NSString *photoURL = [Common getPhotoURLByType:favorite.type AndID:favorite.id];
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
  [cell.photoButton drawCircleButton:[Common getUserLevelColor:[user.level intValue]]];
  
  cell.scoreCountLabel.text = [NSString stringWithFormat:@"(%@)", user.scoreCount];
  int score = [user.avgScore intValue];
  cell.star1Image.image = (score >= 2) ? [UIImage imageNamed:@"Star full"] : ((score >= 1) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star2Image.image = (score >= 4) ? [UIImage imageNamed:@"Star full"] : ((score >= 3) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star3Image.image = (score >= 6) ? [UIImage imageNamed:@"Star full"] : ((score >= 5) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star4Image.image = (score >= 8) ? [UIImage imageNamed:@"Star full"] : ((score >= 7) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.star5Image.image = (score >= 10) ? [UIImage imageNamed:@"Star full"] : ((score >= 9) ? [UIImage imageNamed:@"Star half"] : [UIImage imageNamed:@"Star empty"]);
  cell.genderImage.image = ([user.gender isEqual: @"female"]) ? [UIImage imageNamed:@"Female"] : [UIImage imageNamed:@"Male"];
  
  cell.ageLabel.text = [NSString stringWithFormat:@"%@", user.age];
  NSString *job = user.job;
  job = [[job componentsSeparatedByString:@","] firstObject];
  job = [Common getParameterByType:@"job" AndKey:job];
  cell.jobLabel.text = job;
  
  NSString *lang = user.lang;
  NSString *langResult = [Common convertLangCodeToString:lang];
  cell.langLabel.text = langResult;

  //NSArray *info = @[favorite.type, favorite.id];
  //[cell.favoriteButton setAccessibilityElements: info];
  NSString *infoString = [NSString stringWithFormat:@"%@$%@", favorite.type, favorite.id];
  [cell.favoriteButton setAccessibilityLabel:infoString];

  cell.favoriteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
  cell.favoriteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//  cell.photoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//  cell.photoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [cell.photoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
  
  return cell;
}

- (IBAction)onFavoriteClick:(id)sender {
  UIButton *btn = (UIButton*)sender;
//  NSArray *info = btn.accessibilityElements;
//  if (info == nil) {
//    return;
//  }
  NSString *infoString = btn.accessibilityLabel;
  if (infoString == nil) {
    return;
  }
  NSArray *info = [infoString componentsSeparatedByString:@"$"];
  [Common changeFavoriteToView:self ByType:info[0] AndID:info[1] isFavorite:NO];
  
  NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
  [self.favoriteArray removeObjectAtIndex:indexPath.row];
  //self.favoriteArray = [Favorite getAll];
  [self.tableView reloadData];
  
  NSLog(@"%@", [NSString stringWithFormat:@"favorite click : type=%@, id=%@", info[0], info[1]]);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  PersonalTableViewController *personalView = (PersonalTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PersonalView"];
  personalView.hidesBottomBarWhenPushed = YES;
  Favorite *favorite = _favoriteArray[indexPath.row];
  personalView.personType = favorite.type;
  personalView.personID = favorite.id;
  [self.navigationController pushViewController:personalView animated:YES];
}

@end
