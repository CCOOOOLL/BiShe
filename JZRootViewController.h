//
//  JZRootViewController.h
//  BiShe
//
//  Created by Jz on 16/1/10.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZRootViewController;





@protocol  JZDrawerControllerProtocol  <NSObject>

@property(nonatomic, weak) JZRootViewController *drawer;

@optional

- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController;

- (void)drawerControllerDidOpen:(JZRootViewController *)drawerController;

- (void)drawerControllerWillClose:(JZRootViewController *)drawerController;

- (void)drawerControllerDidClose:(JZRootViewController *)drawerController;

@end

@interface JZRootViewController : UIViewController
@property (nonatomic,strong,readonly)UIViewController<JZDrawerControllerProtocol> *leftViewController;
@property (nonatomic,strong,readonly)UIViewController<JZDrawerControllerProtocol> *centerViewController;

- (void)removeGestureRecognizerWithView:(UIView *)view;
- (void)addGestureRecognizerWithView:(UIView *)view;
-(void)cententViewAddGestureRecognizer;
-(void)cententViewRemoveGestureRecognizer;
- (void)open;
- (void)close;
- (void)replaceCenterViewControllerWithViewController:(UIViewController<JZDrawerControllerProtocol> *)viewController;
@end