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

#import "JZPromptView.h"
#import "JZHUD.h"
@interface JZLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property(nonatomic,strong)JZPromptView *promptView;;/**<<#text#> */
@property (weak, nonatomic) IBOutlet UIButton *sumbitButton;
@end

@implementation JZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.promptView = [JZPromptView prompt];
    self.userTextField.transform = CGAffineTransformMakeTranslation(-300, 0);
    self.passWordTextField.transform = CGAffineTransformMakeTranslation(300, 0);
    self.sumbitButton.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:0 animations:^{
        self.userTextField.transform = CGAffineTransformIdentity;
        self.passWordTextField.transform = CGAffineTransformIdentity;

    } completion:nil];
}

- (IBAction)logining:(id)sender {
    [JZHUD showHUDandTitle:@""];
    [[JZWildDog WildDog]loginUser:self.userTextField.text password:self.passWordTextField.text WithBlock:^(NSError *error, WAuthData *authData) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [JZHUD showSuccessandTitle:@""];
    }fail:^(NSError *error) {
        [JZHUD showFailandTitle:@""];
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
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)drawerControllerWillOpen:(JZRootViewController *)drawerController{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(JZRootViewController *)drawerController{
    self.view.userInteractionEnabled = YES;
}
@end
