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
MJCodingImplementation

@end

@implementation userStroe
MJCodingImplementation

- (NSMutableDictionary *)books{
    if (!_books) {
        _books = [NSMutableDictionary dictionary];
    }
    return _books;
}

+ (instancetype)loadUser{
    userStroe *user = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    return user;
}

- (void)saveUser{
    [NSKeyedArchiver archiveRootObject:self toFile:IWAccountFile];
}




@end
