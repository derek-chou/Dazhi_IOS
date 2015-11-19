//
//  TopicViewCell.m
//  Hello
//
//  Created by Derek Chou on 2015/11/7.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "TopicViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TopicViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//確保downlad的圖片不會錯放Cell
- (void)prepareForReuse {
  [self.thumbImageView cancelImageRequestOperation];
  
  self.thumbImageView.image = nil;
}

@end
