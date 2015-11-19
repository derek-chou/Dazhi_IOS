//
//  ProductFooterViewCell.h
//  Hello
//
//  Created by Derek Chou on 2015/11/11.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"

@interface ProductFooterViewCell : UITableViewCell

@property IBOutlet UILabel *nameLabel;
@property IBOutlet UILabel *scoreCountLabel;
@property IBOutlet UIImageView *star1Image;
@property IBOutlet UIImageView *star2Image;
@property IBOutlet UIImageView *star3Image;
@property IBOutlet UIImageView *star4Image;
@property IBOutlet UIImageView *star5Image;
@property IBOutlet UIImageView *genderImage;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *jobLabel;
@property IBOutlet UILabel *langLabel;
@property IBOutlet CircleButton *photoButton;

//@property IBOutlet UIButton *photoButton;

@end
