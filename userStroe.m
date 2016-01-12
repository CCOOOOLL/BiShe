//
//  userStroe.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "userStroe.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>
#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]

@implementation book
MJCodingImplementation

@end

@implementation userStroe
MJCodingImplementation

+ (void)removeUser{
    NSError *error;
    if (![[[NSFileManager alloc]init] removeItemAtPath:IWAccountFile error:&error]) {
        NSLog(@"%@",error);
    } ;
    
}
+ (instancetype)loadUser{
    userStroe *user = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    return user;
}


- (NSMutableDictionary *)books{
    if (!_books) {
        _books = [NSMutableDictionary dictionary];
    }
    return _books;
}


- (void)saveUser{
    [NSKeyedArchiver archiveRootObject:self toFile:IWAccountFile];
}

-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.imageString = encodedImageStr;
    return encodedImageStr;
}

-(UIImage *)Base64StrToUIImage
{
    NSData *_decodedImageData   = [[NSData alloc]initWithBase64EncodedString:self.imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}



@end
