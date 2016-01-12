//
//  JZRootViewController.m
//  BiShe
//
//  Created by Jz on 16/1/10.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZRootViewController.h"
#import "JZRootCententView.h"
static const CGFloat JZDrawerControllerDrawerDepth = 260.0f;
static const CGFloat JZDrawerControllerLeftViewInitialOffset = -60.0f;
static const NSTimeInterval JZDrawerControllerAnimationDuration = 0.5;
static const CGFloat JZDrawerControllerOpeningAnimationSpringDamping = 0.7f;
static const CGFloat JZDrawerControllerOpeningAnimationSpringInitialVelocity = 0.1f;
static const CGFloat JZDrawerControllerClosingAnimationSpringDamping = 1.0f;
static const CGFloat JZDrawerControllerClosingAnimationSpringInitialVelocity = 0.5f;


typedef NS_ENUM(NSUInteger, JZDrawerControllerState)
{
    JZDrawerControllerStateClosed = 0,
    JZDrawerControllerStateOpening,
    JZDrawerControllerStateOpen,
    JZDrawerControllerStateClosing
};

@interface JZRootViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIViewController<JZDrawerControllerProtocol> *leftViewController;
@property (nonatomic,strong)UIViewController<JZDrawerControllerProtocol> *centerViewController;
//@property (nonatomic,strong)NSArray *childViewControllers;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)JZRootCententView *centerView;

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, assign) CGPoint panGestureStartLocation;
@property(nonatomic, assign) JZDrawerControllerState drawerState;
@end

@implementation JZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JZDrawerViewController"];
    self.leftViewController.drawer = self;
    self.centerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"JZHomeViewController"];
    self.centerViewController.drawer = self;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Initialize left and center view containers
    self.leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.centerView = [[JZRootCententView alloc] initWithFrame:self.view.bounds];
    self.leftView.autoresizingMask = self.view.autoresizingMask;
    self.centerView.autoresizingMask = self.view.autoresizingMask;
    
    // Add the center view container
    [self.view addSubview:self.centerView];
    
    // Add the center view controller to the container
    [self addCenterViewController];
    
    [self setupGestureRecognizers];
}

- (void)setupGestureRecognizers
{
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    self.panGestureRecognizer.delegate = self;
//    [self cententViewAddGestureRecognizer];
    
}

