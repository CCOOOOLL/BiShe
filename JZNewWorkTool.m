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


@interface JZNewWorkTool()



@end


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


@end
