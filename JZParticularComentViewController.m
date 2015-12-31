//
//  JZParticularComentViewController.m
//  BiShe
//
//  Created by Jz on 15/12/31.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZParticularComentViewController.h"
#import "starView.h"
#import "JZNewWorkTool.h"
#import "YYWebImage.h"

@interface JZParticularComentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *commentTItle;
@property (weak, nonatomic) IBOutlet UILabel *commentauthor;
@property (weak, nonatomic) IBOutlet UIImageView *commentauthorImage;
@property (weak, nonatomic) IBOutlet starView *star;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIView *footView;

@end

@implementation JZParticularComentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpData];
}
- (void)setCommentauthorImage:(UIImageView *)commentauthorImage{
    _commentauthorImage = commentauthorImage;
    _commentauthorImage.layer.masksToBounds =YES;
    _commentauthorImage.layer.cornerRadius = _commentauthorImage.bounds.size.height/2.0;
}

- (void)setData:(id<CommentProtocol>)data{
    _data = data;
}

- (void)setUpData{
    self.contentHeight.constant = CGRectGetHeight(self.view.frame);
    self.commentTItle.text      = [self.data commenttitle];
    self.commentauthor.text     = [self.data commentname];
    self.star.showStar = (NSNumber *)[self.data commentstar];
    [self.bookImage yy_setImageWithURL:[NSURL URLWithString:self.imageUrl] options:YYWebImageOptionProgressiveBlur];
    NSURL *url                  = [NSURL URLWithString:[self.data commentImageUrl]];
    [self.commentauthorImage yy_setImageWithURL:url options:YYWebImageOptionProgressiveBlur];
    [[JZNewWorkTool workTool]datawithCommentContentUrl:[self.data commenCOntentUrl] page:0 success:^(id obj) {
        JZShortComment *comment     = obj;
        self.commentContent.text    = comment.content;
        [self.view layoutIfNeeded];
        [self.commentContent sizeToFit];
        CGFloat foot                = CGRectGetMaxY(self.footView.frame);
        self.contentHeight.constant = foot>CGRectGetHeight(self.view.bounds)?foot-self.view.bounds.size.height:0;


       

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
