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

@class book;
@class JZComment;
@class JZShortCommentsStore;
@class JZShortComment;
@interface JZWildDog : NSObject
+ (instancetype)WildDog;

- (void)createUser:(NSString *)email password:(NSString *)password name:(NSString *)name withSuccess:(void (^)()) suceess fail:(void(^)(NSError *error)) fail;

- (void)loginUser:(NSString *)email password:(NSString *)password WithBlock:(void(^)(NSError *error, WAuthData *authData) )block fail:(void(^)(NSError *error)) fail;

- (void)editUserIamge:(UIImage *)image withSuccess:(void (^)()) suceess fail:(void(^)(NSError *error)) fail;
/**
 *  添加评论
 */
- (void)addBookWithType:(GradeType)type bookId:(NSString *)bookId tags:(NSArray *)tags average:(NSInteger)average content:(NSString *)content withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail;
//- (void)addComment:(JZComment *)commnet andTags:(NSArray *)tags withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail;

- (void)getGradeWihtBookId:(NSString *)bookId withSuccess:(void (^)(JZComment *data))suceess fail:(void(^)()) fail;

- (void)getUserBookWithSuccess:(void (^)(NSMutableArray *array)) success andFail:(void(^)(NSError *error))fail;
- (void)observeUserBook;
@end