-(void)cententViewAddGestureRecognizer{
    [self.centerView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)addGestureRecognizerWithView:(UIView *)view{
    [view addGestureRecognizer:self.panGestureRecognizer];
}
- (void)removeGestureRecognizerWithView:(UIView *)view{
    [view removeGestureRecognizer:self.panGestureRecognizer];
}
-(void)cententViewRemoveGestureRecognizer{
    [self.centerView removeGestureRecognizer:self.panGestureRecognizer];
}

- (void)addCenterViewController
{

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.centerViewController];
    [self addChildViewController:nav];
    self.centerViewController.view.frame = self.view.bounds;
    [self.centerView addSubview:nav.view];
    [self.centerViewController didMoveToParentViewController:self];
}
#pragma mark Tap and Pan to close the drawer
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self close];
    }
}
- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
    
    
    UIGestureRecognizerState state = panGestureRecognizer.state;
    CGPoint location = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
            self.panGestureStartLocation = location;
            if (self.drawerState == JZDrawerControllerStateClosed) {
                [self willOpen];
            }
            else {
                [self willClose];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat delta = 0.0f;
            if (self.drawerState == JZDrawerControllerStateOpening) {
                delta = location.x - self.panGestureStartLocation.x;
            }
            else if (self.drawerState == JZDrawerControllerStateClosing) {
                delta = JZDrawerControllerDrawerDepth - (self.panGestureStartLocation.x - location.x);
            }
            
            CGRect l = self.leftView.frame;
            CGRect c = self.centerView.frame;
            if (delta > JZDrawerControllerDrawerDepth) {
                l.origin.x = 0.0f;
                c.origin.x = JZDrawerControllerDrawerDepth;
            }
            else if (delta < 0.0f) {
                l.origin.x = JZDrawerControllerLeftViewInitialOffset;
                c.origin.x = 0.0f;
            }
            else {
                l.origin.x = JZDrawerControllerLeftViewInitialOffset- (delta * JZDrawerControllerLeftViewInitialOffset) / JZDrawerControllerDrawerDepth;
                
                c.origin.x = delta;
            }
            
            self.leftView.frame = l;
            self.centerView.frame = c;
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            
            if (self.drawerState == JZDrawerControllerStateOpening) {
                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (centerViewLocation == JZDrawerControllerDrawerDepth) {
                    // Open the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didOpen];
                }
                else if (centerViewLocation > self.view.bounds.size.width / 3
                         && velocity.x > 0.0f) {
                    // Animate the drawer opening
                    [self animateOpening];
                }
                else {
                    // Animate the drawer closing, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didOpen];
                    [self willClose];
                    [self animateClosing];
                }
                
            } else if (self.drawerState == JZDrawerControllerStateClosing) {
                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (centerViewLocation == 0.0f) {
                    // Close the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didClose];
                }
                else if (centerViewLocation < (2 * self.view.bounds.size.width) / 3
                         && velocity.x < 0.0f) {
                    // Animate the drawer closing
                    [self animateClosing];
                }
                else {
                    // Animate the drawer opening, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didClose];
                    
                    // Here we save the current position for the leftView since
                    // we want the opening animation to start from the current position
                    // and not the one that is set in 'willOpen'
                    CGRect l = self.leftView.frame;
                    [self willOpen];
                    self.leftView.frame = l;
                    
                    [self animateOpening];
                }
            }
            break;
            
        default:
            break;
    }
}
#pragma mark Opening animation
- (void)animateOpening
{
 
    
    // Calculate the final frames for the container views
    CGRect leftViewFinalFrame = self.view.bounds;
    CGRect centerViewFinalFrame = self.view.bounds;
    centerViewFinalFrame.origin.x = JZDrawerControllerDrawerDepth;
    
    [UIView animateWithDuration:JZDrawerControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:JZDrawerControllerOpeningAnimationSpringDamping
          initialSpringVelocity:JZDrawerControllerOpeningAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.centerView.frame = centerViewFinalFrame;
                         self.leftView.frame = leftViewFinalFrame;
                         
                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self didOpen];
                         }
                     }];
}
#pragma mark Closing animation
- (void)animateClosing
{
    
    // Calculate final frames for the container views
    CGRect leftViewFinalFrame = self.leftView.frame;
    leftViewFinalFrame.origin.x = JZDrawerControllerLeftViewInitialOffset;
    CGRect centerViewFinalFrame = self.view.bounds;
    
    [UIView animateWithDuration:JZDrawerControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:JZDrawerControllerClosingAnimationSpringDamping
          initialSpringVelocity:JZDrawerControllerClosingAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.centerView.frame = centerViewFinalFrame;
                         self.leftView.frame = leftViewFinalFrame;
                         
                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self didClose];
                         }
                     }];
}

#pragma mark - Opening the drawer

- (void)open
{

    
    [self willOpen];
    
    [self animateOpening];
}

- (void)willOpen
{

    
    // Keep track that the drawer is opening
    self.drawerState = JZDrawerControllerStateOpening;
    
    // Position the left view
    CGRect f = self.view.bounds;
    f.origin.x = JZDrawerControllerLeftViewInitialOffset;
    self.leftView.frame = f;
    
    // Start adding the left view controller to the container
    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = self.leftView.bounds;
    [self.leftView addSubview:self.leftViewController.view];
    
    // Add the left view to the view hierarchy
    [self.view insertSubview:self.leftView belowSubview:self.centerView];
    
    // Notify the child view controllers that the drawer is about to open
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerWillOpen:)]) {
        [self.leftViewController drawerControllerWillOpen:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerWillOpen:)]) {
        [self.centerViewController drawerControllerWillOpen:self];
    }
}

