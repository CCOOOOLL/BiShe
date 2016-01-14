//
//  JZHomeViewController.m
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZHomeViewController.h"
#import "JZBookTableViewController.h"
#import "GKHScanQCodeViewController.h"
#import "JZNewWorkTool.h"
#import "JZBasicBookViewController.h"
#import "Wilddog.h"
//#import "UIScrollView+JZ.h"
#import "JZWildDog.h"
IB_DESIGNABLE
@interface JZHomeViewController ()<UIScrollViewDelegate,QRScanViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *barScrollView;/**< 导航视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;/**< 内容视图 */
@property (nonatomic,strong)NSArray<NSArray*> *barItems;/**< 导航名称数组 */
@property(nonatomic,strong)UIButton *selectButton;/**< 选择的导航按钮 */
@property(nonatomic,strong)NSMutableArray<UIButton*> *buttons;/**< 导航按钮数组 */
@property(nonatomic,strong)NSMutableArray<JZBookTableViewController*> *controllers;/**< 自控制器数组 */
@property(nonatomic,strong)UIView *	slip;/**< 下滑快 */
@property (weak, nonatomic) IBOutlet UITextField *searchView;/**< 搜索文本视图 */
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property(nonatomic,strong)NSMutableDictionary *views;/**< 缓存数组 */
@end

@implementation JZHomeViewController

#pragma mark -懒加载

- (NSArray *)barItems{
    if (!_barItems) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Categorys" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        _barItems = array;
    }
    return _barItems;
}
#pragma mark -生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpWithTextFiled];
    // Do any additional setup after loading the view.
    [self setUpWithTabView];
    [self setUpWithSlip];
    [self setUpWithContetView];
    [self barClickDidWithButton:self.buttons[0]];
    [[JZWildDog WildDog]observeUserBook];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

}

- (void)viewWillAppear:(BOOL)animated{
    [self.drawer cententViewAddGestureRecognizer];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:74/255.0 green:184/255.0 blue:58/255.0 alpha:1]];
    self.navigationController.navigationBar.tintColor   = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.drawer cententViewRemoveGestureRecognizer];
    [super viewWillDisappear:animated];
    
}

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



#pragma mark -初始化
/**
 *  设置导航
 */
- (void)setUpWithTextFiled{
    UIImageView *image            = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_L"]];
    
    image.frame                   = CGRectMake(5, 5, 20, 20);
    
    UIView *view                  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    self.searchView.leftView     = view;
    self.searchView.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:image];
    self.navBarView.frame = self.navigationController.navigationBar.frame;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;


}

/**
 *  设置导航栏视图
 */
- (void)setUpWithTabView{
    NSMutableArray *items = [NSMutableArray array];
    for (NSArray *array in self.barItems) {
        [items addObject:array[0]];
    }
    CGFloat offectX = 8;

    self.buttons = [NSMutableArray array];
    
    for (NSString *name in items) {
        
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1]  forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button sizeToFit];
        button.frame = CGRectMake(offectX, (CGRectGetHeight(self.barScrollView.bounds)-CGRectGetHeight(button.frame))/2.0 , CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
        offectX += CGRectGetWidth(button.frame) + 16;
        
        [self.barScrollView addSubview:button];
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(barClickDidWithButton:) forControlEvents:UIControlEventTouchDown];


    }

    self.barScrollView.contentSize = CGSizeMake(offectX, 0);
}


/**
 *  设置下滑块
 */
- (void)setUpWithSlip{
    UIView * slide = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.barScrollView.frame) - 2, 20, 2)];
    [slide setBackgroundColor:[UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1]];
        [self.barScrollView addSubview:slide];
    self.slip = slide;
}
/**
 *  设置内容视图
 */
- (void)setUpWithContetView{
    self.controllers = [NSMutableArray array];
    for (int index =0; index<self.buttons.count; index++) {
        JZBookTableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"JZBookTableViewController"];
        [self.controllers addObject:vc];
        [self addChildViewController:vc];
        vc.Category = self.barItems[index].lastObject;
        vc.name = self.barItems[index].firstObject;
    }
    self.contentView.contentSize = CGSizeMake(self.controllers.count*self.view.bounds.size.width, 0);
    self.contentView.delegate = self;
    self.views = [NSMutableDictionary dictionary];
}

#pragma mark -其他
/**
 *  导航按钮点击事件
*/
- (void)barClickDidWithButton:(UIButton *)selectButton{
    if (!self.selectButton) {
        selectButton.selected = YES;

    }
    [self showViewByNumber:[self.buttons indexOfObject:selectButton]];
    CGFloat offsectX = selectButton.center.x - self.barScrollView.bounds.size.width*0.5;
    CGFloat maxOffset = self.barScrollView.contentSize.width - self.barScrollView.bounds.size.width;
    if (offsectX>0) {
        offsectX = offsectX>maxOffset ? maxOffset:offsectX;
    }else{
        offsectX = 0;
    }
    CGPoint point = CGPointMake(offsectX, 0);
    CGRect frame = self.slip.frame;
    
    frame.origin.x = CGRectGetMinX(selectButton.frame) - 8;
    frame.size.width = CGRectGetWidth(selectButton.frame) + 16;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.slip.frame = frame;
        self.barScrollView.contentOffset = point;
    } completion:^(BOOL finished) {
        self.selectButton.selected = NO;
        self.selectButton = selectButton;
          selectButton.selected = YES;
    }];
    

}
/**
 *  扫描条形码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)searchWithISBN:(id)sender {
    GKHScanQCodeViewController *vc = [[GKHScanQCodeViewController alloc]init];
    UINavigationController *nav    = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.delegate                    = self;
    [self presentViewController:nav animated:YES completion:nil];
}
/**< 显示内容界面 */
- (void)showViewByNumber:(NSInteger)number{
    self.contentView.contentOffset =CGPointMake((number)*self.view.bounds.size.width, 0) ;
    self.views[[NSString stringWithFormat:@"%ld",(long)number]] = self.controllers[number].tableView;
     self.controllers[number].tableView.frame = self.contentView.bounds;
    [self.views enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    for (int i=(int)number-2; i<number+2; i++) {
        UITableView *table =self.views[[NSString stringWithFormat:@"%d",i]];
        [self.contentView addSubview:table];
    }
    self.contentView.delaysContentTouches = NO;
}


#pragma mark - scrollViewDelegate



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self barClickDidWithButton:self.buttons[(int)index]];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
#pragma mark -QRScanViewDelegate
- (void)GKHScanQCodeViewController:(GKHScanQCodeViewController *)lhScanQCodeViewController readerScanResult:(NSString *)result{
    JZNewWorkTool *tool =[JZNewWorkTool workTool];
    [tool datawithISBN:result success:^(id obj) {
        JZBasicBookViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JZBasicBookViewController"];
        vc.bookData = obj;
        vc.idUrl = vc.bookData.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }fail:^(NSError *error) {
        
    }];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer.state != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - JZDrawerControllerProtocol
- (IBAction)openDrawer:(id)sender {
    [self.drawer open];
}

- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController
{
    self.navigationController.view.userInteractionEnabled = NO;

}

- (void)drawerControllerDidClose:(JZRootViewController *)drawerController
{
    self.navigationController.view.userInteractionEnabled = YES;
}

@end
