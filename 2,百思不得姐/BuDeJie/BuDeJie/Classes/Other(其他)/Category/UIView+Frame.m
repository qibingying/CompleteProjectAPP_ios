//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/9.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setQby_height:(CGFloat)qby_height
{
    CGRect rect = self.frame;
    rect.size.height = qby_height;
    self.frame = rect;
}

- (CGFloat)qby_height
{
    return self.frame.size.height;
}

- (CGFloat)qby_width
{
    return self.frame.size.width;
}
- (void)setQby_width:(CGFloat)qby_width
{
    CGRect rect = self.frame;
    rect.size.width = qby_width;
    self.frame = rect;
}

- (CGFloat)qby_x
{
    return self.frame.origin.x;
    
}

- (void)setQby_x:(CGFloat)qby_x
{
    CGRect rect = self.frame;
    rect.origin.x = qby_x;
    self.frame = rect;
}

- (void)setQby_y:(CGFloat)qby_y
{
    CGRect rect = self.frame;
    rect.origin.y = qby_y;
    self.frame = rect;
}

- (CGFloat)qby_y
{
    
    return self.frame.origin.y;
}

- (void)setQby_centerX:(CGFloat)qby_centerX
{
    CGPoint center = self.center;
    center.x = qby_centerX;
    self.center = center;
}

- (CGFloat)qby_centerX
{
    return self.center.x;
}

- (void)setQby_centerY:(CGFloat)qby_centerY
{
    CGPoint center = self.center;
    center.y = qby_centerY;
    self.center = center;
}

- (CGFloat)qby_centerY
{
    return self.center.y;
}
@end
