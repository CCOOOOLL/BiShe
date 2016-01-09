//
//  JZBook+CoreDataProperties.h
//  BiShe
//
//  Created by Jz on 16/1/9.
//  Copyright © 2016年 Jz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JZBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZBook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *binding;
@property (nullable, nonatomic, retain) NSString *bookID;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *isbn10;
@property (nullable, nonatomic, retain) NSString *isbn13;
@property (nullable, nonatomic, retain) NSString *origin_title;
@property (nullable, nonatomic, retain) NSString *pages;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *pubdate;
@property (nullable, nonatomic, retain) NSString *publisher;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) id translator;
@property (nullable, nonatomic, retain) id author;
@property (nullable, nonatomic, retain) JZRating *rating;
@property (nullable, nonatomic, retain) NSSet<JZTag *> *tags;

@end

@interface JZBook (CoreDataGeneratedAccessors)

- (void)addTagsObject:(JZTag *)value;
- (void)removeTagsObject:(JZTag *)value;
- (void)addTags:(NSSet<JZTag *> *)values;
- (void)removeTags:(NSSet<JZTag *> *)values;

@end

NS_ASSUME_NONNULL_END
