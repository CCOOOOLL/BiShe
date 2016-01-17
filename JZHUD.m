//
//  JZHUD.m
//  JZHUD
//
//  Created by Jz on 16/1/16.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZHUD.h"

#define color(r,g,b) colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1
#define HUDBounds self.bounds
static CGFloat const HUDLineWith = 3;
//static NSInteger const HUD
@interface JZHUD ()

@property(nonatomic, strong)CAShapeLayer *superstratumRoundLayer;/**< 上层圆形 */
@property(nonatomic, strong)CAShapeLayer *underRoundLayer;/**< 底层圆形 */
@property(nonatomic, strong)CAShapeLayer *successLayer;/**< 成功视图 */

@property(nonatomic, strong)CAShapeLayer *failLayer;/**< 失败 */
@property(nonatomic, strong)UIColor *HUDColor;
@property(nonatomic,strong)UILabel *titleLabel;/**< */

@end


@implementation JZHUD


#pragma mark 懒加载

- (UIColor *)HUDColor{
    if (!_HUDColor) {
        _HUDColor = [UIColor color(52,179,64)];
    }
    return _HUDColor;
}

- (CAShapeLayer *)superstratumRoundLayer{

    if (!_superstratumRoundLayer) {
//        UIBezierPath* superstratumRoundPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0,0, 35, 35)];
     UIBezierPath* superstratumRoundPath =  [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, floor(CGRectGetWidth(HUDBounds) * 0.79167) - floor(CGRectGetWidth(HUDBounds) * 0.20833), floor(CGRectGetHeight(HUDBounds) * 0.79167) - floor(CGRectGetHeight(HUDBounds) * 0.20833))];
        _superstratumRoundLayer = [[CAShapeLayer alloc]init];
        _superstratumRoundLayer.path = superstratumRoundPath.CGPath;

        _superstratumRoundLayer.lineWidth = HUDLineWith;
        _superstratumRoundLayer.strokeColor = self.HUDColor.CGColor;
         _superstratumRoundLayer.strokeEnd = 0.8;

        _superstratumRoundLayer.fillColor = nil;
        _superstratumRoundLayer.frame = CGRectMake(CGRectGetMinX(HUDBounds) + floor(CGRectGetWidth(HUDBounds) * 0.20833) + 0.5, CGRectGetMinY(HUDBounds) + floor(CGRectGetHeight(HUDBounds) * 0.20833) + 0.5, floor(CGRectGetWidth(HUDBounds) * 0.79167) - floor(CGRectGetWidth(HUDBounds) * 0.20833), floor(CGRectGetHeight(HUDBounds) * 0.79167) - floor(CGRectGetHeight(HUDBounds) * 0.20833));

    }
    
    return _superstratumRoundLayer;
}

- (CAShapeLayer *)underRoundLayer{
    if (!_underRoundLayer) {
       UIBezierPath* underRoundPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(HUDBounds) + floor(CGRectGetWidth(HUDBounds) * 0.20833) + 0.5, CGRectGetMinY(HUDBounds) + floor(CGRectGetHeight(HUDBounds) * 0.20833) + 0.5, floor(CGRectGetWidth(HUDBounds) * 0.79167) - floor(CGRectGetWidth(HUDBounds) * 0.20833), floor(CGRectGetHeight(HUDBounds) * 0.79167) - floor(CGRectGetHeight(HUDBounds) * 0.20833))];
        _underRoundLayer = [CAShapeLayer new];
        _underRoundLayer.path = underRoundPath.CGPath;
        _underRoundLayer.strokeColor = [UIColor whiteColor].CGColor;
        _underRoundLayer.lineWidth = HUDLineWith;
        _underRoundLayer.fillColor = nil;
       
    }
    return _underRoundLayer;
}

- (CAShapeLayer *)successLayer{
    if (!_successLayer) {
        UIBezierPath* successPath = UIBezierPath.bezierPath;
        [successPath moveToPoint: CGPointMake(CGRectGetMinX(HUDBounds) + 0.27500 * CGRectGetWidth(HUDBounds), CGRectGetMinY(HUDBounds) + 0.49722 * CGRectGetHeight(HUDBounds))];
        [successPath addLineToPoint: CGPointMake(CGRectGetMinX(HUDBounds) + 0.44167 * CGRectGetWidth(HUDBounds), CGRectGetMinY(HUDBounds) + 0.64167 * CGRectGetHeight(HUDBounds))];
        [successPath addLineToPoint: CGPointMake(CGRectGetMinX(HUDBounds) + 0.74167 * CGRectGetWidth(HUDBounds), CGRectGetMinY(HUDBounds) + 0.34167 * CGRectGetHeight(HUDBounds))];



        _successLayer = [CAShapeLayer new];

        _successLayer.path = successPath.CGPath;
        _successLayer.lineWidth = HUDLineWith;
        _successLayer.strokeColor = self.HUDColor.CGColor;
        _successLayer.strokeEnd = 0;
        _successLayer.fillColor = nil;
    }
    return _successLayer;
}


