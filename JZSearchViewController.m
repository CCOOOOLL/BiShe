//
//  JZSearchViewController.m
//  BiShe
//
//  Created by Jz on 15/12/24.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZSearchViewController.h"
#import "JZBooksStore.h"
#import "JZSearchBookTableViewCell.h"
#import "JZNewWorkTool.h"
#import "JZLoadingView.h"
#import "MJRefresh.h"
#import "JZBasicBookViewController.h"
#import "JZPromptView.h"


@interface JZSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *nullView;
@property(nonatomic,strong)JZPromptView *promptView;/**<<#text#> */
@property (nonatomic,strong)JZLoadingView *loadingView;/**< 加载动画 */
@property(nonatomic,strong) JZBooksStore * booksStore;/**<数据源 */
@property(nonatomic, assign)NSNumber *start;
@end

@implementation JZSearchViewController

static NSString *const Identifier = @"cell";

- (NSNumber *)start{
    if (!_start) {
        _start = @0;
    }
    return _start;
}
- (JZPromptView *)promptView{
    if (!_promptView) {
        _promptView = [JZPromptView prompt];
    }
    return _promptView;
}
- (JZBooksStore *)booksStore{
    if (!_booksStore) {
        _booksStore = [[JZBooksStore alloc]init];
        _booksStore.books = [NSMutableArray array];
    }
    return _booksStore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    [self setUpWithTextFiled];
    [self setUpLoadView];
    
    MJRefreshAutoNormalFooter *refresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
        
    }];
    refresh.triggerAutomaticallyRefreshPercent = -20;
    self.searchTableView.mj_footer = refresh;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化搜索框
 */
- (void)setUpWithTextFiled{
    UIImageView *image            = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_L"]];
    
    image.frame                   = CGRectMake(5, 5, 20, 20);
    
    UIView *view                  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    self.searchView.leftView     = view;
    self.searchView.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:image];
    self.navBarView.frame = self.navigationController.navigationBar.frame;
    [self.searchView becomeFirstResponder];




}




-(void)setUpLoadView{
//    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    self.loadingView = [JZLoadingView loadingWithParentView:[UIApplication sharedApplication].windows.lastObject];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.booksStore.books.count;
    self.searchTableView.hidden = count==0?YES:NO;
    return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZSearchBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.bookDataModel = self.booksStore.books[indexPath.row];
    cell.tag = 100+indexPath.row;
    return cell;
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchView resignFirstResponder];
}

- (IBAction)searchTextDidChanged:(id)sender {
//    [[JZNewWorkTool workTool] endRequest];
//    self.searchTableView.hidden =YES;
//    self.booksStore = nil;
//    self.start = @0;
//    if ([self.searchView.text isEqualToString:@""]) {
//        return;
//    }
//    [self.loadingView startAnimation];
//    [self loadData];
//    CGPoint point = self.searchTableView.contentOffset;
//    point.y = 0;
//    self.searchTableView.contentOffset = point;
}

- (void)loadData{
    JZNewWorkTool *tool = [JZNewWorkTool workTool];
    [tool dataWithBookName:self.searchView.text start:@0 count:@10 success:^(id obj) {

        if (!_booksStore) {
            _booksStore = [[JZBooksStore alloc]init];
            _booksStore.books = [NSMutableArray array];
        }
        JZBooksStore *booksStore = (JZBooksStore *)obj;
        
        self.booksStore = booksStore;
        [self.searchTableView reloadData];
        [self.loadingView stopAnimating];
        if (self.booksStore.books.count!=0&&![self.searchView.text isEqualToString:@""]){
             self.searchTableView.hidden = NO;
            return ;
        }
        
        self.searchTableView.hidden = YES;
       
    }fail:^(NSError *error) {
        [self.promptView setError:error];
        [self.promptView starShow];
        [self.loadingView stopAnimating];
    }];
}

- (void)loadMoreData{


    NSNumber *end = [NSNumber numberWithInt:[self.start intValue] + 10];
    JZNewWorkTool *tool = [JZNewWorkTool workTool];
    [tool dataWithBookName:self.searchView.text start:self.start count:end success:^(id obj) {
        JZBooksStore *booksStore = (JZBooksStore *)obj;
        for (Book *book in booksStore.books) {
            [self.booksStore.books addObject:book];
        }
        self.start = [NSNumber numberWithInt:[end intValue] + 1];
        [self.searchTableView reloadData];
        self.searchTableView.hidden = NO;
        [self.searchTableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self.promptView setError:error];
        [self.promptView starShow];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchView resignFirstResponder];
    [[JZNewWorkTool workTool] endRequest];
    self.searchTableView.hidden =YES;
    self.booksStore = nil;
    self.start = @0;
    if ([self.searchView.text isEqualToString:@""]) {
        return YES;
    }
    [self.loadingView startAnimation];
    [self loadData];
    CGPoint point = self.searchTableView.contentOffset;
    point.y = 0;
    self.searchTableView.contentOffset = point;
    return NO;
}

- (IBAction)dissWIthController:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"serachView2BookView"]) {
        JZBasicBookViewController *vc = segue.destinationViewController;
        UIView *view = sender;
        vc.bookData = self.booksStore.books[view.tag-100];
        vc.idUrl = vc.bookData.ID;
    }
}


@end
