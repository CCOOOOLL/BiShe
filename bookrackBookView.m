//
//  bookrackBookView.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "bookrackBookView.h"
#import "UIImageView+YYWebImage.h"

IB_DESIGNABLE
@interface bookrackBookView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *booTitle;

@end

@implementation bookrackBookView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView = [[NSBundle mainBundle]loadNibNamed:@"bookrackBookView" owner:self options:nil].lastObject;
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView = [[NSBundle mainBundle]loadNibNamed:@"bookrackBookView" owner:self options:nil].lastObject;
        [self addSubview:self.contentView];
        self.contentView.frame = self.bounds;
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setData:(JZBook *)data{
    self.booTitle.text = data.title;
    NSURL *url = [NSURL URLWithString:data.image];
    [self.bookImage yy_setImageWithURL:url options:YYWebImageOptionIgnoreDiskCache];
}
@end