- (CAShapeLayer *)failLayer{
    if (!_failLayer) {
        UIBezierPath* failLayerPath = UIBezierPath.bezierPath;
        [failLayerPath moveToPoint: CGPointMake(CGRectGetMinX(HUDBounds) + 0.20833 * CGRectGetWidth(HUDBounds), CGRectGetMinY(HUDBounds) + 0.20833 * CGRectGetHeight(HUDBounds))];
        [failLayerPath addLineToPoint: CGPointMake(CGRectGetMinX(HUDBounds) + 0.79167 * CGRectGetWidth(HUDBounds), CGRectGetMinY(HUDBounds) + 0.79167 * CGRectGetHeight(HUDBounds))];
        [failLayerPath moveToPoint: CGPointMake(CGRectGetMinX(HUDBounds) + 0.20833 * CGRectGetWidth(HUDBounds), CGRectGetMinY(HUDBounds) + 0.79167 * CGRectGetHeight(HUDBounds))];
        [failLayerPath addLineToPoint: CGPointMake(CGRectGetMinX(HUDBounds) + 0.79167 * CGRectGetWidth(HUDBounds), CGRectGetMinY(HUDBounds) + 0.20833 * CGRectGetHeight(HUDBounds))];


        
        _failLayer = [CAShapeLayer new];
        _failLayer.lineCap = kCALineCapRound;
        _failLayer.lineWidth = HUDLineWith;
        _failLayer.strokeColor = self.HUDColor.CGColor;
        _failLayer.path = failLayerPath.CGPath;
        _failLayer.strokeEnd = 0;
    }
    return _failLayer;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        CGRect rect = self.superstratumRoundLayer.frame;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(rect),CGRectGetWidth(self.frame), CGRectGetHeight(HUDBounds)-CGRectGetMaxY(rect)-HUDLineWith)];

        _titleLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(HUDBounds)-CGRectGetMaxY(rect)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.HUDColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


+ (instancetype)shared{
    static dispatch_once_t one;
    static id hud ;
    dispatch_once(&one, ^{
        hud = [[self alloc]init];
    });
    return hud;
}

+ (void)showHUDandTitle:(NSString *)title{
    JZHUD *hud = [self shared];
    hud.titleLabel.text = title;
    [hud LoadAnimation];
    
}

+ (void)showSuccessandTitle:(NSString *)title{
    JZHUD *hud = [self shared];
    hud.titleLabel.text = title;
    [hud successAnimation];

}

+ (void)showFailandTitle:(NSString *)title{
    JZHUD *hud = [self shared];
    hud.titleLabel.text = title;
    [hud failAnimation];

}

+(void)dismissHUD{
    [[self shared]hideHUD];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self hudCreate];
    }
    return self;
}



- (void)hudCreate{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGPoint point = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    rect.size = CGSizeMake(rect.size.width/3.0,rect.size.width/3.0);
    self.frame = rect;
    self.center = point;
    [self.layer addSublayer:self.underRoundLayer];
    [self.layer addSublayer:self.superstratumRoundLayer];
    [self.layer addSublayer:self.successLayer];
//    [self.layer addSublayer:self.failLeftLayer];
//    [self.layer addSublayer:self.failRigthLayer];
    [self.layer addSublayer:self.failLayer];
    self.translucent = YES;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.barStyle = UIBarStyleDefault;
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    self.superstratumRoundLayer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_4, 0, 0, 1);
    NSLog(@"%@",[NSValue valueWithCGRect:self.superstratumRoundLayer.HUDBounds]);
//    self.superstratumRoundLayer.transform = CATransform3DTranslate(CATransform3DIdentity,17.5, 17.5, 0);
}

