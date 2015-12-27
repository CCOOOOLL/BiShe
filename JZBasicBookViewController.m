//
//  JZBasicBookViewController.m
//  BiShe
//
//  Created by Jz on 15/12/27.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZBasicBookViewController.h"
#import "YYWebImage.h"
#import "JZFistTableViewController.h"
#import "JZNewWorkTool.h"

@interface JZBasicBookViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImage;/**< 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;/**< 图书封面 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fistTableViewHeght;/**< 第一个tableview的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synopsisLableHeight;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;/**< 简介
 */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@end

@implementation JZBasicBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.contentHeight.constant = CGRectGetMaxY(self.lastView.frame);

//    self.navigationController.navigationBar.translucent = YES;
    // Do any additional setup after loading the view.
}


/**
 *  初始化数据
 */
-(Book *)loadData{
    if (!_bookData) {
        JZNewWorkTool *tool = [JZNewWorkTool workTool];
        [tool dataWithBookid:self.idUrl success:^(id obj) {
            _bookData = obj;
            [self setUpWithData];
        }];
    }else{
        [self setUpWithData];
    }
    return _bookData;
}

- (void) setUpWithData{
    //加载图片
    NSURL *path = [NSURL URLWithString:self.bookData.image];
    [self.bookImage yy_setImageWithURL:path placeholder:nil options:YYWebImageOptionProgressive|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        
    }];
    [self.backImage yy_setImageWithURL:path options:YYWebImageOptionAllowBackgroundTask];
    //加载简介
    self.synopsis.text = self.bookData.summary;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"bookVIew2fistView"]) {
        
        JZFistTableViewController *vc= segue.destinationViewController;
        
        if (!_bookData) {
            JZNewWorkTool *tool = [JZNewWorkTool workTool];
            [tool dataWithBookid:self.idUrl success:^(id obj) {
                _bookData = obj;
                vc.bookDataModel = _bookData;
            }];

        }else{
            vc.bookDataModel = self.bookData;
        }
    }
}

- (IBAction)zhankaiDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    CGFloat height1 = self.synopsis.bounds.size.height;
    self.synopsisLableHeight.constant = sender.selected? 500:50;
    [self.view layoutIfNeeded];
    CGFloat height2 = self.synopsis.bounds.size.height;
    CGSize size = self.contentView.contentSize;
    size.height += height2-height1;
    self.contentView.contentSize = size;

    

}

@end
