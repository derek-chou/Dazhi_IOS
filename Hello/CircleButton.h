//
//  CircleButton.h
//  Hello
//
//  Created by Derek Chou on 2015/11/11.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleButton : UIButton

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UIColor *color;
- (void)drawCircleButton:(UIColor *)color;

@end
