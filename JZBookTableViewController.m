//
//  JZBookTableViewController.m
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZBookTableViewController.h"
#import "JZNewWorkTool.h"
#import "JZBooksStore.h"
#import "MJExtension.h"
#import "JZTopBookTableViewCell.h"
#import "JZBooksStore.h"
#import "MJRefresh.h"
#import "JZBookCollectionViewController.h"

#define file [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",self.name]]

@interface JZBookTableViewController ()

@property (nonatomic, strong)NSMutableArray<JZBooksStore *> *section;

@end

@implementation JZBookTableViewController

#pragma mark -懒加载
-(NSMutableArray<JZBooksStore *> *)section{
    if (!_section) {
        _section = [NSMutableArray array];
    }
    return _section;
}

#pragma mark -生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.section = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self LoadDataWithnumber:0];

    }];

    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark -其他
/**
 *  加载数据
 *
 */
- (void) LoadDataWithnumber:(NSInteger)number{
    
    if (number == self.Category.count) {
        return ;
    }
    JZNewWorkTool *tool = [JZNewWorkTool workTool];
    [tool dataWithCategory:self.Category[number][@"id"] start:@0 end:@3 success:^(JZBooksStore *booksStore) {
        self.section[number] = booksStore;
        [self LoadDataWithnumber:number+1];
        if (number == self.Category.count-1) {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [NSKeyedArchiver archiveRootObject:self.section toFile:file];
        }
    }];
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.section.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JZTopBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.section[indexPath.row]) {
        cell.bookViewModels = self.section[indexPath.row].books;
        cell.category.text = self.Category[indexPath.row][@"name"];
        cell.tagWithButton = indexPath.row;
    }


    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"bookTable2bookCollection"]) {
        UIButton *button = (UIButton*)sender;
        NSInteger number = button.tag - 100;
        JZBookCollectionViewController *vc = segue.destinationViewController;
        vc.contentData = self.Category[number];
        
    }
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
