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
@property (nonatomic, strong)NSIndexPath *indexpath;

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
            [self.commentDeleage tableViewWihtHegiht:self.tableView.contentSize.height];
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.indexpath];
            [self.commentDeleage tableViewWihtHegiht:CGRectGetMaxY(rectInTableView)];
        }
    } fail:^(NSError *error) {
        
    }];
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
//    NSLog(@"%@",self.indexpath)
    if (indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:more forIndexPath:indexPath];
        
        return cell;

    }
    JZShortCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.data = self.commentStore.shortComments[indexPath.row];
    
    
    return cell;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"2MoreComment"]) {
        JZMoreCommentTableViewController *vc= segue.destinationViewController;
        vc.BookID = self.BookID;
    }
}


@end
