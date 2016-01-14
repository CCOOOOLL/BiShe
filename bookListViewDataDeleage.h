//
//  bookListViewDataDeleage.h
//  BiShe
//
//  Created by Jz on 16/1/13.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JZBook.h"

typedef void(^selectBook)(NSIndexPath * index);

@interface bookListViewDataDeleage : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSArray<JZBook *> *books;/**<<#text#> */

@property(nonatomic,copy)selectBook selectBook;

- (instancetype)initWithData:(NSArray *)data;


@end
