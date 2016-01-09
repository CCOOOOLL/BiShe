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
#import "JZLoadingView.h"
#import "JZBasicBookViewController.h"
#import "JZWildDog.h"

@interface JZBookCollectionViewController ()

@property(nonatomic, strong)JZBooksStore *booksStore;/**< 图书模型操作数组 */
@property(nonatomic,strong)JZLoadingView *loadingView;/**<<#text#> */
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
    [self setUpLoadView];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    MJRefreshAutoNormalFooter *refresh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];

    }];
    refresh.triggerAutomaticallyRefreshPercent = -20;
    refresh.refreshingTitleHidden = YES;
    self.collectionView.mj_footer = refresh;
    

}


#pragma mark -其他

/**
 *  加载更多数据
 */

- (void)loadMoreData{
     JZNewWorkTool *tool = [JZNewWorkTool workTool];
    [self.loadingView startAnimation];
     NSNumber *start = [NSNumber numberWithInteger:self.booksStore.books.count];
     NSNumber *end = [NSNumber numberWithInteger:self.booksStore.books.count+20];
    [tool dataWithCategory:self.contentData[@"id"] start:start end:end success:^(JZBooksStore *booksStore) {
        if (!self.booksStore.books) {
            self.booksStore.books = [NSMutableArray array];
        }
        [booksStore.books enumerateObjectsUsingBlock:^(BookData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.booksStore.books addObject:obj];
        }];
        [self.loadingView stopAnimating];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    }];
}
/**
 *  初始化加载动画
 */
-(void)setUpLoadView{
//    CGRect rect         = self.collectionView.bounds;
//    CGPoint point       = CGPointMake(rect.size.width/2.0, rect.size.height/2.0-60);
//    rect.size           = CGSizeMake(60, 60);
//    _loadingView        = [[JZLoadingView alloc]initWithFrame:rect];
//    _loadingView.center = point;
//    [self.collectionView addSubview:_loadingView];
    self.loadingView = [JZLoadingView loadingWithParentView:self.collectionView];
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
    __weak JZBookCollectionViewController * wself = self;
    cell.clickBlock = ^{
        JZBasicBookViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"JZBasicBookViewController"];
        BookData *data = wself.booksStore.books[indexPath.row];
        vc.idUrl = data.bookid;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}



#pragma mark <UICollectionViewDelegate>



@end
