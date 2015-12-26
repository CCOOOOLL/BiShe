//
//  JZBookView.h
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
IB_DESIGNABLE
@interface JZBookView : UIView
@property (nonatomic,strong) id<BookViewProtocol> Model;
@end
