//
//  JZButton.m
//  BiShe
//
//  Created by Jz on 15/12/27.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZButton.h"

IB_DESIGNABLE
@implementation JZButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setMasksToBounds:YES];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:1 green:204/255.0 blue:102/255.0 alpha:1].CGColor;
    [self.layer setCornerRadius:5.0];
    
}

@end
