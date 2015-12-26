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


