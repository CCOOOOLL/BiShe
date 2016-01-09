//
//  JZTagsViewCOntroller.m
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZTagsViewCOntroller.h"
#import "JZTabButton.h"
#import "JZTag.h"

@interface JZTagsViewCOntroller ()
@property(nonatomic,strong)NSMutableSet *Selecttags;
@property(nonatomic,strong)NSMutableArray<JZTabButton*> *buttons;/**<<#text#> */
@property(nonatomic,assign)CGRect *rect;
@end



@implementation JZTagsViewCOntroller

- (NSMutableArray<JZTabButton *> *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return  _buttons;
}
- (void)setTags:(NSMutableArray<tag *> *)tags{
    _tags = tags;
    [self setAllTag];
    [self setSelectTag];
}
- (NSMutableSet *)Selecttags{
    if (!_Selecttags) {
        _Selecttags = [NSMutableSet set];
    }
    return _Selecttags;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self changeHeight];
}
- (void)changeHeight{
    if ([self.tagsViewDeleage respondsToSelector:@selector(tableViewWihtHegiht:)]) {
        CGRect rectInTableView = self.buttons.lastObject.frame;
        [self.tagsViewDeleage tableViewWihtHegiht:CGRectGetMaxY(rectInTableView)];
    }
}

- (void)setSelectTag{

    for (NSString *str in self.commentTags) {
        BOOL isHave = NO;
        for (JZTabButton *button in self.buttons) {
            if ([button.titleLabel.text isEqualToString:str]) {
                [button ChangeBackgroudColor];
                isHave = YES;
            }
        }
        if (!isHave) {
            [[self addTagButtonWithName:str isFist:NO] ChangeBackgroudColor];
        }
        
        
    }
    
}

- (void) setAllTag{

    JZTabButton *button = [[JZTabButton alloc]initWithFrame:CGRectMake(8, 8,150, 30)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"添加新标签" forState:UIControlStateNormal];
    [self.buttons addObject:button];
    for (tag *tag in self.tags) {
       [self addTagButtonWithName:tag.title isFist:NO];
    }
}
- (JZTabButton *)addTagButtonWithName:(NSString *)name isFist:(BOOL)isFist{
    CGRect rect = self.buttons.count<2?CGRectMake(0, 8, 0, 30):self.buttons[self.buttons.count-2].frame;
    CGFloat width         = [name boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width+25;
    
    
    if (CGRectGetMaxX(rect)+width+8>self.view.bounds.size.width) {
        rect.origin.x = 8;
        rect.origin.y += 34;
    }else{
        rect.origin.x = CGRectGetMaxX(rect)+8;
    }
    rect.size.width = width;
    JZTabButton *button = [[JZTabButton alloc]initWithFrame:rect title:name];
    [self.view addSubview:button];
    __weak typeof(self)weekSelf = self;
    button.ButtonCanCelClick = ^(NSString *tag){
        
        [weekSelf.tagsViewDeleage removeSelectTag:tag];
    };
    button.ButtonDidClick = ^(NSString *tag){
        [weekSelf.tagsViewDeleage addSelectTag:tag];
    };
    isFist?[self.buttons addObject:button]:[self.buttons insertObject:button atIndex:self.buttons.count-1];
    if (!isFist) {
        CGFloat x = CGRectGetMaxX(rect)+8;
        CGFloat y = rect.origin.y;
        if (CGRectGetMaxX(rect)+CGRectGetWidth(self.buttons.lastObject.frame)+8>self.view.bounds.size.width) {
            x = 8;
            y+= 34;
        }
         self.buttons.lastObject.frame = CGRectMake(x, y, self.buttons.lastObject.frame.size.width, 30);
    }


    return button;
    
}
- (void)addTag{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"+添加标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *srt       = ac.textFields.firstObject.text;
        JZTabButton *button =  [self addTagButtonWithName:srt isFist:NO];
        [button ChangeBackgroudColor];
        [self changeHeight];
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"你想添加的标签";
        [textField becomeFirstResponder];
        textField.borderStyle = UITextBorderStyleNone;
        
    }];
    [ac addAction:aciton];
    [ac addAction:other];
    
    [self presentViewController:ac animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
