//
//  JZShortCommentsTableViewCell.m
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZShortCommentsTableViewCell.h"
#import "starView.h"
#import <YYWebImage.h>
@interface JZShortCommentsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentAuthor;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UILabel *commentassist;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet starView *commentStar;
@end

@implementation JZShortCommentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCommentImage:(UIImageView *)commentImage{
    _commentImage = commentImage;
    _commentImage.layer.masksToBounds =YES;
    _commentImage.layer.cornerRadius = _commentImage.bounds.size.height/2.0;
}

- (void)setData:(id<CommentProtocol>)data{
    self.commentAuthor.text = [data commentname];
    self.commentContent.text = [data commentcontent];
    self.commentassist.text = [data commentassist];
    self.commentTime.text = [data commenttime];
    self.commentStar.showStar = (NSNumber*)[data commentstar];
    NSURL *path = [NSURL URLWithString:[data commentImageUrl]];
    [self.commentImage yy_setImageWithURL:path placeholder:nil options:YYWebImageOptionProgressive|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
       
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
