//
//  CircleButton.m
//  Hello
//
//  Created by Derek Chou on 2015/11/11.
//  Copyright © 2015年 Derek Chou. All rights reserved.
//

#import "CircleButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CircleButton

- (void)drawCircleButton:(UIColor *)color
{
  self.color = color;
  
  [self setTitleColor:color forState:UIControlStateNormal];
  
  self.circleLayer = [CAShapeLayer layer];
  
  [self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width,
                                         [self bounds].size.height)];
  [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]),CGRectGetMidY([self bounds]))];
  
  UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
  
  [self.circleLayer setPath:[path CGPath]];
  
  [self.circleLayer setStrokeColor:[color CGColor]];
  
  [self.circleLayer setLineWidth:5.0f];
  [self.circleLayer setFillColor:[[UIColor clearColor] CGColor]];

  
  [[self layer] addSublayer:self.circleLayer];
  self.clipsToBounds = YES;
  self.layer.cornerRadius = (self.bounds.size.height/2);
}

//- (void)setHighlighted:(BOOL)highlighted
//{
//  if (highlighted)
//  {
//    self.titleLabel.textColor = [UIColor whiteColor];
//    [self.circleLayer setFillColor:self.color.CGColor];
//  }
//  else
//  {
//    [self.circleLayer setFillColor:[UIColor clearColor].CGColor];
//    self.titleLabel.textColor = self.color;
//  }
//}

@end
