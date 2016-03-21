//
//  JZBookrackViewController.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZBookrackViewController.h"
#import "Wilddog.h"
#import "userStroe.h"
#import "JZUserBook.h"
#import "MJExtension.h"
#import "JZComment.h"
#import "JZWildDog.h"
#import "JZBookrackTableViewCell.h"
#import "bookListViewDataDeleage.h"
#import "JZBasicBookViewController.h"
#import "JZUserBookListViewController.h"



@interface JZBookrackViewController ()

@property(nonatomic,strong)NSMutableArray<NSMutableArray<JZComment *> *> *comments;/**<<#text#> */
@end

@implementation JZBookrackViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.tableView.rowHeight = 220;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[JZWildDog WildDog]getUserBookWithSuccess:^(NSMutableArray *array) {
        self.comments = array;
        [self.tableView reloadData];
    } andFail:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController
{
    self.navigationController.view.userInteractionEnabled = NO;
    
}

- (void)drawerControllerDidClose:(JZRootViewController *)drawerController
{
    self.navigationController.view.userInteractionEnabled = YES;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSLog(@"%ld",self.books.count);
//    return self.books.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}
static NSString *const identifer = @"bookClass";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JZBookrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    [cell setBooks:self.comments[indexPath.row]];
    NSString *str;
    switch ((GradeType)[self.comments[indexPath.row].firstObject.gradeType intValue]) {
        case GradeTypeXiangDu:
            str = @"想读的书";
            break;
        case GradeTypeYiDu:
            str = @"已读的书";
            break;
        case GradeTypeZaiDu:
            str = @"在读的书";
            break;
        default:
            break;
    }
    __block typeof(self) weakSelf = self;
    [cell setTitle:str andNumber:self.comments[indexPath.row].count didSelectBook:^(NSIndexPath *index) {
        JZBasicBookViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"JZBasicBookViewController"];
        JZComment *data = weakSelf.comments[indexPath.row][index.row];
        vc.idUrl = data.bookID;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZUserBookListViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"JZUserBookListViewController"];
    vc.bookArray = self.comments[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)openDrawer:(id)sender {
    [self.drawer open];
}



@end
