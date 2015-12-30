//
//  JZShortCommentsTableViewCell.h
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZShortCommentsStore.h"

@interface JZShortCommentsTableViewCell : UITableViewCell

@property(nonatomic,strong)id <CommentProtocol> data;/**<<#text#> */

@end
