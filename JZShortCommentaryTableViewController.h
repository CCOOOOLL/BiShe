//
//  JZShortCommentaryTableViewController.h
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZShortCommentaryTableViewControllerDeleage <NSObject>

- (void)tableViewWihtHegiht:(CGFloat )heght;

@end

@interface JZShortCommentaryTableViewController : UITableViewController

@property(nonatomic,copy)NSString *BookID;/**<图书ID */
@property (nonatomic,weak) id <JZShortCommentaryTableViewControllerDeleage> commentDeleage;
@end
