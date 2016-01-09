//
//  JZBook.h
//  
//
//  Created by Jz on 16/1/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

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
- (NSMutableArray *)bookViewTags;
@end

@class JZRating, JZTag;

NS_ASSUME_NONNULL_BEGIN

@interface JZBook : NSManagedObject<BookViewProtocol>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "JZBook+CoreDataProperties.h"
