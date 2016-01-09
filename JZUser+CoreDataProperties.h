//
//  JZUser+CoreDataProperties.h
//  
//
//  Created by Jz on 16/1/9.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JZUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<JZComment *> *shortComments;

@end

@interface JZUser (CoreDataGeneratedAccessors)

- (void)addShortCommentsObject:(JZComment *)value;
- (void)removeShortCommentsObject:(JZComment *)value;
- (void)addShortComments:(NSSet<JZComment *> *)values;
- (void)removeShortComments:(NSSet<JZComment *> *)values;

@end

NS_ASSUME_NONNULL_END
