//
//  JZGradeStar.h
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface JZGradeStar : UIView
@property(nonatomic,assign)NSInteger grade;/**< 评分 */
- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star;

@end
