//
//  JZLoginViewController.m
//  BiShe
//
//  Created by Jz on 16/1/2.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZLoginViewController.h"
#import "JZWildDog.h"
#import "userStroe.h"
#import "JZLoadingView.h"
#import "JZPromptView.h"
@interface JZLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (nonatomic,strong)JZLoadingView *lodingView;
@property(nonatomic,strong)JZPromptView *promptView;;/**<<#text#> */
@end

@implementation JZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lodingView = [JZLoadingView loadingWithParentView:self.view];
    self.promptView = [JZPromptView prompt];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logining:(id)sender {
    [self.lodingView startAnimation];
    [[JZWildDog WildDog]loginUser:self.userTextField.text password:self.passWordTextField.text WithBlock:^(NSError *error, WAuthData *authData) {
        UIViewController<JZDrawerControllerProtocol> *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JZUserDataViewController"];
        [self.drawer replaceCenterViewControllerWithViewController:vc];
        [self.lodingView stopAnimating];
    }fail:^(NSError *error) {
        [self.lodingView stopAnimating];
        [self.promptView  setError:error];
        [self.promptView starShow];
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
- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(JZRootViewController *)drawerController{
    self.view.userInteractionEnabled = YES;
}
@end
