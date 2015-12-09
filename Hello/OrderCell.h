//
//  OrderCell.h
//  Hello
//
//  Created by Derek Chou on 2015/12/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"

@interface OrderCell : UITableViewCell
@property IBOutlet UILabel *userNameLabel;
@property IBOutlet UILabel *productTitleLabel;
@property IBOutlet UILabel *productPriceLabel;
@property IBOutlet UILabel *travelDateLabel;
@property IBOutlet CircleButton *photoButton;
@property IBOutlet UIImageView *statImage;

@end
