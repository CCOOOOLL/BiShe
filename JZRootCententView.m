//
//  JZRootCententView.m
//  BiShe
//
//  Created by Jz on 16/1/10.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZRootCententView.h"

@implementation JZRootCententView

- (void)drawRect:(CGRect)rect
{
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.7f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = shadowPath.CGPath;
}
@end
