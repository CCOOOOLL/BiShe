//
//  JZDrawerViewController.h
//  BiShe
//
//  Created by Jz on 16/1/11.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZRootViewController.h"
@interface JZDrawerViewController : UIViewController<JZDrawerControllerProtocol>


@property(nonatomic, weak) JZRootViewController *drawer;
@end
