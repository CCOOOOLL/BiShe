//
//  JZUserTagsView.h
//  BiShe
//
//  Created by Jz on 16/1/15.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZUserTagsViewDeleage <NSObject>

- (void)tableViewWihtHegiht:(CGFloat )heght;
- (void)addSelectTag:(NSString *)tag;
- (void)removeSelectTag:(NSString *)tag;

- (void)searchDataWithTagName:(NSString *)tagName;

@end

@interface JZUserTagsView : UIView

@property (nonatomic,strong)NSMutableArray *tagsArray;
@property(nonatomic,weak)id<JZUserTagsViewDeleage> tagsViewDeleage;


@end
