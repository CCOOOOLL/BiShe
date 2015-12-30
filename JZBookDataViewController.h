//
//  JZBookDataViewController.h
//  BiShe
//
//  Created by Jz on 15/12/29.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
@interface JZBookDataViewController : UIViewController
@property(nonatomic,strong)id<BookViewProtocol> bookData;/**<数据 */
@end
