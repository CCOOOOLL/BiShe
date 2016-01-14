//
//  JZUserBookListViewController.m
//  BiShe
//
//  Created by Jz on 16/1/14.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZUserBookListViewController.h"
#import "JZSearchBookTableViewCell.h"
#import "JZBook.h"

static NSString *const identifier = @"cell";

@interface JZUserBookListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *bookLIstView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowsImage;
@property(nonatomic,strong)NSMutableArray *tagArray;/**<<#text#> */
@property(nonatomic,strong)NSMutableArray<JZBook *> *dataArray;/**<<#text#> */

@end

@implementation JZUserBookListViewController



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZSearchBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.bookDataModel = self.dataArray[indexPath.row];
    return cell;
}
- (IBAction)showTags:(id)sender {
}

@end
