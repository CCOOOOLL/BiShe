//
//  JZBookDataViewController.m
//  BiShe
//
//  Created by Jz on 15/12/29.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZBookDataViewController.h"

@interface JZBookDataViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *author;/**< 作者 */
@property (weak, nonatomic) IBOutlet UILabel *publisher;/**< 出版社 */
@property (weak, nonatomic) IBOutlet UILabel *origin_title;/**< 原作名 */
@property (weak, nonatomic) IBOutlet UILabel *translator;/**< 翻译人员 */
@property (weak, nonatomic) IBOutlet UILabel *pages;/**< 页数 */
@property (weak, nonatomic) IBOutlet UILabel *price;/**< 价格 */
@property (weak, nonatomic) IBOutlet UILabel *pubdate;/**< 出版时间 */
@property (weak, nonatomic) IBOutlet UILabel *binding;/**< 版本 */
@property (weak, nonatomic) IBOutlet UILabel *isbn;

@end

@implementation JZBookDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpWithContentView];
    [self setUpData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor   = [UIColor colorWithRed:74/255.0 green:184/255.0 blue:58/255.0 alpha:1];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpWithContentView{
    CALayer *layer      = self.contentView.layer;
    layer.cornerRadius  = 4;
    layer.shadowColor   = [UIColor blackColor].CGColor;
    layer.shadowOffset  = CGSizeMake(1, 1);
    layer.shadowOpacity = 0.5;
    
}

- (void)setUpData{
    NSLog(@"%@",[self.bookData bookAuthor]);
    self.author.text       = [NSString stringWithFormat:@"%@ %@",self.author.text,[self.bookData bookAuthor]];
    self.publisher.text    = [NSString stringWithFormat:@"%@ %@",self.publisher.text,[self.bookData bookPublisher]];
    if ([[self.bookData bookOriginTitle] isEqualToString:@""]) {
        self.origin_title.hidden =YES;
    }
    self.origin_title.text = [NSString stringWithFormat:@"%@ %@",self.origin_title.text,[self.bookData bookOriginTitle]];
    if ([[self.bookData bookTranslator] isEqualToString:@""]) {
        self.translator.hidden =YES;
    }
    self.translator.text   = [NSString stringWithFormat:@"%@ %@",self.translator.text,[self.bookData bookTranslator]];
    self.pages.text        = [NSString stringWithFormat:@"%@ %@",self.pages.text,[self.bookData bookPages]];
    self.price.text        = [NSString stringWithFormat:@"%@ %@",self.price.text,[self.bookData bookPrice]];
    self.pubdate.text      = [NSString stringWithFormat:@"%@ %@",self.pubdate.text,[self.bookData bookPubdate]];
    self.binding.text      = [NSString stringWithFormat:@"%@ %@",self.binding.text,[self.bookData bookBinding]];
    self.isbn.text         = [NSString stringWithFormat:@"%@ %@",self.isbn.text,[self.bookData bookISBN]];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
