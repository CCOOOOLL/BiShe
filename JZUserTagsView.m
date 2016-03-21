//
//  JZUserTagsView.m
//  BiShe
//
//  Created by Jz on 16/1/15.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZUserTagsView.h"
#import "JZTabButton.h"
#import "JZTag.h"
#import "JZBook.h"
#import "JZComment.h"

@interface JZUserTagsView ()

@property(nonatomic,strong)NSMutableArray<JZTabButton *> *tagButtonsArray;
@property(nonatomic,weak)JZTabButton *selectButton;

@end

@implementation JZUserTagsView

- (NSMutableArray<JZTabButton *> *)tagButtonsArray{
    if (!_tagButtonsArray) {
        _tagButtonsArray = [NSMutableArray array];
    }
    return _tagButtonsArray;
}

- (void)setTagsArray:(NSMutableArray *)tagsArray{
    _tagsArray = tagsArray;
    JZTabButton *button = [self addTagButtonWithName:@"全部"];
    [button ChangeBackgroudColor];
    self.selectButton = button;
    for (JZComment *comment in tagsArray) {
        for (NSString *str in comment.tags) {
             [self addTagButtonWithName:str];
        }
    }
}


- (JZTabButton *)addTagButtonWithName:(NSString *)name{
    CGRect rect = self.tagButtonsArray.count<1?CGRectMake(0, 8, 0, 25):self.tagButtonsArray.lastObject.frame;
    CGFloat width         = [name boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8]} context:nil].size.width+25;
    
    if (CGRectGetMaxX(rect)+width+8>self.bounds.size.width) {
        rect.origin.x = 8;
        rect.origin.y += 34;
    }else{
        rect.origin.x = CGRectGetMaxX(rect)+8;
    }
    rect.size.width = width;
    NSLog(@"%@",[NSValue valueWithCGRect:rect]);
    JZTabButton *button = [[JZTabButton alloc]initWithFrame:rect title:name];
    [self.tagButtonsArray addObject:button];
    __weak typeof(self)weekSelf = self;

    __weak JZTabButton *weakbutton = button;
    button.ButtonDidClick = ^(NSString *tag){
        [weekSelf.tagsViewDeleage searchDataWithTagName:tag];
        weekSelf.selectButton.selected = NO;
        weekSelf.selectButton.userInteractionEnabled = YES;
        weakbutton.selected = YES;
        weekSelf.selectButton = weakbutton;
        weakbutton.userInteractionEnabled = NO;
    };

    [self addSubview:button];
    
    return button;
    
}

@end
