//
//  JZTopBookTableViewCell.m
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZTopBookTableViewCell.h"
#import "JZBookView.h"

@interface JZTopBookTableViewCell ()
@property (weak, nonatomic) IBOutlet JZBookView *bookView1;
@property (weak, nonatomic) IBOutlet JZBookView *bookView2;
@property (weak, nonatomic) IBOutlet JZBookView *bookView3;
@property (weak, nonatomic) IBOutlet UIButton *moerButton;

@end

@implementation JZTopBookTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSArray<JZBookView *> *)bookViews{
    if (!_bookViews) {
        _bookViews = @[self.bookView1,self.bookView2,self.bookView3];
        int index = 0;
        for (JZBookView *view in _bookViews) {
            view.button.tag =150 + index;
            [view.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
    }
    return _bookViews;
}
- (void)click:(UIButton *)button{
    self.clickBlock(button.tag-150);
}
- (void)setBookViewModels:(NSArray<id<BookViewProtocol>> *)bookViewModels{
    _bookViewModels = bookViewModels;
    
    [self.bookViews enumerateObjectsUsingBlock:^(JZBookView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.Model = bookViewModels[idx];
    }];
}

- (void)setTagWithButton:(NSInteger)tagWithButton{
    _tagWithButton = tagWithButton;
    self.moerButton.tag = tagWithButton + 100;
}
@end
