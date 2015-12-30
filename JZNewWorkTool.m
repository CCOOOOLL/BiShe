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

@interface JZNewWorkTool()



@end

static NSString *const shortComments = @"http://book.douban.com/subject/%@/comments?p=%ld";

@implementation JZNewWorkTool

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
        _mymanager.operationQueue.maxConcurrentOperationCount = 1;
        
        

        
    }
    return _mymanager;
}


   


- (void)dataWithCategory:(NSNumber*)number start:(NSNumber*)start end:(NSNumber*)end success:(success) success{
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
            NSLog(@"%@",error);
    }];
    
}


- (void)dataWithBookName:(NSString *)name start:(NSNumber*)start count:(NSNumber*)count success:(success)success{
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
        NSLog(@"%@",error);
    }];
}

- (void)dataWithBookid:(NSString* )number  success:(success) success{
    NSString *url = [NSString stringWithFormat:@"http://api.douban.com/v2/book/%@",number];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Book mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       Book *book = [Book mj_objectWithKeyValues:responseObject];
        success(book);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)datawithISBN:(NSString *)number success:(success)success{
    NSString *url = [NSString stringWithFormat:@"http://api.douban.com/v2/book/isbn/%@",number];
    //    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Book mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Book *book = [Book mj_objectWithKeyValues:responseObject];
        success(book);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)datawithshortComments:(NSString *)number page:(NSInteger)page success:(success)success{
    NSString *url = [NSString stringWithFormat:shortComments,number,page];
    //    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.mymanager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//
        JZShortCommentsStore *shortComents =  [[JZShortCommentsStore alloc]initWithHtml:result];

        success(shortComents);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)endRequest{
    [self.mymanager.operationQueue cancelAllOperations];
}

@end
