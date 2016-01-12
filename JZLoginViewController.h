//
//  JZLoginViewController.h
//  BiShe
//
//  Created by Jz on 16/1/2.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZRootViewController.h"
@interface JZLoginViewController : UIViewController<JZDrawerControllerProtocol>
@property(nonatomic, weak) JZRootViewController *drawer;

- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController;

- (void)drawerControllerDidClose:(JZRootViewController *)drawerController;
@end
