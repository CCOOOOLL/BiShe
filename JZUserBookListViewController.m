//
//  JZUserBookListViewController.m
//  BiShe
//
//  Created by Jz on 16/1/14.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZUserBookListViewController.h"
#import "JZSearchBookTableViewCell.h"
#import "JZComment.h"
#import "JZUserTagsView.h"
#import "JZTag.h"
#import "JZBasicBookViewController.h"
#import "JZBook.h"

static NSString *const identifier = @"cell";

@interface JZUserBookListViewController ()<JZUserTagsViewDeleage>
@property (weak, nonatomic) IBOutlet UITableView *bookLIstView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowsImage;
@property(nonatomic,strong)NSMutableArray *tagArray;/**<<#text#> */
@property(nonatomic,strong)NSMutableArray<JZComment *> *dataArray;/**<<#text#> */
@property (weak, nonatomic) IBOutlet JZUserTagsView *userTagsView;
@property (nonatomic, assign,getter=isShowTagsView)BOOL showTagsView;

@end

@implementation JZUserBookListViewController



- (NSMutableArray<JZComment *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:self.bookArray];
    }
    return _dataArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.showTagsView = YES;
    self.bookLIstView.dataSource =self;
    self.userTagsView.tagsArray = self.bookArray;
    self.userTagsView.tagsViewDeleage = self;
    self.bookLIstView.tableFooterView = [UIView new];
    self.bookLIstView.rowHeight = 104;

}

- (void)setBookArray:(NSArray<JZComment *> *)bookArray{
    _bookArray = (NSMutableArray *)bookArray;


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZSearchBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.bookDataModel = self.dataArray[indexPath.row].book;
    return cell;
}
- (IBAction)showTags:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.userInteractionEnabled = NO;
    self.showTagsView?[self openTagsViewWithSender:button]:[self closeTagsViewWithSender:button];
    self.showTagsView = !self.isShowTagsView;

}

- (void)openTagsViewWithSender:(UIButton *)sender{
    self.userTagsView.alpha = 0;
    self.userTagsView.hidden = NO;
    [UIView animateWithDuration:1 animations:^{
        self.userTagsView.alpha = 1;
    } completion:^(BOOL finished) {
        sender.userInteractionEnabled = YES;
    }];

}

- (void)closeTagsViewWithSender:(UIButton *)sender{
    [UIView animateWithDuration:1 animations:^{
        self.userTagsView.alpha = 0;
    } completion:^(BOOL finished) {
        self.userTagsView.hidden = YES;
        sender.userInteractionEnabled = YES;
    }];
}

- (void)searchDataWithTagName:(NSString *)tagName{
    self.dataArray = [NSMutableArray array];
    if ([tagName isEqualToString:@"全部"]) {
        self.dataArray = self.bookArray;
        [self.bookLIstView reloadData];
        return;
    }
    for (JZComment *comment in self.bookArray) {
        for (NSString *tag in comment.tags) {
            if ([tag isEqualToString:tagName]) {
                [self.dataArray addObject:comment];
            }
        }
    }
    [self showTags:nil];
    [self.bookLIstView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZBasicBookViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"JZBasicBookViewController"];
    vc.idUrl = self.dataArray[indexPath.row].book.bookID;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
