//
//  JZComment+CoreDataProperties.h
//  BiShe
//
//  Created by Jz on 16/1/9.
//  Copyright © 2016年 Jz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JZComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *average;
@property (nullable, nonatomic, retain) NSString *bookid;
@property (nullable, nonatomic, retain) NSNumber *gradeType;
@property (nullable, nonatomic, retain) NSString *longContent;
@property (nullable, nonatomic, retain) NSString *shortContent;
@property (nullable, nonatomic, retain) NSString *autoId;
@property (nullable, nonatomic, retain) id tags;
@property (nullable, nonatomic, retain) JZUser *user;

@end

NS_ASSUME_NONNULL_END
