//
//  JZWildDog.h
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBooksStore.h"
#import "Wilddog.h"
#import <UIKit/UIKit.h>

@class JZShortCommentsStore;
@class JZShortComment;
@interface JZWildDog : NSObject
+ (instancetype)WildDog;

- (void)createUser:(NSString *)email password:(NSString *)password name:(NSString *)name withSuccess:(void (^)()) suceess fail:(void(^)(NSError *error)) fail;

- (void)loginUser:(NSString *)email password:(NSString *)password WithBlock:(void(^)(NSError *error, WAuthData *authData) )block;

- (void)editUserIamge:(UIImage *)image withSuccess:(void (^)()) suceess fail:(void(^)(NSError *error)) fail;
- (void)addBookWithType:(GradeType)type bookId:(NSString *)bookId tags:(NSArray *)tags average:(NSInteger)average content:(NSString *)content withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail;

/**
 *  加载图书
 */
- (void)getBookWithBookId:(NSString *)bookId withSuccess:(void (^)(Book* book))success fail:(void(^)(NSError *error)) fail;
/**
 *  添加图书
 *
 */
- (void)addBook:(Book *)book withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail;

- (void)getGradeWihtBookId:(NSString *)bookId withSuccess:(void (^)(JZShortComment *Comment))suceess fail:(void(^)()) fail;

- (void)WirteBookGradeWihtBookId:(NSString *)bookId range:(NSInteger)range tags:(NSArray *)tags content:(NSString *)content withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail;

- (void)updeBookShortCommentWithBookId:(NSString *)bookId page:(NSInteger)page  withSuccess:(void (^)(JZShortCommentsStore *store))suceess fail:(void(^)(NSError *error)) fail;
@end
