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
  
  NSDictionary *params = @{@"type":userType, @"id":userID, @"seq":seq};
  //core data裡為空的時，取前三個月的message
  if ([seq isEqualToString:@"1"]) {
    urlString = [NSString stringWithFormat:@"%@%s", url, "message/byDate"];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-3];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *before3Month = [fmt stringFromDate:newDate];

    params = @{@"type":userType, @"id":userID, @"date":before3Month};
  }
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:urlString parameters:params
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
         }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [self prepareMessageGroup];
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
      
      //計算有幾筆未讀訊息
      if (isTo && [msg.readDT isEqualToString:@""]) {
        int cnt = [self.groupBadge[key] integerValue];
        cnt ++;
        self.groupBadge[key] = [NSString stringWithFormat:@"%d", cnt];
      }
    } else {
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

  [self updateGroupMessage];
  [self.tableView reloadData];
  //NSLog(@"%@", [NSString stringWithFormat:@"Msg Group Count=%d", [_messageGroup count]]);
}

- (void)updateGroupMessage {
  for (NSArray *key in self.messageGroup) {
    NSString *otherType = key[0];
    NSString *otherID = key[1];
    NSString *userType = [Common getSetting:@"User Type"];
    NSString *userID = [Common getSetting:@"User ID"];
     //取出與取對話者最後一筆尚未read的序號
    NSString *seq = [Message getMaxNonReadSeqFromOtherType:otherType OtherID:otherID];
    if ([seq isEqualToString:@"0"]) {
      continue;
      //seq = [Message getMaxSeq];
    }
    
    NSString *url = [Common getSetting:@"Server URL"];
    NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "message/byUser"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:@{@"type":userType, @"id":userID,
                                        @"other_type":otherType, @"other_id":otherID, @"seq":seq}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           //self.messageTexts = responseObject;
           [Message updateWithArray:responseObject];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Error: %@", error);
         }
     ];
  }
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

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
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
  UIButton *btn;
  bool haveBadgeBtn = false;
  for (UIView *view in [cell subviews]) {
    if (view.tag == 7788) {
      haveBadgeBtn = true;
      btn = (UIButton*)view;
    }
  }
  
  if (!haveBadgeBtn) {
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 7788;
    btn.frame = CGRectMake(cell.photoButton.frame.origin.x, cell.photoButton.frame.origin.y*1.25,
                           cell.photoButton.frame.size.width*0.8, cell.photoButton.frame.size.height);
    [cell addSubview:btn];
  }
  NSString *badge = [self.groupBadge objectForKey:aKey];
  [self setMsgGroupBadgeForButton:btn Value:badge];
  
  return cell;
}

- (void)setMsgGroupBadgeForButton:(UIButton*)btn Value:(NSString*)badge {
  if ([badge isEqualToString:@""] || [badge isEqualToString:@"0"])
    [btn setBadge:nil];
  else if ([badge length] > 2)
    [btn setBadgeWithString:@"99+"];
  else
    [btn setBadgeWithString:badge];
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
  
  Message *msgObj = anObject[0];
  NSString *name = @"";
  if ([msgObj.fromType isEqualToString:aKey[0]] && [msgObj.fromID isEqualToString:aKey[1]])
    name = msgObj.fromName;
  else
    name = msgObj.toName;
  self.parentViewController.parentViewController.navigationItem.title = name;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  if ([segue.identifier isEqualToString:@"PersonalView"]) {
//    NSLog(@"aaa");
//  }
}

@end
