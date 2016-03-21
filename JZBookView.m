//
//  JZBookView.m
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZBookView.h"
#import "starView.h"
#import "YYWebImage.h"

IB_DESIGNABLE
@interface JZBookView ()
@property (strong, nonatomic)IBInspectable IBOutlet UIView *contentView;
@property (weak, nonatomic)IBInspectable IBOutlet UIImageView *BookImageView;
@property (weak, nonatomic)IBInspectable IBOutlet starView *bookStar;
@property (weak, nonatomic)IBInspectable IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *average;

@end

@implementation JZBookView
- (UIImageView *)imageView{
    return self.BookImageView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView = [[NSBundle mainBundle]loadNibNamed:@"JZBookView" owner:self options:nil].lastObject;
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;


}


- (void)setModel:(id<BookViewProtocol>)Model{
    self.bookTitle.text = [Model bookViewtitle];
    self.average.text = [Model bookViewaverage];
    self.bookStar.showStar = [NSNumber numberWithFloat:[[Model bookViewaverage] floatValue]];
    ///加载图片
    [self.BookImageView yy_setImageWithURL:[NSURL URLWithString:[Model bookViewImageUrl]] options:YYWebImageOptionSetImageWithFadeAnimation];
//    [self.BookImageView yy_setImageWithURL:[NSURL URLWithString:[Model bookViewImageUrl]] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation progress:nil transform:^UIImage *(UIImage *image, NSURL *url) {
//        return[image yy_imageByRoundCornerRadius:4];
//        
//    } completion:nil];

    
}

@end
