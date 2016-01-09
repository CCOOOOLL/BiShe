//
//  JZTagsViewCOntroller.h
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"

@protocol JZTagsViewCOntrollerDeleage <NSObject>

- (void)tableViewWihtHegiht:(CGFloat )heght;
- (void)addSelectTag:(NSString *)tag;
- (void)removeSelectTag:(NSString *)tag;

@end

@interface JZTagsViewCOntroller : UIViewController
@property(nonatomic,strong)NSMutableArray<tag *> *tags;/**<<#text#> */
@property(nonatomic,weak)id<JZTagsViewCOntrollerDeleage> tagsViewDeleage;/**<<#text#> */
@property(nonatomic,strong)NSSet *commentTags;
@end
