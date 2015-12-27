//
//  PersonalHeaderCell.h
//  Hello
//
//  Created by Derek Chou on 2015/12/25.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"
#import "HCSStarRatingView.h"

@interface PersonalHeaderCell : UITableViewCell

@property IBOutlet CircleButton *photoButton;
@property IBOutlet HCSStarRatingView *scoreRating;
@property IBOutlet UILabel *reviewCount;
@property IBOutlet UIImageView *gender;
@property IBOutlet UILabel *name;
@property IBOutlet UILabel *age;
@property IBOutlet UILabel *job;
@property IBOutlet UILabel *lang;
@property IBOutlet UITextView *desc;


@end
