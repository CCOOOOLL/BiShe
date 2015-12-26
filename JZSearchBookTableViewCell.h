//
//  JZSearchBookTableViewCell.h
//  BiShe
//
//  Created by Jz on 15/12/26.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
@interface JZSearchBookTableViewCell : UITableViewCell
@property(nonatomic,strong)id<BookViewProtocol>bookDataModel ;/**<<#text#> */
@end
