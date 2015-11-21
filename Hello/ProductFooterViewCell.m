//
//  ProductFooterViewCell.m
//  Hello
//
//  Created by Derek Chou on 2015/11/11.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "ProductFooterViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ProductFooterViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
  [super layoutSubviews];
  
  //CGRect btFrame = _photoButton.frame;
  //btFrame.origin.x = 90;
  //btFrame.origin.y -= 200;
  //_photoButton.frame = btFrame;
}

//確保downlad的圖片不會錯放Cell
- (void)prepareForReuse {  
//  [self.photoButton.imageView cancelImageRequestOperation];
//  [self.photoButton setImage:[UIImage imageNamed:@"top5_a1"] forState:UIControlStateNormal];
}


@end
