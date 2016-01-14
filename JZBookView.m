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


- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView = [[NSBundle mainBundle]loadNibNamed:@"JZBookView" owner:self options:nil].lastObject;
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;


}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView = [[NSBundle mainBundle]loadNibNamed:@"JZBookView" owner:self options:nil].lastObject;
        [self addSubview:self.contentView];
        self.contentView.frame = self.bounds;

    }
    return self;
}
- (void)setModel:(id<BookViewProtocol>)Model{
    self.bookTitle.text = [Model bookViewtitle];
    self.average.text = [Model bookViewaverage];
    self.bookStar.showStar = [NSNumber numberWithFloat:[[Model bookViewaverage] floatValue]];
    NSURL *path = [NSURL URLWithString:[Model bookViewImageUrl]];
    [self.BookImageView yy_setImageWithURL:path placeholder:nil options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionProgressive|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {

    }];

    
}

@end
