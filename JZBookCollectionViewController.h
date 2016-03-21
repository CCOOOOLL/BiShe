//
//  JZBookCollectionViewController.h
//  BiShe
//
//  Created by Jz on 15/12/26.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZBookCollectionViewController : UICollectionViewController<UINavigationControllerDelegate>

@property(nonatomic,strong)NSDictionary *contentData; /**< 内容数据 */
@property(nonatomic,strong)NSIndexPath *selectIndexPath;/**<<#text#> */
@end
