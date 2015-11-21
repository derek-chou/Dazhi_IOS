//
//  ProductViewCell.h
//  Hello
//
//  Created by Derek Chou on 2015/11/11.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"

@interface ProductViewCell : UITableViewCell

@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *descLabel;
@property IBOutlet UILabel *feeLabel;
@property IBOutlet UIImageView *productImage;
@property IBOutlet UIButton *favoriteButton;
//@property IBOutletCircleButton *photoButton;
@property IBOutlet UIImageView *carImage;
@property IBOutlet UIImageView *drinkImage;
@property IBOutlet UIImageView *roomImage;
@property IBOutlet UIImageView *smokeImage;
//@property IBOutlet UIButton *photoButton;

@end
