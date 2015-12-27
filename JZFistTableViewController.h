//
//  JZFistTableViewController.h
//  BiShe
//
//  Created by Jz on 15/12/27.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
@interface JZFistTableViewController : UITableViewController
@property(nonatomic,strong)id<BookViewProtocol> bookDataModel;/**<<#text#> */

@end
