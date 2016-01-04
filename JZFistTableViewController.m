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
#import "JZBookDataViewController.h"
#import "JZGradeViewController.h"
#import "JZWildDog.h"

@interface JZFistTableViewController ()<JZGradeViewControllerDeleage>
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *otherData;
@property (weak, nonatomic) IBOutlet starView *star;
@property (weak, nonatomic) IBOutlet UILabel *average;
@property (weak, nonatomic) IBOutlet UITableViewCell *collectView;

@property (weak, nonatomic) IBOutlet UIView *gradeView;

@end

@implementation JZFistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];
//    [JZWildDog WildDog]

}
- (void)setUpData{
    if (_bookDataModel) {
        self.bookTitle.text = [self.bookDataModel bookViewtitle];
        self.star.showStar =  (NSNumber*)[self.bookDataModel bookViewaverage];
        self.average.text = [NSString stringWithFormat:@"%@(%@人评价)",[self.bookDataModel bookViewaverage],[self.bookDataModel bookViewnumRaters]];
        self.otherData.text = [self.bookDataModel bookViewAuthor];
    }

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
    }else if ([segue.identifier isEqualToString:@"fistTableVIew2BookDataView"]){
        JZBookDataViewController *vc = segue.destinationViewController;
        vc.bookData = self.bookDataModel;

    }
}
- (IBAction)pushGradeView:(UIButton *)sender {
    JZGradeViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JZGradeViewController"];
    vc.gradeType = sender.tag;
    vc.bookId = [self.bookDataModel bookViewId];
    vc.deleage = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)evaluateBookData{
//    [[JZWildDog WildDog]addBook:self.bookDataModel withSuccess:nil fail:nil];
}

@end
