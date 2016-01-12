//
//  JZUserDataViewController.h
//  BiShe
//
//  Created by Jz on 16/1/11.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZRootViewController.h"
@interface JZUserDataViewController : UITableViewController<JZDrawerControllerProtocol>
@property(nonatomic, weak) JZRootViewController *drawer;
- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController;


- (void)drawerControllerDidClose:(JZRootViewController *)drawerController;

@end
