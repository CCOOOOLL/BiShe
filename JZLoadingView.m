//
//  JZLoadingView.m
//  BiShe
//
//  Created by Jz on 15/12/27.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZLoadingView.h"

@interface JZLoadingView ()

@property(nonatomic, strong)CAShapeLayer *loadView;
@property (nonatomic, readwrite) BOOL isAnimating;
@end

@implementation JZLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)isIsAnimating{
    if (_isAnimating) {
        _isAnimating = NO;
    }
    return _isAnimating;
}

- (CAShapeLayer *)loadView{
    if (!_loadView) {
        _loadView = [[CAShapeLayer alloc]init];
        _loadView.frame = self.bounds;
        _loadView.path =[[UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(_loadView.frame), CGRectGetMinY(_loadView.frame), 60, 60)] CGPath];
        _loadView.lineWidth =5;
        _loadView.strokeColor = [UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1].CGColor;
        _loadView.fillColor = nil;
        _loadView.strokeStart = 0;
        _loadView.strokeEnd = 0;
    }
    return _loadView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.loadView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.layer addSublayer:self.loadView];
    }
    return self;
}

- (void)startAnimation{
    if (self.isAnimating){
        return;
    }
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 4.f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    [self.loadView addAnimation:animation forKey:@"rotation"];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = timingFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1.f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = timingFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.f;
    endHeadAnimation.duration = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1.f;
    endTailAnimation.duration = 0.5f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = timingFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration:1.5f];
    [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
    animations.repeatCount = INFINITY;
    [self.loadView addAnimation:animations forKey:@"stroke"];
    self.isAnimating =YES;
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;
    
    [self.loadView removeAnimationForKey:@"stroke"];
    [self.loadView removeAnimationForKey:@"rotation"];
    self.isAnimating = false;
    
}
@end
