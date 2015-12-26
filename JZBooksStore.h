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

@end

@interface Rating : NSObject
@property(nonatomic,copy)NSString *max;/**< 最大 */
@property(nonatomic,copy)NSString *average;/**< 评价评分 */
@property(nonatomic,copy)NSString *numRaters;/**< 评价人数 */
@end

@interface Book :NSObject

@property(nonatomic,strong)Rating *rating;/**< 评分数据 */
@property(nonatomic,copy)NSString *title;/**< 图书名字 */
@property(nonatomic,copy)NSString *image;/**< 图片地址 */
@end

@interface BookData : NSObject<BookViewProtocol>

@property(nonatomic,strong)Book *book;/**< 图书内容数据 */
@property(nonatomic,copy)NSString *bookid;/**< 图书搜索id */

@end



@interface JZBooksStore : NSObject

@property(nonatomic,strong)NSMutableArray<BookData*> *books;/**< 图书数据模型数组 */


@end

