//
//  TopicTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "TopicTableViewController.h"
#import "TopicViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ProdSearchResultViewController.h"
#import "Common.h"

@interface TopicTableViewController ()

@end

@implementation TopicTableViewController

- (void) loadTopicTexts
{
  self.topicTexts = [NSMutableArray arrayWithCapacity:20];
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "topic"];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:@{@"seq":@"0"}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.topicTexts = responseObject;
         [self.tableView reloadData];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
       }
   ];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadTopicTexts];
  
  
  if (self.searchBar == nil) {
    CGRect rect = CGRectMake(self.tableView.frame.origin.x,
                             self.tableView.frame.origin.y+5, self.tableView.frame.size.width, 35);
    self.searchBar = [[UISearchBar alloc] initWithFrame:rect];
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    [self.searchBar setTintColor:[UIColor clearColor]];
    [self.searchBar setAlpha:0.6];
    [self.searchBar setBackgroundImage:[UIImage new]];
    self.searchBar.delegate = self;
    [self.tableView addSubview:self.searchBar];
  }
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  self.parentViewController.parentViewController.navigationItem.title = @"Hello";
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
  return [self.topicTexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"TopicCell";
  
  TopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[TopicViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
    
  NSDictionary *topicText = self.topicTexts[indexPath.row];
  cell.titleLabel.text = [NSString stringWithFormat:@"  %@  ", topicText[@"_title"]];
  cell.descLabel.text = [NSString stringWithFormat:@"  %@  ", topicText[@"_content"]];

  NSString *imgURL = topicText[@"_imageurl"];
  
  NSString *imgFileName = [[imgURL componentsSeparatedByString:@"/"] lastObject];
  NSString *imgFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), imgFileName];
  //check img exist
  BOOL imgExist = [[NSFileManager defaultManager] fileExistsAtPath:imgFullName];
  
  __weak TopicViewCell *weakCell = cell;
  if(!imgExist){
    [Common downloadImage:imgURL To:cell.thumbImageView Cell:weakCell SavePath:imgFullName];
  } else {
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFullName];
 
    weakCell.thumbImageView.image = img;
    [weakCell setNeedsLayout];
  }

  return cell;
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm {
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSLog(@"do search");
  [self.searchBar resignFirstResponder];
  self.searchBar.text = @"";
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//  [self.searchBar resignFirstResponder];
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//  [self.searchBar resignFirstResponder];
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  ProdSearchResultViewController *productView = (ProdSearchResultViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ProdSearchResultView"];
  productView.hidesBottomBarWhenPushed = YES;
  productView.title = @"";
  productView.topicID = self.topicTexts[indexPath.row][@"_id"];

  [self.navigationController pushViewController:productView animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGRect rect = _searchBar.frame;
  
  CGPoint currentOffset = scrollView.contentOffset;
  if (currentOffset.y > self.lastContentOffset.y && self.tableView.bounds.origin.y != 0)
    rect.origin.y = -1;
  else
    rect.origin.y = self.tableView.bounds.origin.y + 3;
  self.lastContentOffset = currentOffset;
  
  //rect.origin.y = self.tableView.bounds.origin.y + 3;
  //NSLog(@"%@", [NSString stringWithFormat:@"rect.origin.y = %f", rect.origin.y]);
  _searchBar.frame = rect;
}

@end
