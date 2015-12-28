//
//  JZBooksStore.m
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZBooksStore.h"
#import "MJExtension.h"



@implementation Rating

MJCodingImplementation

@end

@implementation Book

MJCodingImplementation

- (NSString *)bookViewId{
    return [self.id copy];
}
- (NSString *)bookViewImageUrl{
    return [self.image copy];
}
- (NSString *)bookViewtitle{
    return [self.title copy];
}
- (NSString *)bookViewaverage{
    return [self.rating.average copy];
}

- (NSString *)bookViewnumRaters{
    return [self.rating.numRaters copy];
}
- (NSString *)bookViewAuthor{
    __block NSString *author = @"";
    [self.author enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        author = [NSString stringWithFormat:@"%@ %@",author,obj];
    }];
    author = [NSString stringWithFormat:@"%@/%@",author,self.publisher];
    author = [NSString stringWithFormat:@"%@/%@",author,self.pubdate];
    return author;
}

@end


@implementation BookData
MJCodingImplementation

- (NSString *)bookViewId{
    return [self.bookid copy];
}
- (NSString *)bookViewImageUrl{
    return [self.book.image copy];
}
- (NSString *)bookViewtitle{
    return [self.book.title copy];
}
- (NSString *)bookViewaverage{
    return [self.book.rating.average copy];
}



@end

@implementation JZBooksStore

MJCodingImplementation

@end

