//
//  PersonalCell.m
//  Hello
//
//  Created by Derek Chou on 2015/12/25.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "PersonalCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PersonalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
  [self.photoView cancelImageRequestOperation];
  
  self.photoView.image = nil;
}

@end
