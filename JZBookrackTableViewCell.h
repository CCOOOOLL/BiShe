//
//  JZBookrackTableViewCell.h
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZBookrackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *bookListView;

- (void)setBooks:(NSArray *)booksData;
- (void)setTitle:(NSString *)title andNumber:(NSInteger)number didSelectBook:(void(^)(NSIndexPath * index)) selectBook;
@end
