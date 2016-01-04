//
//  JZTabLabelCell.m
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZTabLabelCell.h"
#import "JZTabButton.h"

@interface JZTabLabelCell ()
@property (weak, nonatomic) IBOutlet JZTabButton *tagButton;

@end

@implementation JZTabLabelCell

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.tagButton addTarget:self action:@selector(tagButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tagButtonDidClick{
    !self.tagButton.selected?self.ButtonDidClick(self.tagButton.titleLabel.text):self.ButtonCanCelClick(self.tagButton.titleLabel.text);
}

- (void)setTagTitle:(NSString *)tagTitle{
    _tagTitle = tagTitle;

    [self.tagButton setTitle:tagTitle forState:UIControlStateNormal];
    [self.tagButton setTitle:tagTitle forState:UIControlStateSelected];

}
@end
