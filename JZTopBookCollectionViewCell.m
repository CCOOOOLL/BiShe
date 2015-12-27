//
//  JZTopBookCollectionViewCell.m
//  BiShe
//
//  Created by Jz on 15/12/26.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZTopBookCollectionViewCell.h"
#import "JZBookView.h"
#import "JZBooksStore.h"
@interface JZTopBookCollectionViewCell ()

@property (weak, nonatomic) IBOutlet JZBookView *bookView;

@end

@implementation JZTopBookCollectionViewCell


- (void)setBookViewModels:(id<BookViewProtocol>)bookViewModels{
    self.bookView.Model = bookViewModels;
    [self.bookView.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
}

- (void)click:(UIButton *)button{
    self.clickBlock();
}
@end
