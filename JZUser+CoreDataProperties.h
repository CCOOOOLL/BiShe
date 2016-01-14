//
//  JZUser+CoreDataProperties.h
//  BiShe
//
//  Created by Jz on 16/1/13.
//  Copyright © 2016年 Jz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JZUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<JZComment *> *shortComments;
@property (nullable, nonatomic, retain) NSSet<JZBook *> *books;

@end

@interface JZUser (CoreDataGeneratedAccessors)

- (void)addShortCommentsObject:(JZComment *)value;
- (void)removeShortCommentsObject:(JZComment *)value;
- (void)addShortComments:(NSSet<JZComment *> *)values;
- (void)removeShortComments:(NSSet<JZComment *> *)values;

- (void)addBooksObject:(JZBook *)value;
- (void)removeBooksObject:(JZBook *)value;
- (void)addBooks:(NSSet<JZBook *> *)values;
- (void)removeBooks:(NSSet<JZBook *> *)values;

@end

NS_ASSUME_NONNULL_END
