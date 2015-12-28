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
typedef void(^success)(id obj);
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
- (void)dataWithCategory:(NSNumber*)number start:(NSNumber*)start end:(NSNumber*)end success:(success) success;

- (void)dataWithBookName:(NSString *)name start:(NSNumber*)start count:(NSNumber*)count success:(success) success;


- (void)dataWithBookid:(NSString* )number  success:(success) success;

- (void)endRequest;

@property(nonatomic,strong)AFHTTPSessionManager *mymanager;
@end
