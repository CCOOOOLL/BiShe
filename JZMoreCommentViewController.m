//
//  JZMoreCommentViewController.m
//  BiShe
//
//  Created by Jz on 15/12/31.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZMoreCommentViewController.h"
#import "JZNewWorkTool.h"
#import "JZShortCommentsStore.h"

#import <MJRefresh.h>
#import "JZCommentsTableViewCell.h"
#import "JZParticularComentViewController.h"
#import "JZPromptView.h"
#import "JZHUD.h"

@interface JZMoreCommentViewController ()
@property (nonatomic, strong)JZShortCommentsStore *commentStore;

@property(nonatomic,assign)NSInteger start;/**<<#text#> */
@end

static NSString *const identifier = @"CommentCell";

@implementation JZMoreCommentViewController

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


- (void)loadMoreData{
    [JZHUD showHUDandTitle:@""];
    [[JZNewWorkTool workTool]datawithComments:self.BookID page:self.start success:^(id obj) {
        if (!self.commentStore.shortComments) {
            self.commentStore.shortComments = [NSMutableArray array];
        }
        JZShortCommentsStore *store = (JZShortCommentsStore*)obj;
        for (JZShortComment *comment in store.shortComments) {
            [self.commentStore.shortComments addObject:comment];
        }
        self.start += 1;
        [JZHUD showSuccessandTitle:@""];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }fail:^(NSError *error) {
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpLoadView{
    CGRect rect         = self.tableView.bounds;
    CGPoint point       = CGPointMake(rect.size.width/2.0, rect.size.height/2.0-60);
    rect.size           = CGSizeMake(60, 60);

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
    JZCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.data = self.commentStore.shortComments[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZParticularComentViewController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"JZParticularComentViewController"];
    vc.data = self.commentStore.shortComments[indexPath.row];
    vc.imageUrl = self.imageUrl;
    [self.navigationController pushViewController:vc animated:YES];
    
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
