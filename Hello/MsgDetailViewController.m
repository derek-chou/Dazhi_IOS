//
//  MsgDetailViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "MsgDetailCell.h"
#import "Common.h"
#import "User.h"
#import "AFNetworking.h"

@interface MsgDetailViewController ()

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
  tableV.allowsSelection = NO;
  tableV.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageBackground"]];
  [tableV.backgroundView setAlpha:0.09f];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                    action:@selector(didTapOnTableView:)];
  [tableV  addGestureRecognizer:tap];
 
  _allMessageFrame = [NSMutableArray new];
  //messageView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
  //messageView.leftViewMode = UITextFieldViewModeAlways;
  //messageView.delegate = self;
  
  [self refreshMessage:0];
  //[tableV reloadData];

  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  Message *lastMsgObj = [_msgAry lastObject];
  if (lastMsgObj != nil && [lastMsgObj.readDT isEqualToString:@""] &&
      [lastMsgObj.toType isEqualToString:userType] && [lastMsgObj.toID isEqualToString:userID])
    [self setMsgRead];
}

-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
  [messageView resignFirstResponder];
}

-(void)refreshMessage:(int)oldCnt {
  NSString *prevDate = nil;
  NSArray *messages = [Message getWithOtherType:_otherType OtherID:_otherID];
  int newCnt = (int)[messages count];
  for (Message *msgObj in messages) {
    MessageFrame *mf = [MessageFrame new];
    MessageData *msg = [MessageData new];
    [msg setFromMsgObj:msgObj otherType:_otherType otherID:_otherID];
    
    //取得使用者頭像
    NSString *photoURL = [Common getPhotoURLByType:_otherType AndID:_otherID];
    NSString *photoFileName = [[photoURL componentsSeparatedByString:@"//"] lastObject];
    photoFileName = [photoFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *photoFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), photoFileName];
    //check img exist
    msg.iconImage = [UIImageView new];
    BOOL photoExist = [[NSFileManager defaultManager] fileExistsAtPath:photoFullName];
    if(!photoExist){
      [Common downloadImage:photoURL To:msg.iconImage Cell:nil SavePath:photoFullName];
    } else {
      UIImage *img = [[UIImage alloc] initWithContentsOfFile:photoFullName];
      
      msg.iconImage.image = img;
    }
    
    mf.showDate = ![prevDate isEqualToString:msg.date];
    prevDate = msg.date;
    mf.message = msg;
    [_allMessageFrame addObject:mf];
  }

  [tableV reloadData];
  
  if (oldCnt != newCnt) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessageFrame.count-1 inSection:0];
    [tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    [self setMsgRead];
  }
}

-(void) setMsgRead {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  
  NSString *seq = [Message getMaxNonReadSeqFromOtherType:_otherType OtherID:_otherID];

  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "message"];
  NSDictionary *params = @{@"to_type":userType, @"to_id":userID,
                           @"from_type":_otherType, @"from_id":_otherID, @"seq":seq};
  [manager PUT:urlString parameters:params
  success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"setMsgRead: %@", responseObject);
  }
  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Error: %@", error);
  }];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  //讓scroll bar移到最底
  CGPoint offset = CGPointMake(0, tableV.contentSize.height - tableV.frame.size.height);
  [tableV setContentOffset:offset animated:NO];
  
  [self startTimer];
}

-(void)startTimer {
  if (_pollingTimer != nil)
    return;
  
  _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                   target:self
                                                 selector:@selector(timerPolling:)
                                                 userInfo:nil
                                                  repeats:true];
}

-(void)stopTimer {
  [_pollingTimer invalidate];
  _pollingTimer = nil;
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [_pollingTimer invalidate];
  _pollingTimer = nil;
}

-(void)timerPolling:(NSTimer *)timer {
  int oldCnt = (int)[_allMessageFrame count];
  [_allMessageFrame removeAllObjects];
  [self refreshMessage:oldCnt];
}


- (void) addMessageWithContent:(NSString*)content datetime:(NSString*)datetime {
  MessageFrame *lastFrame = [_allMessageFrame lastObject];
  
  MessageFrame *mf = [MessageFrame new];
  MessageData *msg = [MessageData new];
  msg.content = content;
  msg.datetime = datetime;
  NSArray *ary = [datetime componentsSeparatedByString:@" "];
  msg.date = [ary firstObject];
  msg.time = [ary lastObject];
  msg.time = [msg.time substringToIndex:5];
  msg.type = FROM_ME;
  
  //判斷最後一筆的日期是否是同一天
  if (lastFrame == nil || ![lastFrame.message.date isEqualToString:msg.date])
    mf.showDate = YES;
  
  mf.message = msg;
  [_allMessageFrame addObject:mf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)sendMessage:(id)sender {
  //[_allMessageFrame removeAllObjects];
  //[tableV reloadData];
  [self stopTimer];
  NSString *content = messageView.text;
  if ([content isEqual:@""]) {
    return;
  }

  [self sendMsgToRemote:content];
  
  NSDateFormatter *fmt = [NSDateFormatter new];
  NSDate *date = [NSDate date];
  fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
  NSString *time = [fmt stringFromDate:date];
  [self addMessageWithContent:content datetime:time];
  [tableV reloadData];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessageFrame.count - 1 inSection:0];
  [tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  messageView.text = nil;
  [self startTimer];
}

- (void)sendMsgToRemote:(NSString*)msg {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  
  NSString *url = [Common getSetting:@"Server URL"];
  NSString *urlString = [NSString stringWithFormat:@"%@%s", url, "message"];
  NSDictionary *params = @{@"to_type":_otherType, @"to_id":_otherID,
                           @"from_type":userType, @"from_id":userID, @"msg":msg};
  [manager POST:urlString parameters:params
  success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"sendMsgToRemote: %@", responseObject);
  }
  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    [Common alertTitle:@"error" Msg:@"訊息無法發送，請稍侯再試" View:self Back:false];
  }];
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_allMessageFrame count];
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  NSInteger row = indexPath.row;
  return [_allMessageFrame[row] cellHeight];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  static NSString *cellID = @"msgDetailCell";
  MsgDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[MsgDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }

  cell.messageFrame = ([_allMessageFrame count] < indexPath.row)? nil :_allMessageFrame[indexPath.row];
  return cell;
}
@end
