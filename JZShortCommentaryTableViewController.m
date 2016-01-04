//
//  JZShortCommentaryTableViewController.m
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZShortCommentaryTableViewController.h"
#import "JZNewWorkTool.h"
#import "JZShortCommentsStore.h"
#import "JZShortCommentsTableViewCell.h"
#import "JZMoreCommentTableViewController.h"
#import "JZWildDog.h"
@interface JZShortCommentaryTableViewController ()

@property (nonatomic, strong)JZShortCommentsStore *commentStore;
@property (nonatomic, assign)NSIndexPath *indexpath;

@end



@implementation JZShortCommentaryTableViewController

static NSString *const identifier = @"shortCommentCell";

static NSString *const more = @"moreCell";



- (void)viewDidLoad {
    [super viewDidLoad];

    [[JZNewWorkTool workTool]datawithshortComments:self.BookID page:1 success:^(id obj) {
        self.commentStore = obj;
        self.tableView.estimatedRowHeight = 155.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView reloadData];
        if ([self.commentDeleage respondsToSelector:@selector(tableViewWihtHegiht:)]) {
            [self.commentDeleage tableViewWihtHegiht:1500];
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.indexpath];
            [self.commentDeleage tableViewWihtHegiht:CGRectGetMaxY(rectInTableView)];
        }
    }];
//    [[JZWildDog WildDog]updeBookShortCommentWithBookId:self.BookID page:1 withSuccess:^(JZShortCommentsStore *store) {
//        self.commentStore = store;
//        self.tableView.estimatedRowHeight = 155.0;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//        [self.tableView reloadData];
//        if ([self.commentDeleage respondsToSelector:@selector(tableViewWihtHegiht:)]) {
//            [self.commentDeleage tableViewWihtHegiht:1500];
//            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.indexpath];
//            [self.commentDeleage tableViewWihtHegiht:CGRectGetMaxY(rectInTableView)];
//        }
//    } fail:^(NSError *error) {
//        
//    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.commentStore.shortComments) {
        return self.commentStore.shortComments.count<6?self.commentStore.shortComments.count:6;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexpath = indexPath;
    if (indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:more forIndexPath:indexPath];
        
        return cell;

    }
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

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"2MoreComment"]) {
        JZMoreCommentTableViewController *vc= segue.destinationViewController;
        vc.BookID = self.BookID;
    }
}


@end
