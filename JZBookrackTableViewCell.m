//
//  JZBookrackTableViewCell.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZBookrackTableViewCell.h"
#import "bookListViewDataDeleage.h"

@interface JZBookrackTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (nonatomic,strong)bookListViewDataDeleage *booksData;

@end
@implementation JZBookrackTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setBooks:(NSArray *)booksData{
    self.booksData = [[bookListViewDataDeleage alloc]initWithData:booksData];
    self.bookListView.dataSource = self.booksData;
    self.bookListView.delegate = self.booksData;
}
- (void)setTitle:(NSString *)title andNumber:(NSInteger)number didSelectBook:(void (^)(NSIndexPath *))selectBook{
    self.booksData.selectBook = selectBook;
    self.title.text = title;
    self.number.text = [NSString stringWithFormat:@"%d",number];
}
@end
