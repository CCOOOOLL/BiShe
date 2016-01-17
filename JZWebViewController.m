//
//  JZWebViewController.m
//  BiShe
//
//  Created by Jz on 15/12/28.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZWebViewController.h"
#import "JZHUD.h"
@interface JZWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

static NSString *const basePath = @"http://frodo.douban.com/h5/book/%@/buylinks";

@implementation JZWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlPath = [NSString stringWithFormat:basePath,self.bookId];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor   = [UIColor colorWithRed:74/255.0 green:184/255.0 blue:58/255.0 alpha:1];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidStartLoad:(UIWebView *)webView{

    [JZHUD showHUDandTitle:@""];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [JZHUD showSuccessandTitle:@""];
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
