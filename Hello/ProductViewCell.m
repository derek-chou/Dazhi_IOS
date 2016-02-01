//
//  ProductViewCell.m
//  Hello
//
//  Created by Derek Chou on 2015/11/11.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "ProductViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ProductViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (BOOL)isAccessibilityElement{
//  return YES;
//}

//確保downlad的圖片不會錯放Cell
- (void)prepareForReuse {
  [self.productImage cancelImageRequestOperation];
  self.productImage.image = nil;
  
//  [self.photoButton.imageView cancelImageRequestOperation];
//  [self.photoButton setImage:[UIImage imageNamed:@"top5_a1"] forState:UIControlStateNormal];
}

@end
