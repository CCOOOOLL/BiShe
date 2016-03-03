//
//  JZUserBookListViewController.h
//  BiShe
//
//  Created by Jz on 16/1/14.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JZBook,JZComment;
@interface JZUserBookListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray<JZComment*> *bookArray;/**<<#text#> */
@end
