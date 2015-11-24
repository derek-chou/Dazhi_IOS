//
//  FavoriteViewCell.h
//  Hello
//
//  Created by Derek Chou on 2015/11/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"

@interface FavoriteViewCell : UITableViewCell

@property IBOutlet UILabel *nameLabel;
@property IBOutlet CircleButton *photoButton;
@property IBOutlet UIImageView *star1Image;
@property IBOutlet UIImageView *star2Image;
@property IBOutlet UIImageView *star3Image;
@property IBOutlet UIImageView *star4Image;
@property IBOutlet UIImageView *star5Image;
@property IBOutlet UILabel *scoreCountLabel;
@property IBOutlet UIImageView *genderImage;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *jobLabel;
@property IBOutlet UILabel *langLabel;

@end
