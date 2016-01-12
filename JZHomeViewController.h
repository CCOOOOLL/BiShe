//
//  JZHomeViewController.h
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZRootViewController.h"

@interface JZHomeViewController : UIViewController<JZDrawerControllerProtocol>

@property(nonatomic, weak) JZRootViewController *drawer;

- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController;

- (void)drawerControllerDidClose:(JZRootViewController *)drawerController;
@end
