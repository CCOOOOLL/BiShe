//
//  JZTag+CoreDataProperties.h
//  
//
//  Created by Jz on 16/1/9.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JZTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *count;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) JZBook *book;

@end

NS_ASSUME_NONNULL_END
