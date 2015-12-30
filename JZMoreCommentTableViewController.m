//
//  JZMoreCommentTableViewController.m
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZMoreCommentTableViewController.h"
#import "JZNewWorkTool.h"
#import "JZShortCommentsStore.h"
#import "JZLoadingView.h"
#import <MJRefresh.h>
#import "JZShortCommentsTableViewCell.h"
@interface JZMoreCommentTableViewController ()
@property (nonatomic, strong)JZShortCommentsStore *commentStore;
@property(nonatomic,strong)JZLoadingView *loadingView;/**<<#text#> */
@property(nonatomic,assign)NSInteger start;/**<<#text#> */

@end
static NSString *const identifier = @"shortCommentCell";
@implementation JZMoreCommentTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.start = 1;
    [self setUpLoadView];
    
    MJRefreshAutoNormalFooter *refresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
        
    }];
    refresh.triggerAutomaticallyRefreshPercent = -20;
    self.tableView.mj_footer = refresh;
    [self loadMoreData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadMoreData{
    JZNewWorkTool *tool = [JZNewWorkTool workTool];
    [self.loadingView startAnimation];
    
    [tool datawithshortComments:self.BookID page:self.start success:^(id obj) {
        if (!self.commentStore.shortComments) {
            self.commentStore.shortComments = [NSMutableArray array];
        }
        JZShortCommentsStore *store = (JZShortCommentsStore*)obj;
        for (JZShortComment *comment in store.shortComments) {
            [self.commentStore.shortComments addObject:comment];
        }
        self.start += 1;
        [self.loadingView stopAnimating];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

    }];

}

-(void)setUpLoadView{
    CGRect rect         = self.tableView.bounds;
    CGPoint point       = CGPointMake(rect.size.width/2.0, rect.size.height/2.0-60);
    rect.size           = CGSizeMake(60, 60);
    _loadingView        = [[JZLoadingView alloc]initWithFrame:rect];
    _loadingView.center = point;
    [self.tableView addSubview:_loadingView];
}


- (JZShortCommentsStore *)commentStore{
    if (!_commentStore) {
        _commentStore = [[JZShortCommentsStore alloc]init];
    }
    return _commentStore;
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.commentStore.shortComments) {
        return self.commentStore.shortComments.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JZShortCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.data = self.commentStore.shortComments[indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
