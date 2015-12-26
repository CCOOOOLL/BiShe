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

- (void)setBookViewModels:(BookData *)bookViewModels{
    self.bookView.Model = bookViewModels;
    
}

@end
