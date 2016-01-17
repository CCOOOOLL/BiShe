//
//  JZBook.m
//  
//
//  Created by Jz on 16/1/9.
//
//

#import "JZBook.h"
#import "JZRating.h"
#import "JZTag.h"

@implementation JZBook

// Insert code here to add functionality to your managed object subclass

-(NSSet *)bookViewTags{
    return self.tags;
}

- (NSString *)bookViewId{
    return [self.bookID copy];
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

- (NSString *)bookAuthor{
    NSString *author = @"";
    for (NSString *authorname in self.author) {
        author = [NSString stringWithFormat:@"%@ %@",author,authorname];
    }
    return [author copy];
}
- (NSString *)bookPublisher{
    return [self.publisher copy];
}
- (NSString *)bookOriginTitle{
    return [self.origin_title copy];
}
- (NSString *)bookTranslator{
    NSString *translator = @"";
    for (NSString *translatorname in self.translator) {
        translator = [NSString stringWithFormat:@"%@ %@",translator,translatorname];
    }
    return [translator copy];
}
- (NSString *)bookPages{
    return [self.pages copy];
}
- (NSString *)bookPrice{
    return [self.price copy];
}
- (NSString *)bookPubdate{
    return [self.pubdate copy];
}
- (NSString *)bookBinding{
    return [self.binding copy];
}
- (NSString *)bookISBN{
    if (self.isbn10) {
        return [self.isbn10 copy];
    }else{
        return [self.isbn13 copy];
    }
    
}

//- (void)addTagsObject:(JZTag *)value{
//    NSMutableSet *set = (NSMutableSet *)self.tags;
//    [set addObject:value];
//    self.tags = set;
//}
@end