- (void)LoadAnimation{
    self.hidden = NO;
    
    CABasicAnimation *LoadAnimation = [[CABasicAnimation alloc]init];
    LoadAnimation.keyPath = @"transform.rotation";
    LoadAnimation.duration = 2;
    LoadAnimation.fromValue = @(0);
    LoadAnimation.toValue = @(2*M_PI);
    LoadAnimation.repeatCount = INFINITY;
    LoadAnimation.removedOnCompletion = NO;
//    LoadAnimation.fillMode = kCAFillModeForwards;
    [self.superstratumRoundLayer addAnimation:LoadAnimation forKey:@"LoadAnimation"];
}

- (void)successAnimation{
    self.underRoundLayer.strokeEnd = 0;

    CABasicAnimation *loadsuccessAnimation = [[CABasicAnimation alloc]init];
    loadsuccessAnimation.keyPath = @"strokeEnd";
    loadsuccessAnimation.duration = 0.25;
    loadsuccessAnimation.toValue = @(1);
    loadsuccessAnimation.removedOnCompletion = NO;
    loadsuccessAnimation.fillMode = kCAFillModeForwards;
    
    
    CABasicAnimation *loadhideAnimation = [[CABasicAnimation alloc]init];
    loadhideAnimation.keyPath = @"opacity";
    loadhideAnimation.duration = 1;
    loadhideAnimation.toValue = @(0);
    loadhideAnimation.removedOnCompletion = NO;
    loadhideAnimation.fillMode = kCAFillModeForwards;

    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.animations = @[loadsuccessAnimation,loadhideAnimation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = 1;
    [self.superstratumRoundLayer addAnimation:group forKey:@"loadEndAnimationGroup"];
    
    
    CABasicAnimation *successAnimation = [[CABasicAnimation alloc]init];
    successAnimation.keyPath = @"strokeEnd";
    successAnimation.toValue = @(1);
    successAnimation.duration = 1;
    successAnimation.beginTime =0.25 + CACurrentMediaTime();
    successAnimation.removedOnCompletion = NO;
    successAnimation.fillMode = kCAFillModeForwards;
    [self.successLayer addAnimation:successAnimation forKey:@"successAnimation"];
    [UIView animateWithDuration:0.5 delay:1.25 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
        self.superstratumRoundLayer.strokeEnd =0.8;
        self.underRoundLayer.strokeEnd = 1;
        [self.layer removeAllAnimations];
        [self.superstratumRoundLayer removeAllAnimations];
        [self.successLayer removeAllAnimations];
    }];

    
}

- (void)failAnimation{
    self.underRoundLayer.strokeEnd = 0;
    CABasicAnimation *LoadFailAnimation = [[CABasicAnimation alloc]init];
    LoadFailAnimation.keyPath = @"strokeEnd";
    LoadFailAnimation.duration = 0.5;
    LoadFailAnimation.toValue = @(0);
    LoadFailAnimation.removedOnCompletion = NO;
    LoadFailAnimation.fillMode = kCAFillModeForwards;
    [self.superstratumRoundLayer addAnimation:LoadFailAnimation forKey:@"loadEndAnimation"];
    
    CABasicAnimation *failAnimation = [[CABasicAnimation alloc]init];
    //    _successLayer.strokeEnd
    failAnimation.keyPath = @"strokeEnd";
    failAnimation.toValue = @(1);
    failAnimation.duration = 1;
    failAnimation.beginTime =0.5 + CACurrentMediaTime();
    failAnimation.removedOnCompletion = NO;
    failAnimation.fillMode = kCAFillModeForwards;
    [self.failLayer addAnimation:failAnimation forKey:@"failAnimation"];
    [UIView animateWithDuration:0.5 delay:2.5 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
        self.superstratumRoundLayer.strokeEnd = 0.8;
        self.failLayer.strokeEnd = 0;
        self.underRoundLayer.strokeEnd = 1;
//        [self.layer removeAllAnimations];
        [self.failLayer removeAllAnimations];
        [self.superstratumRoundLayer removeAllAnimations];
    }];
}

- (void)hideHUD{
    self.hidden = YES;
    self.alpha = 1;
    self.superstratumRoundLayer.strokeEnd = 0.8;
    self.failLayer.strokeEnd = 0;
    self.underRoundLayer.strokeEnd = 1;
    //        [self.layer removeAllAnimations];
    [self.failLayer removeAllAnimations];
    [self.superstratumRoundLayer removeAllAnimations];
    [self.successLayer removeAllAnimations];
}


@end
