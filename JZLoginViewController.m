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
@interface JZLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

@implementation JZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logining:(id)sender {
//    [[JZWildDog WildDog] createUser:self.userTextField.text password:self.passWordTextField.text name:@"aaaa" withBlock:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
    [[JZWildDog WildDog]loginUser:self.userTextField.text password:self.passWordTextField.text WithBlock:^(NSError *error, WAuthData *authData) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
