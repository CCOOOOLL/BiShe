//
//  JZTabButton.m
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZTabButton.h"
IB_DESIGNABLE
@interface JZTabButton ()

@end

@implementation JZTabButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        [self.layer setMasksToBounds:YES];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1].CGColor;
        [self.layer setCornerRadius:self.bounds.size.height/2.0];
        [self addTarget:self action:@selector(ChangeBackgroudColor) forControlEvents:UIControlEventTouchUpInside];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:@"tabBg"] forState:UIControlStateSelected];

    };
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer setMasksToBounds:YES];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1].CGColor;
        [self.layer setCornerRadius:self.bounds.size.height/2.0];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self setTitleColor:[UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1] forState:UIControlStateNormal];

    };
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.layer setMasksToBounds:YES];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:52/255.0 green:179/255.0 blue:64/255.0 alpha:1].CGColor;
    [self.layer setCornerRadius:self.bounds.size.height/2.0];
    [self addTarget:self action:@selector(ChangeBackgroudColor) forControlEvents:UIControlEventTouchUpInside];

    
}
- (void)ChangeBackgroudColor{
    self.selected = !self.isSelected;
    self.selected?self.ButtonDidClick(self.titleLabel.text):self.ButtonCanCelClick(self.titleLabel.text);
}
@end
