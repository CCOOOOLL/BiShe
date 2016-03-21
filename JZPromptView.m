//
//  JZPromptView.m
//  BiShe
//
//  Created by Jz on 16/1/12.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZPromptView.h"

typedef NS_ENUM(NSUInteger, JZPromptAnimateState){
    JZPromptAnimateStatedidHide = 0,
    JZPromptAnimateStateWillDrop,
    JZPromptAnimateStateDidDrop,
    JZPromptAnimateStateWillHide
    
};
@interface JZPromptView ()
@property (nonatomic, assign)JZPromptAnimateState AnimateState;
@property (nonatomic,strong)CAAnimationGroup *drop;
@property (nonatomic,strong)CAAnimationGroup *hide;

@end

@implementation JZPromptView

+ (instancetype)prompt{
    JZPromptView *promptView =[[self alloc]init];    
    promptView.textAlignment = NSTextAlignmentCenter;
    promptView.textColor = [UIColor whiteColor];
    promptView.backgroundColor = [UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1];

    [promptView.layer setCornerRadius:15];
    promptView.layer.masksToBounds = YES;
    return promptView;
}
- (void)setError:(NSError *)error{
    switch (error.code) {
        case -1009:
            self.text = @"无网络，请检查设置";
            break;
            
        default:
            self.text = @"无网络，请检查设置";
            break;
    }
    CGFloat labelwiht = [self.text boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+60;
    CGFloat windowWith = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = CGRectMake(windowWith/2.0-labelwiht/2.0, 0, labelwiht, 30);
    //        [self sizeToFit];
    self.frame = rect;
    

}
- (void)starShow{
    switch (self.AnimateState) {
        case JZPromptAnimateStateWillDrop:
            return;
            break;
        case JZPromptAnimateStateWillHide:
            [self hideAnimate];
            break;
        case JZPromptAnimateStatedidHide:
            [[UIApplication sharedApplication].windows.lastObject addSubview:self];
            [self dropAnimate];
        default:
        case JZPromptAnimateStateDidDrop:
            [self hideAnimate];
            break;
    }
}

- (void)dropAnimate{
   
    CAAnimationGroup *drop = [CAAnimationGroup animation];
    
    CABasicAnimation *dropY = [CABasicAnimation animationWithKeyPath:@"position.y"];
    dropY.toValue = @100.f;;
    
    CABasicAnimation *dropA = [CABasicAnimation animationWithKeyPath:@"opacity"];
    dropA.toValue = @1;
    drop.animations = @[dropY,dropA];
    drop.duration = 1.f;
    drop.fillMode = kCAFillModeForwards;
    drop.delegate = self;
    drop.removedOnCompletion = NO;
    [self.layer addAnimation:drop forKey:@"drop"];
    


}

- (void)hideAnimate{

    CAAnimationGroup *hide = [CAAnimationGroup animation];
    
    CABasicAnimation *hideY = [CABasicAnimation animationWithKeyPath:@"position.y"];
    hideY.fromValue = @100.f;
    hideY.toValue = @0.f;
    hideY.fillMode=kCAFillModeForwards;
    
    CABasicAnimation *hideA = [CABasicAnimation animationWithKeyPath:@"opacity"];
    hideA.fromValue = @1;
    hideA.toValue = @0;

    hide.animations = @[hideY,hideA];
    hide.fillMode=kCAFillModeForwards;
    hide.duration = 0.5f;
    hide.beginTime = 2 +CACurrentMediaTime();
    hide.delegate = self;
    hide.fillMode=kCAFillModeForwards;
    hide.removedOnCompletion = NO;
    [self.layer addAnimation:hide forKey:@"hide"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

        if (self.AnimateState==JZPromptAnimateStateWillDrop) {
            self.AnimateState = JZPromptAnimateStateDidDrop;
            [self hideAnimate];
        }else if (self.AnimateState == JZPromptAnimateStateWillHide){
            self.AnimateState = JZPromptAnimateStatedidHide;
            [self removeFromSuperview];
        }

}
- (void)animationDidStart:(CAAnimation *)anim{

    if (anim == [self.layer animationForKey:@"drop"]) {
        self.AnimateState = JZPromptAnimateStateWillDrop;
    }else if(anim == [self.layer animationForKey:@"hide"]){
        self.AnimateState = JZPromptAnimateStateWillHide;
    }

}
@end
