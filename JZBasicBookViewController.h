//
//  JZBasicBookViewController.h
//  BiShe
//
//  Created by Jz on 15/12/27.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
@interface JZBasicBookViewController : UIViewController
@property(nonatomic,strong)Book *bookData;/**<图书信息 */
@property(nonatomic,strong)NSString *idUrl;
@property(nonatomic,strong)NSString *imageUrl;

@end
