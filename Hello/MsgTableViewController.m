//
//  MsgTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/17.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MsgTableViewController.h"
#import "ViewController.h"
#import "MsgViewCell.h"
#import "Common.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface MsgTableViewController ()

@end

@implementation MsgTableViewController

- (void) loadMessageTexts:(NSString*)seq
{
  if (_messageTexts == nil) {
    _messageTexts = [NSMutableArray arrayWithCapacity:20];
  }
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "message"];
  
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:@{@"type":userType, @"id":userID, @"seq":seq}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //self.messageTexts = responseObject;
         [self.messageTexts addObjectsFromArray:responseObject];
         NSInteger cnt = [responseObject count];
         if (cnt > 0) {
           NSString *seq = responseObject[cnt-1][@"_seq_id"];
           int iSeq = [seq intValue];
           iSeq++;
           [self loadMessageTexts:[NSString stringWithFormat:@"%d", iSeq]];
         } else {
           [self prepareMessageGroup];
           [self.tableView reloadData];
         }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
       }
   ];
}

- (void) prepareMessageGroup {
  _messageGroup = [NSMutableDictionary new];
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  NSArray *key;
  
  for (NSDictionary *dic in self.messageTexts) {
    NSString *fromType = dic[@"_from_type"];
    NSString *fromID =  dic[@"_from_id"];
    if (([userType isEqual:fromType]) && ([userID isEqual:fromID])) {
      ;
    } else {
      //from是否已存在於messageGroup
      key = [NSArray arrayWithObjects:fromType, fromID, nil];
      if ([_messageGroup objectForKey:key]) {
        [self.messageGroup[key] addObject:dic];
      } else {
        NSMutableArray *ary = [NSMutableArray new];
        [ary addObject:dic];
        [self.messageGroup setObject:ary forKey:key];
      }
    }
    
    NSString *toType = dic[@"_to_type"];
    NSString *toID =  dic[@"_to_id"];
    if (([userType isEqual:toType]) && ([userID isEqual:toID])) {
      ;
    } else {
      //to是否已存在於messageGroup
      key = [NSArray arrayWithObjects:toType, toID, nil];
      if ([_messageGroup objectForKey:key]) {
        [self.messageGroup[key] addObject:dic];
      }else {
        NSMutableArray *ary = [NSMutableArray new];
        [ary addObject:dic];
        [self.messageGroup setObject:ary forKey:key];
      }
    }
  }
  NSLog(@"%@", [NSString stringWithFormat:@"Msg Group Count=%d", [_messageGroup count]]);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadMessageTexts:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  self.parentViewController.parentViewController.navigationItem.title = @"Hello";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.messageGroup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"MsgCell";
  
  //cell如不存在，則建立之
  MsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[MsgViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  int row = indexPath.row;
  NSArray *keys = [self.messageGroup allKeys];
  id aKey = [keys objectAtIndex:row];
  id anObject = [self.messageGroup objectForKey:aKey];
  
  __block int userLevel = 0;
  //Core Data中如沒有資料，則至server中取得
  User *user = [User getUser:aKey[0] :aKey[1]];
  if (user != nil) {
    cell.nameLabel.text = user.name;
    userLevel = [user.level intValue];
  } else {
    NSString *urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:@{@"type":aKey[0], @"id":aKey[1]}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [User addUser:responseObject[0]];
           cell.nameLabel.text = responseObject[0][@"_name"];
           userLevel = [responseObject[0][@"_level"] intValue];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
         }
     ];
  }
  
  NSDictionary *dic = [anObject lastObject];
  cell.msgLabel.text = [NSString stringWithFormat:@"%@",dic[@"_msg"]];
  cell.datetimeLabel.text = [NSString stringWithFormat:@"%@",dic[@"_insert_dt"]];
  
  __weak MsgViewCell *weakCell = cell;
  //取得使用者頭像
  NSString *photoURL = [Common getPhotoURLByType:aKey[0] AndID:aKey[1]];
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
  [cell.photoButton drawCircleButton:[Common getUserLevelColor:userLevel]];
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  UITableViewController *detailView = (UITableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MsgDetailView"];
  detailView.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:detailView animated:NO];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  if ([segue.identifier isEqualToString:@"PersonalView"]) {
//    NSLog(@"aaa");
//  }
}

@end
