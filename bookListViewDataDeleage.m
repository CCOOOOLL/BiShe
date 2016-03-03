//
//  bookListViewDataDeleage.m
//  BiShe
//
//  Created by Jz on 16/1/13.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "bookListViewDataDeleage.h"
#import "JZBookrackCollectionViewCell.h"
#import "JZBasicBookViewController.h"
#import "JZComment.h"

static NSString *const identifier = @"bookList";

@implementation bookListViewDataDeleage

- (instancetype)initWithData:(NSArray *)data{
    self = [super init];
    if (self) {
        NSMutableArray *array = [NSMutableArray array];
        for (JZComment *comment in data) {
            [array addObject:comment.book];
        }
        self.books = array;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JZBookrackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setData:self.books[indexPath.row]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",self.selectBook);
    if (self.selectBook) {
        self.selectBook(indexPath);

    }
}

@end
