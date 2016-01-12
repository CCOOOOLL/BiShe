//
//  JZroundView.m
//  BiShe
//
//  Created by Jz on 16/1/11.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZroundView.h"

@implementation JZroundView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:self.bounds.size.height/2.0];
}
@end
