//
//  JZCommentsTableViewCell.h
//  BiShe
//
//  Created by Jz on 15/12/31.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZShortCommentsStore.h"

@interface JZCommentsTableViewCell : UITableViewCell
@property(nonatomic,strong)id <CommentProtocol> data;
@end
