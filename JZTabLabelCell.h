//
//  JZTabLabelCell.h
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tagButtonDidClick)(NSString *tag);
typedef void(^tagButtonCanCelClick)(NSString *tag);
@interface JZTabLabelCell : UICollectionViewCell

@property(nonatomic,copy) tagButtonDidClick ButtonDidClick;
@property(nonatomic,copy) tagButtonCanCelClick ButtonCanCelClick;
@property(nonatomic,strong)NSString *tagTitle;
@end
