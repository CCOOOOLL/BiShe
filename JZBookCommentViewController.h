//
//  JZBookCommentViewController.h
//  BiShe
//
//  Created by Jz on 15/12/31.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JZBookCommentViewControllerhDeleage <NSObject>

- (void)CommenttableViewWihtHegiht:(CGFloat )heght;

@end
@interface JZBookCommentViewController : UITableViewController
@property(nonatomic,copy)NSString *BookID;/**<图书ID */
@property(nonatomic,strong)NSString *imageUrl;/**<<#text#> */
@property (nonatomic,weak) id <JZBookCommentViewControllerhDeleage> commentDeleage;
@end
