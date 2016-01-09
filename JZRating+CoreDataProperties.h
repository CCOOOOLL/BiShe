//
//  JZRating+CoreDataProperties.h
//  
//
//  Created by Jz on 16/1/9.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JZRating.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZRating (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *average;
@property (nullable, nonatomic, retain) NSString *max;
@property (nullable, nonatomic, retain) NSString *numRaters;
@property (nullable, nonatomic, retain) JZBook *book;

@end

NS_ASSUME_NONNULL_END
