//
//  PersonalSettingViewController.m
//  Hello
//
//  Created by Derek Chou on 2015/12/29.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "User.h"
#import "Common.h"

@interface PersonalSettingViewController ()

@end

static NSString *cityPlaceholder = @"請選擇您的所在城市...";
@implementation PersonalSettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.scrollView.delegate = self;
  self.langTextField.delegate = self;

  NSMutableArray* bandArray = [[NSMutableArray alloc] init];
  [bandArray addObject:@"台灣 台北"];
  [bandArray addObject:@"日本 東京"];
  [bandArray addObject:@"美國 華盛頓"];
  [self.cityPicker setPlaceholder:cityPlaceholder];
  self.cityPicker = [[DownPicker alloc] initWithTextField:self.cityTextField withData:bandArray];
  [self.cityPicker addTarget:self
                      action:@selector(citySelected:)
            forControlEvents:UIControlEventValueChanged];
  
  self.langDescArray = [[NSMutableArray alloc] initWithArray:@[@"中文", @"英文", @"日文"]];
  self.langSelected = [NSMutableIndexSet new];
  [_langSelected addIndex:0];
  [_langSelected addIndex:1];
  NSMutableArray *tmpAry = [NSMutableArray new];
  [_langSelected enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [tmpAry addObject:_langDescArray[idx]];
  }];
  
  self.langTextField.text = [tmpAry componentsJoinedByString:@","];
  
  NSString *userType = [Common getSetting:@"User Type"];
  NSString *userID = [Common getSetting:@"User ID"];
  User *user = [User getByType:userType AndID:userID];
  self.nameTextField.text = user.name;
  //self.birtydayTextField.text

  //取得使用者頭像
  NSString *photoURL = [Common getPhotoURLByType:userType AndID:userID];
  NSString *photoFileName = [[photoURL componentsSeparatedByString:@"//"] lastObject];
  photoFileName = [photoFileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
  NSString *photoFullName = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), photoFileName];
  //check img exist
  BOOL photoExist = [[NSFileManager defaultManager] fileExistsAtPath:photoFullName];
  if(!photoExist){
    [Common downloadImage:photoURL To:self.photoImage Cell:nil SavePath:photoFullName];
  } else {
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:photoFullName];
    self.photoImage.image = img;
  }
  
  
  UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)];
  [self.scrollView addGestureRecognizer:tapScrollView];
}

- (void) viewWillAppear:(BOOL)animated {
  [self.cityPicker setPlaceholder:cityPlaceholder];
}

-(void)tapScrollView{
  NSLog(@"single Tap on scrollView");
  
  [self.nameTextField resignFirstResponder];
  [self.birtydayTextField resignFirstResponder];
}


-(void)citySelected:(id)dp {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

//不能左右scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView.contentOffset.x != 0) {
    CGPoint offset = scrollView.contentOffset;
    offset.x = 0;
    scrollView.contentOffset = offset;
  }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if (textField == self.langTextField) {
    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;
    
    CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
    
    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"請選擇您使用的語言" list:_langDescArray
                                                       selectedIndexes:self.langSelected point:point size:size multipleSelection:YES disableBackgroundInteraction:YES];
    listView.delegate = self;
    
    [listView showInView:self.navigationController.view animated:YES];
    return NO;
  }
  
  return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
}

- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index
{
  NSLog(@"popUpListView - didSelectIndex: %d", index);
}

- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedIndexes:(NSMutableIndexSet *)selectedIndexes
{
  NSLog(@"popupListViewDidHide - selectedIndexes: %@", selectedIndexes.description);
  
  NSMutableArray *tmpAry = [NSMutableArray new];
  _langSelected = selectedIndexes;
  [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [tmpAry addObject:_langDescArray[idx]];
    //[_langSelected addIndex:idx];
  }];
  
  _langTextField.text = [tmpAry componentsJoinedByString:@","];
}


@end
