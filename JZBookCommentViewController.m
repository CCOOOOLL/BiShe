//
//  JZBookCommentViewController.m
//  BiShe
//
//  Created by Jz on 15/12/31.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZBookCommentViewController.h"
#import "JZShortCommentsStore.h"
#import "JZNewWorkTool.h"
#import "JZCommentsTableViewCell.h"
#import "JZParticularComentViewController.h"
#import "JZMoreCommentViewController.h"
#import "MJRefresh.h"

static NSString *const identifier = @"shortCommentCell";

static NSString *const more = @"moreCell";

@interface JZBookCommentViewController ()
@property (nonatomic, strong)JZShortCommentsStore *commentStore;
@property (nonatomic, strong)NSIndexPath *indexpath;
@end

@implementation JZBookCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     MJRefreshNormalHeader *refresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self setUpData];
     }];
    self.tableView.mj_header = refresh;
    refresh.stateLabel.hidden = YES;
    refresh.lastUpdatedTimeLabel.hidden = YES;
     [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [UIView new];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpData{
    [[JZNewWorkTool workTool]datawithComments:self.BookID page:1 success:^(id obj) {
        self.commentStore = obj;
        self.tableView.estimatedRowHeight = 155.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView reloadData];
        if ([self.commentDeleage respondsToSelector:@selector(CommenttableViewWihtHegiht:)]) {
            CGFloat height         = self.tableView.contentSize.height;
             [self.commentDeleage CommenttableViewWihtHegiht:height];
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.indexpath];
            [self.commentDeleage CommenttableViewWihtHegiht:CGRectGetMaxY(rectInTableView)];
            [self.tableView.mj_header endRefreshing];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.commentStore.shortComments) {
        return self.commentStore.shortComments.count<6?self.commentStore.shortComments.count:6;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:more forIndexPath:indexPath];
        self.indexpath = indexPath;
        return cell;
        
    }
    JZCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.data = self.commentStore.shortComments[indexPath.row];
    self.indexpath = indexPath;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZParticularComentViewController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"JZParticularComentViewController"];
    vc.data = self.commentStore.shortComments[indexPath.row];
    vc.imageUrl = self.imageUrl;
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toMoreCommentView"]) {
        JZMoreCommentViewController *vc = segue.destinationViewController;
        vc.imageUrl = self.imageUrl;
        vc.BookID = self.BookID;
    }
}



@end
