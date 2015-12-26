//
//  JZBookCollectionViewController.m
//  BiShe
//
//  Created by Jz on 15/12/26.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZBookCollectionViewController.h"
#import "JZNewWorkTool.h"
#import "JZBooksStore.h"
#import "JZTopBookCollectionViewCell.h"
#import "MJRefresh.h"

@interface JZBookCollectionViewController ()

@property(nonatomic, strong)JZBooksStore *booksStore;/**< 图书模型操作数组 */

@end

@implementation JZBookCollectionViewController

static NSString * const reuseIdentifier = @"cell";

#pragma mark -属性设置

- (JZBooksStore *)booksStore{
    if (!_booksStore) {
        _booksStore = [[JZBooksStore alloc]init];
        _booksStore.books = [NSMutableArray array];
    }
    return _booksStore;
}

- (void)setContentData:(NSDictionary *)contentData{
    _contentData = contentData;
    self.navigationItem.title = contentData[@"name"];
    [self.collectionView.mj_footer beginRefreshing];
    [self loadMoreData];
}

#pragma mark -生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[JZTopBookCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.

    MJRefreshAutoNormalFooter *refresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];

    }];
    refresh.triggerAutomaticallyRefreshPercent = -20;
    self.collectionView.mj_footer = refresh;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

}

#pragma mark -其他

/**
 *  加载更多数据
 */
- (void)loadMoreData{
     JZNewWorkTool *tool = [JZNewWorkTool workTool];
     NSNumber *start = [NSNumber numberWithInteger:self.booksStore.books.count];
     NSNumber *end = [NSNumber numberWithInteger:self.booksStore.books.count+20];
    [tool dataWithCategory:self.contentData[@"id"] start:start end:end success:^(JZBooksStore *booksStore) {
        if (!self.booksStore.books) {
            self.booksStore.books = [NSMutableArray array];
        }
        [booksStore.books enumerateObjectsUsingBlock:^(BookData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.booksStore.books addObject:obj];
        }];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.booksStore.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JZTopBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.bookViewModels = self.booksStore.books[indexPath.row];
    return cell;
}



#pragma mark <UICollectionViewDelegate>



@end
