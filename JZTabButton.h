//
//  JZTabButton.h
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
typedef void(^tagButtonDidClick)(NSString *tag);
typedef void(^tagButtonCanCelClick)(NSString *tag);
@interface JZTabButton : UIButton
@property(nonatomic,copy) tagButtonDidClick ButtonDidClick;
@property(nonatomic,copy) tagButtonCanCelClick ButtonCanCelClick;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)ChangeBackgroudColor;
- (void)setTitleFont:(CGFloat)size;
@end
