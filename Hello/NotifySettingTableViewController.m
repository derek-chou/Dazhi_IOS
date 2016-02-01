//
//  NotifySettingTableViewController.m
//  Hello
//
//  Created by Derek Chou on 2016/1/28.
//  Copyright © 2016年 Derek Chou. All rights reserved.
//

#import "NotifySettingTableViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Common.h"

@interface NotifySettingTableViewController ()

@end

@implementation NotifySettingTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  if ([[Common getSetting:@"Verb Notify"] isEqualToString:@"Yes"])
    [self.verbSwitch setOn:YES];
  else
    [self.verbSwitch setOn:NO];
  
  if ([[Common getSetting:@"Sound Notify"] isEqualToString:@"Yes"])
    [self.soundSwitch setOn:YES];
  else
    [self.soundSwitch setOn:NO];

  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (IBAction)switchVerbSetting:(id)sender {
  if(self.verbSwitch.on) {
    [Common setSettingForKey:@"Verb Notify" Value:@"Yes"];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  } else
    [Common setSettingForKey:@"Verb Notify" Value:@"No"];
  //AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}

-(void)vibrate{
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (IBAction)switchSoundSetting:(id)sender {
  if(self.soundSwitch.on) {
    [Common setSettingForKey:@"Sound Notify" Value:@"Yes"];
    
    SystemSoundID alertSound;
    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/alarm.caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &alertSound);
    
    AudioServicesPlaySystemSound(alertSound);
  } else
    [Common setSettingForKey:@"Sound Notify" Value:@"No"];
}

@end
