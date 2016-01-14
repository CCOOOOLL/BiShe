//
//  JZBookrackCollectionViewCell.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZBookrackCollectionViewCell.h"
#import "bookrackBookView.h"

@interface JZBookrackCollectionViewCell ()
@property (weak, nonatomic) IBOutlet bookrackBookView *contentView;

@end
@implementation JZBookrackCollectionViewCell
- (void)setData:(JZBook *)data{
    [self.contentView setData:data];
}
@end
