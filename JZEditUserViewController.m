//
//  JZEditUserViewController.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZEditUserViewController.h"
#import "JZWildDog.h"
#import "userStroe.h"

@interface JZEditUserViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *userImage;

@end

@implementation JZEditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userStroe *user = [userStroe loadUser];
    if (user) {
        NSData *_decodedImageData   = [[NSData alloc]initWithBase64EncodedString:user.imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
        [self.userImage setBackgroundImage:_decodedImage forState:UIControlStateNormal];
    }else{
        [self.userImage setBackgroundImage:[UIImage imageNamed:@"unLogin-1"] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)editUserImage:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设未开启访问相册权限，现在去开启!"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}
#pragma mark--imagePicker delgate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    [self.userImage setBackgroundImage:image forState:UIControlStateNormal];
    [[JZWildDog WildDog]editUserIamge:image withSuccess:^{
        NSLog(@"成功");
        
    } fail:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
