//
//  JZBooksStore.h
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookViewProtocol <NSObject>

- (NSString *)bookViewId;
- (NSString *)bookViewImageUrl;
- (NSString *)bookViewtitle;
- (NSString *)bookViewaverage;
@optional

- (NSString *)bookViewnumRaters;
- (NSString *)bookViewAuthor;

- (NSString *)bookAuthor;/**< 作者 */
- (NSString *)bookPublisher;/**< 出版社 */
- (NSString *)bookOriginTitle;/**< 原作名 */
- (NSString *)bookTranslator;/**< 翻译人员 */
- (NSString *)bookPages;/**< 页数 */
- (NSString *)bookPrice;/**< 价格 */
- (NSString *)bookPubdate;/**< 出版时间 */
- (NSString *)bookBinding;/**< 版本 */
- (NSString *)bookISBN;


@end

@interface Author : NSObject

@end

@interface Images : NSObject

@property(nonatomic,strong)NSString *small;/**<小图 */
@property(nonatomic,strong)NSString *large;/**<大图 */
@property(nonatomic,strong)NSString *medium;/**<中图 */

@end

@interface tag : NSObject
@property(nonatomic,assign)NSInteger count;/**< 数量 */
@property(nonatomic,strong)NSString *name;/**<名字 */
@property(nonatomic,strong)NSString *title;/**<标题 */
@end

@interface Rating : NSObject
@property(nonatomic,copy)NSString *max;/**< 最大 */
@property(nonatomic,copy)NSString *average;/**< 评价评分 */
@property(nonatomic,copy)NSString *numRaters;/**< 评价人数 */
@end

@interface Book :NSObject<BookViewProtocol>

@property(nonatomic,strong)Rating *rating;/**< 评分数据 */
@property(nonatomic,strong)NSArray *author;/**<作者们 */
@property(nonatomic,strong)NSArray<tag*> *tags;/**<标签集 */
@property(nonatomic,strong)NSString *origin_title;/**<原作名 */
@property(nonatomic,strong)NSString *binding;/**<版本 */
@property(nonatomic,strong)NSString *pubdate;/**<出版时间 */
@property(nonatomic,strong)NSArray *translator;/**<翻译人员 */
@property(nonatomic,strong)NSString *catalog;/**<<#text#> */
@property(nonatomic,strong)NSString *pages;/**<页数 */
@property(nonatomic,strong)Images *images;/**<各种图片 */
@property(nonatomic,strong)NSString *alt;/**<<#text#> */
@property(nonatomic,strong)NSString *id;/**<<#text#> */
@property(nonatomic,strong)NSString *publisher;/**<出版社 */
@property(nonatomic,strong)NSString *isbn10;/**<<#text#> */
@property(nonatomic,strong)NSString *isbn13;/**<<#text#> */
@property(nonatomic,strong)NSString *summary;/**<简介 */
@property(nonatomic,strong)NSString *price;/**<价格 */
@property(nonatomic,copy)NSString *title;/**< 图书名字 */
@property(nonatomic,copy)NSString *image;/**< 图片地址 */
@end

@interface BookData : NSObject<BookViewProtocol>

@property(nonatomic,strong)Book *book;/**< 图书内容数据 */
@property(nonatomic,copy)NSString *bookid;/**< 图书搜索id */

@end



@interface JZBooksStore : NSObject

@property(nonatomic,strong)NSMutableArray<id<BookViewProtocol>> *books;/**< 图书数据模型数组 */


@end

