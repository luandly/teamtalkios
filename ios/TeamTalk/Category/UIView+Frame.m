//
//  UIView+Frame.m
//  微博
//
//  Created by tianzhihong on 16/10/11.
//  Copyright (c) Copyright © 2016年 北京海尔广科数字技术有限公司. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)x
{

    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{

    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}
- (CGFloat)y
{

    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{

    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}

- (CGFloat)width
{

    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{

    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (CGFloat)height
{

    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{

    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (CGFloat)centerX
{

    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{

    CGPoint tempCenter = self.center;
    tempCenter.x = centerX;
    self.center = tempCenter;
}

- (CGFloat)centerY
{

    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{

    CGPoint tempCenter = self.center;
    tempCenter.y = centerY;
    self.center = tempCenter;
}

- (CGSize)size
{

    return self.frame.size;
}

- (void)setSize:(CGSize)size
{

    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

@end
