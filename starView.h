//
//  startView.h
//  DouBan
//
//  Created by 李健章 on 15/12/14.
//  Copyright © 2015年 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface starView : UIView

@property(nonatomic,assign)CGFloat maxStar;
@property(nonatomic, strong)NSNumber *showStar;
@property(nonatomic, strong)UIColor *emptyColor;
@property(nonatomic, strong)UIColor *fullColor;
@property(nonatomic,assign)IBInspectable CGFloat starSize;

@end
