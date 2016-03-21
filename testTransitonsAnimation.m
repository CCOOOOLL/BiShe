//
//  testTransitonsAnimation.m
//  BiShe
//
//  Created by Jz on 16/3/17.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "testTransitonsAnimation.h"
#import "JZTopBookCollectionViewCell.h"
#import "JZBookCollectionViewController.h"
#import "JZBasicBookViewController.h"

@implementation testTransitonsAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.75f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    JZBookCollectionViewController *formVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    JZBasicBookViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    JZTopBookCollectionViewCell *cell = (JZTopBookCollectionViewCell *)[formVc.collectionView cellForItemAtIndexPath:formVc.selectIndexPath];
    UIView * tempVIew = [cell.imageVIew snapshotViewAfterScreenUpdates:NO];

    UIView *contentView = [transitionContext containerView];
    [contentView addSubview:toVc.view];
    [contentView addSubview:tempVIew];
    tempVIew.frame = [cell.imageVIew convertRect:cell.imageVIew.bounds toView:contentView];
    toVc.view.alpha = 0;
    cell.imageVIew.hidden = YES;
    toVc.bookimage.hidden = YES;
    [UIView animateWithDuration:0.75f delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:1/0.75 options:0 animations:^{
        toVc.view.alpha = 1;
        tempVIew.frame = [toVc.bookimage convertRect:toVc.bookimage.bounds toView:contentView];
    } completion:^(BOOL finished) {
        
        tempVIew.hidden = YES;
        [tempVIew removeFromSuperview];
        toVc.bookimage.hidden = NO;
        cell.imageVIew.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
    
}
@end
