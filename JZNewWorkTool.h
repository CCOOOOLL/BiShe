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
typedef void(^success)(JZBooksStore* booksStore);
typedef void(^block)();
@interface JZNewWorkTool : NSObject

- (void)dataWithCategory:(NSNumber*)number start:(NSNumber*)start end:(NSNumber*)end success:(success) success;
+(instancetype)workTool;



@property(nonatomic,strong)AFHTTPSessionManager *mymanager;
@end