- (void)didOpen
{
    NSParameterAssert(self.drawerState == JZDrawerControllerStateOpening);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);
    
    // Complete adding the left controller to the container
    [self.leftViewController didMoveToParentViewController:self];
    
    [self.centerView addGestureRecognizer:self.tapGestureRecognizer];
    
    // Keep track that the drawer is open
    self.drawerState = JZDrawerControllerStateOpen;
    
    // Notify the child view controllers that the drawer is open
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerDidOpen:)]) {
        [self.leftViewController drawerControllerDidOpen:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerDidOpen:)]) {
        [self.centerViewController drawerControllerDidOpen:self];
    }
}

#pragma mark - Closing the drawer

- (void)close
{
    
    [self willClose];
    
    [self animateClosing];
}

- (void)willClose
{

    
    // Start removing the left controller from the container
    [self.leftViewController willMoveToParentViewController:nil];
    
    // Keep track that the drawer is closing
    self.drawerState = JZDrawerControllerStateClosing;
    
    // Notify the child view controllers that the drawer is about to close
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerWillClose:)]) {
        [self.leftViewController drawerControllerWillClose:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerWillClose:)]) {
        [self.centerViewController drawerControllerWillClose:self];
    }
}

- (void)didClose
{

    
    // Complete removing the left view controller from the container
    [self.leftViewController.view removeFromSuperview];
    [self.leftViewController removeFromParentViewController];
    
    // Remove the left view from the view hierarchy
    [self.leftView removeFromSuperview];
    
    [self.centerView removeGestureRecognizer:self.tapGestureRecognizer];
    
    // Keep track that the drawer is closed
    self.drawerState = JZDrawerControllerStateClosed;
    
    // Notify the child view controllers that the drawer is closed
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerDidClose:)]) {
        [self.leftViewController drawerControllerDidClose:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerDidClose:)]) {
        [self.centerViewController drawerControllerDidClose:self];
    }
}

#pragma mark - Reloading/Replacing the center view controller

- (void)reloadCenterViewControllerUsingBlock:(void (^)(void))reloadBlock
{

    
    [self willClose];
    
    CGRect f = self.centerView.frame;
    f.origin.x = self.view.bounds.size.width;
    
    [UIView animateWithDuration: JZDrawerControllerAnimationDuration / 2
                     animations:^{
                         self.centerView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // The center view controller is now out of sight
                             if (reloadBlock) {
                                 reloadBlock();
                             }
                             // Finally, close the drawer
                             [self animateClosing];
                         }
                     }];
}

- (void)replaceCenterViewControllerWithViewController:(UIViewController<JZDrawerControllerProtocol> *)viewController
{

    
    [self willClose];
    
    CGRect f = self.centerView.frame;
    f.origin.x = self.view.bounds.size.width;
    
    [self.centerViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration: JZDrawerControllerAnimationDuration / 2
                     animations:^{
                         self.centerView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // The center view controller is now out of sight
                             
                             // Remove the current center view controller from the container
                             if ([self.centerViewController respondsToSelector:@selector(setDrawer:)]) {
                                 self.centerViewController.drawer = nil;
                             }
                             [self.centerViewController.view removeFromSuperview];
                             [self.centerViewController removeFromParentViewController];
                             
                             // Set the new center view controller
                             self.centerViewController = viewController;
                             if ([self.centerViewController respondsToSelector:@selector(setDrawer:)]) {
                                 self.centerViewController.drawer = self;
                             }
                             
                             // Add the new center view controller to the container
                             [self addCenterViewController];
                             
                             // Finally, close the drawer
                             [self animateClosing];
                         }
                     }];
}
@end
