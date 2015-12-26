//
//  JZTopBookCollectionViewCell.h
//  BiShe
//
//  Created by Jz on 15/12/26.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
@interface JZTopBookCollectionViewCell : UICollectionViewCell

- (void)setBookViewModels:(id<BookViewProtocol>) bookViewModels; /**<  拥有BookViewProtocol的对象 */
@end
