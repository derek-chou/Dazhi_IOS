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

@interface FavoriteTableViewController () {
  //UITableView *_tableView;
  //CGFloat _lastPosition;
  //CGRect _viewDefaultFrame;
  //CGRect _tabbarDefaultFrame;
}
@end

@implementation FavoriteTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
  //CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49);
  //_tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
  
//  _viewDefaultFrame = frame;
  //_tableView.delegate = self;
  //_tableView.dataSource = self;
  //[self.view addSubview:_tableView];
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
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *cellID = @"FavoriteCell";

  //cell如不存在，則建立之
  FavoriteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[FavoriteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  cell.nameLabel.text = [NSString stringWithFormat:@"Favorite %li",(long)indexPath.row];
  [cell.photoButton setImage:[UIImage imageNamed:@"top5_b1.png"] forState:UIControlStateNormal];
  
  //畫圓框
  [cell.photoButton drawCircleButton:[UIColor redColor]];
  
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
