//
//  MsgDetailViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/11/19.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "MsgDetailCell.h"

@interface MsgDetailViewController ()

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
  tableV.allowsSelection = NO;
  tableV.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageBackground"]];
  [tableV.backgroundView setAlpha:0.2f];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  _allMessageFrame = [NSMutableArray new];
  messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
  messageField.leftViewMode = UITextFieldViewModeAlways;
  messageField.delegate = self;
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
  
  @try {
    cell.messageFrame = ([_allMessageFrame count] < indexPath.row)? nil :_allMessageFrame[indexPath.row];
  } @catch(NSException *e) {
  } @finally {
  return cell;
  }
}
@end
