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
#import "MsgDetailViewController.h"
#import "Message.h"
#import "CustomBadge.h"
#import "UIButton+CustomBadge.h"
#import "MainTabBarController.h"

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
         [Message updateWithArray:responseObject];
         [self.messageTexts addObjectsFromArray:responseObject];
         NSInteger cnt = [responseObject count];
         if (cnt == 100) {
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
  _groupBadge = [NSMutableDictionary new];
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  NSArray *key;
  
  NSArray *messages = [Message getAll];
  
  for (Message *msg in messages) {
    NSString *fromType = msg.fromType;
    NSString *fromID = msg.fromID;
    NSString *toType = msg.toType;
    NSString *toID = msg.toID;
    bool isTo = false;

    if (([userType isEqual:fromType]) && ([userID isEqual:fromID])) {
      //to是否已存在於messageGroup
      key = [NSArray arrayWithObjects:toType, toID, nil];
    } else if (([userType isEqual:toType]) && ([userID isEqual:toID])) {
      //from是否已存在於messageGroup
      key = [NSArray arrayWithObjects:fromType, fromID, nil];
      isTo = true;
    }
    
    if ([_messageGroup objectForKey:key]) { //對話群組已存在
      [self.messageGroup[key] addObject:msg];
      
      if (isTo && [msg.readDT isEqualToString:@""]) {
        int cnt = [self.groupBadge[key] integerValue];
        cnt ++;
        self.groupBadge[key] = [NSString stringWithFormat:@"%d", cnt];
      }
    }else {
      NSMutableArray *ary = [NSMutableArray new];
      [ary addObject:msg];
      [self.messageGroup setObject:ary forKey:key];
      
      [self.groupBadge setObject:@"0" forKey:key];
    }
  }
  
  int totalMsg = 0;
  for (NSArray *key in self.groupBadge) {
    NSString *badge = [self.groupBadge objectForKey:key];
    totalMsg += [badge integerValue];
  }
  
  self.msgBadge = [NSString stringWithFormat:@"%d", totalMsg];
  [(MainTabBarController*)self.tabBarController setMsgBadge:self.msgBadge];

  NSLog(@"%@", [NSString stringWithFormat:@"Msg Group Count=%d", [_messageGroup count]]);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"Msg View Loaded");
  
  NSString *lastSeq = [Message getMaxSeq];
  int seq = [lastSeq integerValue];
  seq++;
  [self loadMessageTexts:[NSString stringWithFormat:@"%d", seq]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)startTimer {
  //self.parentViewController.parentViewController.navigationItem.title = @"Hello";
  
  if (_timer)
    return;
  //先執行一次
  [self timerEvent:_timer];
  //定時去取Msg
  _timer = [NSTimer scheduledTimerWithTimeInterval:3
                                            target:self
                                          selector:@selector(timerEvent:)
                                          userInfo:nil
                                           repeats:true];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
  //[_timer invalidate];
  //_timer = nil;
}

- (void)timerEvent:(NSTimer *)timer
{
  NSLog(@"Message Timer");
  [self prepareMessageGroup];
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
  
  NSInteger row = indexPath.row;
  NSArray *keys = [self.messageGroup allKeys];
  id aKey = [keys objectAtIndex:row];
  id anObject = [self.messageGroup objectForKey:aKey];
  
  __block int userLevel = 0;
  //Core Data中如沒有資料，則至server中取得
  User *user = [User getByType:aKey[0] AndID:aKey[1]];
  if (user != nil) {
    cell.nameLabel.text = user.name;
    userLevel = [user.level intValue];
  } else {
    NSString *urlString = [NSString stringWithFormat:@"%@%s", [Common getSetting:@"Server URL"], "user"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:@{@"type":aKey[0], @"id":aKey[1]}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [User addWithDic:responseObject[0]];
           cell.nameLabel.text = responseObject[0][@"_name"];
           userLevel = [responseObject[0][@"_level"] intValue];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
         }
     ];
  }
  
  //NSDictionary *dic = [anObject lastObject];
  Message *msg = [anObject lastObject];
  cell.msgLabel.text = [NSString stringWithFormat:@"%@", msg.msg];
  cell.datetimeLabel.text = [NSString stringWithFormat:@"%@", msg.insertDT];
  
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
  
  //對話群組badge
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame = CGRectMake(cell.photoButton.frame.origin.x, cell.photoButton.frame.origin.y*1.25,
          cell.photoButton.frame.size.width*0.9, cell.photoButton.frame.size.height);
  NSString *badge = [self.groupBadge objectForKey:aKey];
  [btn setBadgeWithString:badge];
  [cell addSubview:btn];
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
  MsgDetailViewController *detailView = (MsgDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MsgDetailView"];
  detailView.hidesBottomBarWhenPushed = YES;
  NSArray *keys = [self.messageGroup allKeys];
  id aKey = [keys objectAtIndex:indexPath.row];
  id anObject = [self.messageGroup objectForKey:aKey];

  detailView.otherType = aKey[0];
  detailView.otherID = aKey[1];
  detailView.msgAry = anObject;
  [self.navigationController pushViewController:detailView animated:NO];
  
  NSString *name = @"";
  if ([anObject[0][@"_from_type"] isEqualToString:aKey[0]] && [anObject[0][@"_from_id"] isEqualToString:aKey[1]])
    name = anObject[0][@"_from_name"];
  else
    name = anObject[0][@"_to_name"];
  self.parentViewController.parentViewController.navigationItem.title = name;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  if ([segue.identifier isEqualToString:@"PersonalView"]) {
//    NSLog(@"aaa");
//  }
}

@end
