//
//  JZImageView.m
//  BiShe
//
//  Created by Jz on 16/1/11.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZImageView.h"

@implementation JZImageView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setMasksToBounds:YES];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1].CGColor;
    [self.layer setCornerRadius:self.bounds.size.height/2.0];
}

- (void)setRadius:(CGFloat)Radius{
    [self.layer setCornerRadius:Radius];
}
@end
