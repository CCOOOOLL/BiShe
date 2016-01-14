//
//  CoreDataHelper.h
//  BiShe
//
//  Created by Jz on 16/1/8.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class JZBook;
@class JZComment;
@interface CoreDataHelper : NSObject

@property(nonatomic,strong,readonly)NSManagedObjectContext *context;/**<<#text#> */
@property(nonatomic,strong,readonly)NSManagedObjectModel *model;/**<<#text#> */
@property(nonatomic,strong,readonly)NSPersistentStoreCoordinator *coordinator;/**<<#text#> */

+ (instancetype)helper;

- (void)saveContext;

- (JZBook *)searchDataWihtBookId:(NSString *)bookId;
- (NSArray<JZComment*> *)searchCommentWihtBookId:(NSString *)bookId;
- (BOOL)addComment:(JZComment *)Comment;
- (BOOL)addBook:(JZBook *)book;
- (BOOL)removeCommentWithBookId:(NSString *)bookId;
- (NSArray<JZBook*> *)getuserBooks;
@end
