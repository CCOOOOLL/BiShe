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
#import "MJRefresh.h"
#import "JZBasicBookViewController.h"
#import "JZPromptView.h"


@interface JZSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *nullView;
@property(nonatomic,strong)JZPromptView *promptView;/**<<#text#> */
@property(nonatomic,strong) JZBooksStore * booksStore;/**<数据源 */
//@property(nonatomic, assign)NSNumber *start;
@end

@implementation JZSearchViewController

static NSString *const Identifier = @"cell";


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
    self.searchTableView.tableFooterView = [UIView new];
    MJRefreshAutoNormalFooter *refresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadBookDataWihtStart:self.booksStore.books.count andCount:10];
        
    }];
//    refresh.triggerAutomaticallyRefreshPercent = -20;
    self.searchTableView.mj_footer = refresh;

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






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.searchTableView.hidden = self.booksStore.books.count==0?YES:NO;
    return self.booksStore.books.count;
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

}

- (void)loadBookDataWihtStart:(NSInteger)start andCount:(NSInteger) count{
    [[JZNewWorkTool workTool]dataWithBookName:self.searchView.text start:start count:count success:^(id obj) {
        JZBooksStore *bookStore = (JZBooksStore *)obj;
        if (start == 0) {
            self.booksStore = bookStore;
        }else{
            [self.booksStore.books addObjectsFromArray:bookStore.books];
        }
        [self.searchTableView reloadData];
        self.searchTableView.hidden = NO;
        [self.searchTableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchView resignFirstResponder];
    [[JZNewWorkTool workTool] endRequest];
    self.searchTableView.hidden =YES;
    if ([self.searchView.text isEqualToString:@""]) {
        return YES;
    }
    [self loadBookDataWihtStart:0 andCount:10];
    CGPoint point = self.searchTableView.contentOffset;
    point.y = 0;
    self.searchTableView.contentOffset = point;
    return YES;
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
