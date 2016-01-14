//
//  JZUserBookListViewController.h
//  BiShe
//
//  Created by Jz on 16/1/14.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZBook;
@interface JZUserBookListViewController : UIViewController<UITabBarControllerDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray<JZBook*> *bookArray;/**<<#text#> */
@end
