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
@interface JZSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *nullView;

@property(nonatomic,strong) JZBooksStore * booksStore;/**<数据源 */
@end

@implementation JZSearchViewController

static NSString *const Identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    [self setUpWithTextFiled];
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

- (void)setUpWithTableView{

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.booksStore.books.count;
    self.searchTableView.hidden = count==0?YES:NO;
    return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZSearchBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.bookDataModel = self.booksStore.books[indexPath.row];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)searchTextDidChanged:(id)sender {
    if ([self.searchView.text isEqualToString:@""]) {
        self.searchTableView.hidden =YES;
        return;
    }
    JZNewWorkTool *tool = [JZNewWorkTool workTool];
    [tool dataWithBookName:self.searchView.text start:@0 count:@20 success:^(id obj) {
        self.booksStore = obj;
        [self.searchTableView reloadData];
        CGPoint point = self.searchTableView.contentOffset;
        point.y = 0;
        self.searchTableView.contentOffset = point;
//        self.searchTableView.contentOffset = CGPointMake(0, 0);
    }];
}

- (IBAction)dissWIthController:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
