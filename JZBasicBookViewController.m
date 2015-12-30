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
#import "JZLoadingView.h"
#import "JZShortCommentaryTableViewController.h"
@interface JZBasicBookViewController ()<UIGestureRecognizerDelegate,JZShortCommentaryTableViewControllerDeleage>
@property (weak, nonatomic) IBOutlet UIImageView *backImage;/**< 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;/**< 图书封面 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fistTableViewHeght;/**< 第一个tableview的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synopsisLableHeight;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;/**< 简介 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;/**< 内容高度 */
@property (weak, nonatomic) IBOutlet UIView *lastView;/**< 笔记视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;/**< 内容容器 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentVIewHeght;
@property (nonatomic, strong)JZLoadingView *loadingView;
@end

@implementation JZBasicBookViewController


#pragma mark懒加载

- (JZLoadingView *)loadingView{
    if (!_loadingView) {
        CGRect rect         = self.view.bounds;
        CGPoint point       = CGPointMake(rect.size.width/2.0, rect.size.height/2.0-60);
        rect.size           = CGSizeMake(60, 60);
        _loadingView        = [[JZLoadingView alloc]initWithFrame:rect];
        _loadingView.center = point;
        [self.view addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.loadingView startAnimation];
    [self loadData];
    self.contentHeight.constant = CGRectGetMaxY(self.lastView.frame);
    self.navigationController.interactivePopGestureRecognizer.delegate = self;





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
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:74/255.0 green:184/255.0 blue:58/255.0 alpha:1]];
    self.navigationController.navigationBar.tintColor   = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    if (_bookData) {
        NSURL *path = [NSURL URLWithString:self.bookData.image];
        [self.bookImage yy_setImageWithURL:path placeholder:nil options:YYWebImageOptionProgressive|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            
        }];
        [self.backImage yy_setImageWithURL:path options:YYWebImageOptionAllowBackgroundTask];
        //加载简介
        self.synopsis.text = self.bookData.summary;
        [self.loadingView stopAnimating];

     
    }

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
    if ([segue.identifier isEqualToString:@"baseView2duanping"]){
        JZShortCommentaryTableViewController *vc = segue.destinationViewController;
        vc.BookID = self.idUrl;
        vc.commentDeleage = self;

    }

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
