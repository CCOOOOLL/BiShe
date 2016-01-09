//
//  JZUserTableViewController.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZUserTableViewController.h"
#import "JZLoginViewController.h"
#import "userStroe.h"

@interface JZUserTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *ZDcount;
@property (weak, nonatomic) IBOutlet UILabel *DGcount;
@property (weak, nonatomic) IBOutlet UILabel *XDcount;

@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UITableViewCell *quitUser;

@property (nonatomic, assign, getter=isHaveUser)BOOL haveUser;
@end

@implementation JZUserTableViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    userStroe *user = [userStroe loadUser];
    if (user) {
        self.userName.text = user.name;
        self.haveUser = YES;
        self.edit.enabled =YES;
        if (user.imageString) {
            NSData *imageData  = [[NSData alloc]initWithBase64EncodedString:user.imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *userImage = [UIImage imageWithData:imageData];
            [self.userImage setImage:userImage];
        }

    }else{
        self.edit.enabled =NO;
        self.userName.text = @"立即登陆";
        [self.userImage setImage:[UIImage imageNamed:@"unLogin-1"]];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (IBAction)pushLoginVIew:(id)sender {
    if (!self.isHaveUser) {
        JZLoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"JZLoginViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}




@end
