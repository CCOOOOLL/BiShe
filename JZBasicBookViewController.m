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
#import "JZShortCommentaryTableViewController.h"
#import "JZBookCommentViewController.h"
#import "JZWildDog.h"
#import "JZShortCommentsStore.h"
#import "JZPromptView.h"
#import "JZHUD.h"
@interface JZBasicBookViewController ()<UIGestureRecognizerDelegate,JZShortCommentaryTableViewControllerDeleage,JZBookCommentViewControllerhDeleage>
@property (weak, nonatomic) IBOutlet UIImageView *backImage;/**< 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;/**< 图书封面 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fistTableViewHeght;/**< 第一个tableview的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synopsisLableHeight;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;/**< 简介 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;/**< 内容高度 */
@property (weak, nonatomic) IBOutlet UIView *lastView;/**< 笔记视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;/**< 内容容器 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentVIewHeght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BookReviewViewHeight;
@property(nonatomic,strong)JZPromptView *promptView;/**<<#text#> */
@end

@implementation JZBasicBookViewController


#pragma mark懒加载

- (JZPromptView *)promptView{
    if (!_promptView) {
        _promptView = [JZPromptView prompt];
    }
    return _promptView;
}


#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentHeight.constant = CGRectGetMaxY(self.lastView.frame);
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.contentView.scrollsToTop = YES;
    






//    self.edgesForExtendedLayout = UIRectEdgeTop;
    
//    self.navigationController.navigationBar.translucent = YES;
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}



- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}



- (void) setUpWithData{
    //加载图片
        NSURL *path = [NSURL URLWithString:self.bookData.image];
        [self.bookImage yy_setImageWithURL:path placeholder:nil options:YYWebImageOptionProgressive|YYWebImageOptionSetImageWithFadeAnimation|YYWebImageOptionHandleCookies completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        }];
        [self.backImage yy_setImageWithURL:path options:YYWebImageOptionAllowBackgroundTask];
        //加载简介
        self.synopsis.text = self.bookData.summary;
        [JZHUD dismissHUD];
        self.contentView.hidden = NO;

    
    

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"bookVIew2fistView"]) {
        
        JZFistTableViewController *vc= segue.destinationViewController;
        
        if (!_bookData) {
            [JZHUD showHUDandTitle:@""];
            self.contentView.hidden = YES;
            JZNewWorkTool *tool = [JZNewWorkTool workTool];
            [tool dataWithBookid:self.idUrl success:^(id obj) {
                _bookData = obj;
                [self setUpWithData];
                vc.bookDataModel = obj;
                
            }fail:^(NSError *error) {
                [JZHUD showFailandTitle:@""];
                [self.promptView setError:error];
                [self.promptView starShow];
            }];
        }else{
            [self setUpWithData];
            vc.bookDataModel = self.bookData;
        }
    }
    if ([segue.identifier isEqualToString:@"baseView2duanping"]){
        JZShortCommentaryTableViewController *vc = segue.destinationViewController;
        vc.BookID = self.idUrl;
        vc.commentDeleage = self;

    }
    if ([segue.identifier isEqualToString:@"baseView2shuping"]) {
        JZBookCommentViewController *vc = segue.destinationViewController;
        vc.commentDeleage = self;
        vc.BookID = self.idUrl;
        vc.imageUrl = self.imageUrl;

    }

}

- (void)CommenttableViewWihtHegiht:(CGFloat)heght{
    CGFloat fist = self.BookReviewViewHeight.constant;
    self.BookReviewViewHeight.constant = heght;
    self.contentHeight.constant += (heght-fist)+30;
    [self.view layoutIfNeeded];

}

- (void)tableViewWihtHegiht:(CGFloat)heght{
    CGFloat fist = self.commentVIewHeght.constant;
    self.commentVIewHeght.constant = heght;
     self.contentHeight.constant += (heght-fist);
        [self.view layoutIfNeeded];
  
   
}
- (void)fistheight:(CGFloat)fist lastHeght:(CGFloat)last{
    
}
- (IBAction)zhankaiDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    CGFloat height1 = self.synopsis.bounds.size.height;
    self.synopsisLableHeight.constant = sender.selected? 500:50;
    [self.view layoutIfNeeded];
    CGFloat height2 = self.synopsis.bounds.size.height;
    self.contentHeight.constant += height2 - height1;
    

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = NO;
}

@end
