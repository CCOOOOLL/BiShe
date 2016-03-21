//
//  CoreDataHelper.m
//  BiShe
//
//  Created by Jz on 16/1/8.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "CoreDataHelper.h"
#import "JZBook.h"
#import "JZComment.h"
static NSString *const fileName = @"douban.sqlite";

@implementation CoreDataHelper

@synthesize context = _context;
@synthesize model =_model;
@synthesize coordinator = _coordinator;

+ (instancetype)helper{
    static dispatch_once_t once;
    static id obj;
    dispatch_once(&once, ^{
        obj = [[self alloc]init];
    });
    return obj;
}


#pragma mark 懒加载

- (NSManagedObjectModel *)model{
    if (!_model) {
        NSURL *modelURl = [[NSBundle mainBundle]URLForResource:@"douban" withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURl];
    }

    return _model;
}

- (NSPersistentStoreCoordinator *)coordinator{
    if (!_coordinator) {
        _coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
        NSError *error =nil;
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self applicationDocumentsDirectory] options:nil error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    return _coordinator;
}
 
- (NSManagedObjectContext *)context{
    if (!_context) {
        _context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:self.coordinator];
    }
    return _context;
}

#pragma mark -数据操作

- (NSArray<JZComment*> *)getuserBooks{
    NSFetchRequest *resquest = [[NSFetchRequest alloc]initWithEntityName:@"JZComment"];
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:resquest error:&error];
    return array;
}

- (JZBook *)searchDataWihtBookId:(NSString *)bookId{
    NSFetchRequest *resquest = [[NSFetchRequest alloc]initWithEntityName:@"JZBook"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookID=%@",bookId];
    resquest.predicate = predicate;
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:resquest error:&error];
    return array.lastObject;
    
}



- (BOOL)addBook:(JZBook *)book{
    [self.context insertObject:book];
    return YES;
}

- (NSArray<JZComment*>*)searchCommentWihtBookId:(NSString *)bookId{
    NSFetchRequest *resquest = [[NSFetchRequest alloc]initWithEntityName:@"JZComment"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookID=%@",bookId];
    resquest.predicate = predicate;
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:resquest error:&error];
    return array;
    
}

- (BOOL)removeCommentWithBookId:(NSString *)bookId{
    NSArray<JZComment *> *array = [self searchCommentWihtBookId:bookId];
    if (array.count>0) {
            [self.context deleteObject:array.lastObject];
    }
    return YES;
}

- (BOOL)removeAllComment{
    NSFetchRequest *resquest = [[NSFetchRequest alloc]initWithEntityName:@"JZComment"];
    NSArray<JZComment *> *array = [self.context executeFetchRequest:resquest error:nil];
    [array enumerateObjectsUsingBlock:^(JZComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.context deleteObject:obj];
    }];
    return YES;
}

- (BOOL)addComment:(JZComment *)comment{
    NSArray<JZComment *> *array = [self searchCommentWihtBookId:comment.bookID];
    if (array.count==0) {

        [self.context insertObject:comment];
    }else{
        JZComment *obj = array.lastObject;
        obj = comment;
    }
    return YES;
    
}
- (void)saveContext{
    NSError *error = nil;
    if ([self.context hasChanges]&&![self.context save:&error]) {
        NSLog(@"保存数据错误%@",error);
    }else
        NSLog(@"保存成功");
}



#pragma mark -地址


- (NSURL *)applicationDocumentsDirectory{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    return [[NSURL fileURLWithPath:path] URLByAppendingPathComponent:fileName];
}

@end
