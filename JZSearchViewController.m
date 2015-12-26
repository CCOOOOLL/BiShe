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
@interface JZSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *nullView;
@property (nonatomic,strong)JZLoadingView *loadingView;
@property(nonatomic,strong) JZBooksStore * booksStore;/**<数据源 */
@end

@implementation JZSearchViewController

static NSString *const Identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    [self setUpWithTextFiled];
    [self setUpLoadView];
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
    CGRect rect = self.nullView.bounds;
    CGPoint point = CGPointMake(rect.size.width/2.0, rect.size.height/2.0 -60);
    rect.size = CGSizeMake(60, 60);
    rect.origin = point;
    _loadingView = [[JZLoadingView alloc]initWithFrame:rect];
//    _loadingView.center = point;
    [self.nullView addSubview:_loadingView];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchView resignFirstResponder];
}

- (IBAction)searchTextDidChanged:(id)sender {
    if ([self.searchView.text isEqualToString:@""]) {
        self.searchTableView.hidden =YES;
        return;
    }
    [self.loadingView startAnimation];
    JZNewWorkTool *tool = [JZNewWorkTool workTool];
    [tool dataWithBookName:self.searchView.text start:@0 count:@20 success:^(id obj) {
        self.booksStore = obj;
        [self.searchTableView reloadData];
        CGPoint point = self.searchTableView.contentOffset;
        point.y = 0;
        self.searchTableView.contentOffset = point;
        [self.loadingView stopAnimating];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchView resignFirstResponder];
    return YES;
}

- (IBAction)dissWIthController:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
