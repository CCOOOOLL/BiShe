//
//  JZRegisterViewController.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZRegisterViewController.h"
#import "JZWildDog.h"

@interface JZRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassword;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation JZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createUser:(id)sender {
    __weak typeof(self) weakself = self;
    [[JZWildDog WildDog]createUser:self.email.text password:self.password.text name:self.name.text withSuccess:^{
        [[JZWildDog WildDog] loginUser:weakself.email.text password:weakself.password.text WithBlock:^(NSError *error, WAuthData *authData) {
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } fail:^(NSError *error) {
            
        }];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
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

@end
