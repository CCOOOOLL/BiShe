//
//  JZWebViewController.m
//  BiShe
//
//  Created by Jz on 15/12/28.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZWebViewController.h"
#import "JZLoadingView.h"
@interface JZWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet JZLoadingView *loadingView;

@end

static NSString *const basePath = @"http://frodo.douban.com/h5/book/%@/buylinks";

@implementation JZWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *urlPath = [NSString stringWithFormat:basePath,self.bookId];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidStartLoad:(UIWebView *)webView{

    [self.loadingView startAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingView stopAnimating];
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
