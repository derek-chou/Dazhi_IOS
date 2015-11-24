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
  
  _allMessageFrame = [NSMutableArray new];
  messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
  messageField.leftViewMode = UITextFieldViewModeAlways;
  messageField.delegate = self;
  
  NSString *prevDate = nil;
  for (NSDictionary *dic in self.msgAry) {
    MessageFrame *mf = [MessageFrame new];
    Message *msg = [Message new];
    [msg setFromDict:dic otherType:_otherType otherID:_otherID];
    
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
  
  //[tableV reloadData];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessageFrame.count-1 inSection:0];
  [tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  //讓scroll bar移到最底
  //if (tableV.contentSize.height > tableV.frame.size.height) {
    CGPoint offset = CGPointMake(0, tableV.contentSize.height - tableV.frame.size.height);
    [tableV setContentOffset:offset animated:NO];
    //[tableV setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
  //}
  //[tableV scrollRectToVisible:CGRectMake(0, tableV.contentSize.height - tableV.bounds.size.height, tableV.bounds.size.width, tableV.bounds.size.height) animated:YES];
  
}

- (void) addMessageWithContent:(NSString*)content datetime:(NSString*)datetime {
  static BOOL flag = YES;
  MessageFrame *mf = [MessageFrame new];
  Message *msg = [Message new];
  msg.content = content;
  msg.datetime = datetime;
  NSArray *ary = [datetime componentsSeparatedByString:@" "];
  msg.date = [ary firstObject];
  msg.time = [ary lastObject];
  msg.time = [msg.time substringToIndex:5];
  msg.icon = @"Car";
  msg.type = (flag) ? FROM_ME : FROM_OTHER;
  flag = !flag;
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  NSString *content = textField.text;
  if ([content isEqual:@""]) {
    return YES;
  }
  NSDateFormatter *fmt = [NSDateFormatter new];
  NSDate *date = [NSDate date];
  fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
  NSString *time = [fmt stringFromDate:date];
  [self addMessageWithContent:content datetime:time];
  [tableV reloadData];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessageFrame.count - 1 inSection:0];
  [tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  messageField.text = nil;
  return YES;
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
