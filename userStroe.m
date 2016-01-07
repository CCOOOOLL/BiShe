//
//  userStroe.m
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "userStroe.h"
#import "MJExtension.h"
#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]

@implementation book



@end

@implementation userStroe
MJCodingImplementation

+ (instancetype)loadUser{
    userStroe *user = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    return user;
}

- (void)saveUser{
    [NSKeyedArchiver archiveRootObject:self toFile:IWAccountFile];
}




@end
