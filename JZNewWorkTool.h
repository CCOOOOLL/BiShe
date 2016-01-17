//
//  JZNewWorkTool.h
//  BiShe
//
//  Created by Jz on 15/12/23.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JZBooksStore;
@class AFHTTPSessionManager;
typedef void(^Jz_success)(id obj);
typedef void(^JZ_failure)(id obj);
typedef void(^block)();
@interface JZNewWorkTool : NSObject
/**
 *  单例
 */
+(instancetype)workTool;
/**
 *  加载top图书数据
 *
 *  @param number  图书类别
 *  @param start   起始
 *  @param end     结束
 *  @param success 成功代码块
 */

+ (void)dataWithCategory:(NSNumber*)number start:(NSNumber*)start end:(NSNumber*)end success:(Jz_success) success fail:(void(^)(NSError *error)) fail;

- (void)dataWithCategory:(NSNumber*)number start:(NSNumber*)start end:(NSNumber*)end success:(Jz_success) success fail:(void(^)(NSError *error)) fail;

- (void)dataWithBookName:(NSString *)name start:(NSNumber*)start count:(NSNumber*)count success:(Jz_success) success fail:(void(^)(NSError *error)) fail;


- (void)dataWithBookid:(NSString* )number  success:(Jz_success) success fail:(void(^)(NSError *error)) fail;

- (void)datawithISBN:(NSString *)number success:(Jz_success)success fail:(void(^)(NSError *error)) fail;

- (void)datawithshortComments:(NSString *)number page:(NSInteger)page success:(Jz_success)success fail:(void(^)(NSError *error)) fail;

- (void)datawithComments:(NSString *)number page:(NSInteger)page success:(Jz_success)success fail:(void(^)(NSError *error)) fail;


- (void)datawithCommentContentUrl:(NSString *)url page:(NSInteger)page success:(Jz_success)success fail:(void(^)(NSError *error)) fail;

- (void)tagsDataWihtBookId:(NSString *)bookId success:(Jz_success)success fail:(void(^)(NSError *error)) fail;

- (void)endRequest;

@property(nonatomic,strong)AFHTTPSessionManager *mymanager;
@end
