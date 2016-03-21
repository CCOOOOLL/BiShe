//
//  JZDrawerViewController.m
//  BiShe
//
//  Created by Jz on 16/1/11.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZDrawerViewController.h"
#import "userStroe.h"
@interface JZDrawerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPortrait;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic,strong)UIViewController<JZDrawerControllerProtocol>  *homeViewController;
@property(nonatomic,strong)UIViewController<JZDrawerControllerProtocol> *bookListViewController;/**<<#text#> */
@property(nonatomic,strong)UIViewController<JZDrawerControllerProtocol> *userViewController;
@property(nonatomic,strong)UIViewController<JZDrawerControllerProtocol> *LoginViewController;

@property(nonatomic,assign)NSUInteger number;
@property (nonatomic,assign,getter=isHaveUser)BOOL haveUser;
@end



@implementation JZDrawerViewController


-(UIViewController<JZDrawerControllerProtocol> *)bookListViewController{
    if (!_bookListViewController) {
        _bookListViewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"JZBookrackViewController"];
        
    }
    return _bookListViewController;
}

- (UIViewController<JZDrawerControllerProtocol> *)homeViewController{
    if (!_homeViewController) {
        _homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JZHomeViewController"];

    }
    return _homeViewController;
}

- (UIViewController<JZDrawerControllerProtocol> *)userViewController{
    if (!_userViewController) {
        _userViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JZUserDataViewController"];
    }
    return _userViewController;
}

- (UIViewController<JZDrawerControllerProtocol> *)LoginViewController{
    if (!_LoginViewController) {
        _LoginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JZLoginViewController"];
    }
    return _LoginViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.number = 1;

    // Do any additional setup after loading the view.

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    userStroe *user = [userStroe loadUser];
    if (user) {
        self.userName.text = user.name;
        self.haveUser = YES;
        if (user.imageString) {
            UIImage *userImage = [user Base64StrToUIImage];
            [self.userPortrait setImage:userImage];
        }
        
    }else{
        self.userName.text = @"立即登陆";
        [self.userPortrait setImage:[UIImage imageNamed:@"login_default_icon"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushUser:(id)sender {
    if ([self isRight:0]) {
        [self.drawer close];
    }else{
        if (self.isHaveUser) {
            [self.drawer replaceCenterViewControllerWithViewController:self.userViewController];
            
        }else{
            [self presentViewController:self.LoginViewController animated:YES completion:^{
                
            }];
        }
        self.number = 1;
    }
}
- (IBAction)pushHome:(id)sender {
    if ([self isRight:1]) {
        [self.drawer close];
    }else{
        [self.drawer replaceCenterViewControllerWithViewController:self.homeViewController];
        self.number = 1;
    }
    
}
- (IBAction)pushBookList:(id)sender {
    if ([self isRight:2]) {
        [self.drawer close];
    }else{
        [self.drawer replaceCenterViewControllerWithViewController:self.bookListViewController];
        self.number = 2;
    }

}
- (IBAction)pushSetUp:(id)sender {
}
- (BOOL)isRight:(NSUInteger )index{
    return index==self.number?YES:NO;
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
