//
//  FavoriteViewCell.m
//  Hello
//
//  Created by Derek Chou on 2015/11/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "FavoriteViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FavoriteViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//確保downlad的圖片不會錯放Cell
- (void)prepareForReuse {
    [self.photoButton.imageView cancelImageRequestOperation];
    [self.photoButton setImage:[UIImage imageNamed:@"top5_a1"] forState:UIControlStateNormal];
}

@end
