//
//  UIScrollView+JZ.m
//  BiShe
//
//  Created by Jz on 16/1/11.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "UIScrollView+JZ.h"

@implementation UIScrollView (JZ)
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([self isMemberOfClass:[UIScrollView class]]){
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        CGPoint location = [gestureRecognizer locationInView:self];
        if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width<60) {
            return NO;
        }
    }

    return YES;
}
@end
