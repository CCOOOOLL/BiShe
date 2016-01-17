//
//  JZNewWorkTool.m
//  BiShe
//
//  Created by Jz on 15/12/23.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZNewWorkTool.h"
#import "AFNetworking.h"
#import "JZBooksStore.h"
#import "MJExtension.h"
#import "JZShortCommentsStore.h"
#import "CoreDataHelper.h"
#import "JZBook.h"
#import "JZTag.h"
@interface JZNewWorkTool()

@property(nonatomic,strong)CoreDataHelper *helper;

@end

static NSString *const shortComments = @"http://book.douban.com/subject/%@/comments?p=%ld";/**< 短评地址 */

static NSString *const Comments = @"http://book.douban.com/subject/%@/reviews?p=%ld";/**< 书评地址 */

static NSString *const tagsData = @"http://api.douban.com/v2/book/%@/tags";/**< 标签数据 */

@implementation JZNewWorkTool


- (CoreDataHelper *)helper{
    if (!_helper) {
        _helper = [CoreDataHelper helper];
    }
    return _helper;
}

+(instancetype)workTool{
    static id work = nil;
    static dispatch_once_t onet;
    dispatch_once(&onet, ^{
        work = [[self alloc]init];
    });
    return work;
}

- (AFHTTPSessionManager *)mymanager{
    if (!_mymanager) {
        _mymanager    = [AFHTTPSessionManager manager];
        _mymanager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _mymanager.operationQueue.maxConcurrentOperationCount = 3;
    }
    return _mymanager;
}

- (void)dataWithCategory:(NSNumber*)number start:(NSNumber*)start end:(NSNumber*)end success:(Jz_success) success fail:(void(^)(NSError *error)) fail{
    NSString *url = [NSString stringWithFormat:@"http://topbook.zconly.com/v1/top/category/%@/books?start=%@&count=%@",number,start,end];
    

    [JZBooksStore mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"books" : @"BookData",
                 };
    }];
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


        JZBooksStore *booksStore = [JZBooksStore mj_objectWithKeyValues:responseObject];

        success(booksStore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    
}
+ (void)dataWithCategory:(NSNumber*)number start:(NSNumber*)start end:(NSNumber*)end success:(Jz_success) success fail:(void(^)(NSError *error)) fail{
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"http://topbook.zconly.com/v1/top/category/%@/books?start=%@&count=%@",number,start,end];
    
    
    [JZBooksStore mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"books" : @"BookData",
                 };
    }];
    NSLog(@"%@",url);
    [manage GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        JZBooksStore *booksStore = [JZBooksStore mj_objectWithKeyValues:responseObject];
        
        success(booksStore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    
}
/**
 *  搜索图书名
 */
- (void)dataWithBookName:(NSString *)name start:(NSNumber*)start count:(NSNumber*)count success:(Jz_success)success fail:(void(^)(NSError *error)) fail{
    NSString *url = [NSString stringWithFormat:@"http://api.douban.com/v2/book/search?q='%@'&start=%@&count=%@",name,start,count];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [JZBooksStore mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"books" : @"Book",
                 };
    }];
    [Book mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JZBooksStore *booksStore = [JZBooksStore mj_objectWithKeyValues:responseObject];
        success(booksStore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}
/**
 *  搜索图书id
 */
- (void)dataWithBookid:(NSString* )number  success:(Jz_success) success fail:(void(^)(NSError *error)) fail{
    
    JZBook *book = [self.helper searchDataWihtBookId:number];
    if (book.summary) {
        success(book);
        NSLog(@"%@",[book.tags anyObject]);
    }else{
        NSString *url = [NSString stringWithFormat:@"http://api.douban.com/v2/book/%@",number];
        [JZBook mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"bookID":@"id"
                     };
        }];
        [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            JZBook *obj = [JZBook mj_objectWithKeyValues:responseObject context:self.helper.context];
            [self.helper addBook:obj]; 
            success(obj);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        }];
    }


}
/**
 *  搜索ISBN
 *
 */
- (void)datawithISBN:(NSString *)number success:(Jz_success)success fail:(void(^)(NSError *error)) fail{
    NSString *url = [NSString stringWithFormat:@"http://api.douban.com/v2/book/isbn/%@",number];
    [Book mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Book *book = [Book mj_objectWithKeyValues:responseObject];

        success(book);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}
/**
 *  获取短评
 *
 *  @param number  <#number description#>
 *  @param page    <#page description#>
 *  @param success <#success description#>
 */
- (void)datawithshortComments:(NSString *)number page:(NSInteger)page success:(Jz_success)success fail:(void(^)(NSError *error)) fail{
    NSString *url = [NSString stringWithFormat:shortComments,number,page];
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//
        JZShortCommentsStore *shortComents =  [[JZShortCommentsStore alloc]initShortCommentWithHtml:result];

        success(shortComents);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);

    }];
}
/**
 *  获取书评
 *
 *  @param number  <#number description#>
 *  @param page    <#page description#>
 *  @param success <#success description#>
 */
- (void)datawithComments:(NSString *)number page:(NSInteger)page success:(Jz_success)success fail:(void(^)(NSError *error)) fail{
    NSString *url = [NSString stringWithFormat:Comments,number,page];
    //    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //
        JZShortCommentsStore *shortComents =  [[JZShortCommentsStore alloc]initCommentWithHtml:result];
        
        success(shortComents);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);

    }];
}
/**
 *  获取书评内容
 *
 *  @param url     <#url description#>
 *  @param page    <#page description#>
 *  @param success <#success description#>
 */
- (void)datawithCommentContentUrl:(NSString *)url page:(NSInteger)page success:(Jz_success)success fail:(void(^)(NSError *error)) fail{
    NSString *start = [NSString stringWithFormat:@"%ld",page*100];
//    NSDictionary *parametes = @{@"start":start};
     NSString *urlpath = [NSString stringWithFormat:@"%@?start=%@",url,start];
    [self.mymanager GET:urlpath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        JZShortComment *comment = [[JZShortComment alloc]initWithContent:result];
        success(comment);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);

    }];

}
/**
 *  获取tags
 */
- (void)tagsDataWihtBookId:(NSString *)bookId success:(Jz_success)success fail:(void(^)(NSError *error)) fail{
     JZBook *book = [self.helper searchDataWihtBookId:bookId];
//    if (book.tags.count>0) {
//        success(book.tags);
//        return;
//    }
    NSString *url = [NSString stringWithFormat:tagsData,bookId];
    
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [Book mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"tags" : @"tag",
                     };
        }];
       
        Book *booksStore = [Book mj_objectWithKeyValues:responseObject];
        success(booksStore.tags);
        for (tag *obj in booksStore.tags) {
            JZTag *tag =   [NSEntityDescription insertNewObjectForEntityForName:@"JZTag" inManagedObjectContext:self.helper.context];
            tag.title = obj.title;
            [book addTagsObject:tag];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);

    }];
}
- (void)endRequest{
    [self.mymanager.operationQueue cancelAllOperations];
}

@end
