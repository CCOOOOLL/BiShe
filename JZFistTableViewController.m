//
//  JZFistTableViewController.m
//  BiShe
//
//  Created by Jz on 15/12/27.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZFistTableViewController.h"
#import "starView.h"
#import "JZBooksStore.h"
#import "JZWebViewController.h"
@interface JZFistTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *otherData;
@property (weak, nonatomic) IBOutlet starView *star;
@property (weak, nonatomic) IBOutlet UILabel *average;
@property (weak, nonatomic) IBOutlet UITableViewCell *collectView;


@end

@implementation JZFistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];

}
- (void)setUpData{
    NSLog(@"%@",self.bookDataModel);
    self.bookTitle.text = [self.bookDataModel bookViewtitle];
    self.star.showStar =  (NSNumber*)[self.bookDataModel bookViewaverage];
    self.average.text = [NSString stringWithFormat:@"%@(%@人评价)",[self.bookDataModel bookViewaverage],[self.bookDataModel bookViewnumRaters]];
    self.otherData.text = [self.bookDataModel bookViewAuthor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBookDataModel:(id<BookViewProtocol>)bookDataModel{
    _bookDataModel = bookDataModel;
    [self setUpData];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fistView2WebView"]) {
        JZWebViewController *vc = segue.destinationViewController;
        vc.bookId = [self.bookDataModel bookViewId];
    }
}


@end
