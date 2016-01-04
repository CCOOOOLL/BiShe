//
//  JZTagsViewCOntroller.m
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZTagsViewCOntroller.h"
#import "JZTabButton.h"

@interface JZTagsViewCOntroller ()
@property(nonatomic,strong)NSMutableSet *Selecttags;
@property(nonatomic,strong)NSMutableArray<JZTabButton*> *buttons;/**<<#text#> */
@property(nonatomic,assign)CGRect *rect;
@end



@implementation JZTagsViewCOntroller

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

- (void)setDataWithTags{
    self.Selecttags = [NSMutableSet set];
    CGFloat const ViewW = self.view.bounds.size.width;

    CGFloat x = 8;
    CGFloat y = 8;
    CGFloat h = 30;
    NSInteger index = 0;
    for (tag *obj in self.tags) {

        CGRect rect = [obj.title boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        rect.size.width += 25;
        rect.size.height = h;
        rect.origin.x = x;
        
        rect.origin.y = y;
        if (CGRectGetMaxX(rect)>ViewW) {
            rect.origin.x = 8;
            x = 8;
            y += 34;
            rect.origin.y = y;
        }
        x = x + rect.size.width+8;

        
        JZTabButton *button = [[JZTabButton alloc]initWithFrame:rect title:obj.title];
        __weak typeof(self)weekSelf = self;
        button.ButtonCanCelClick = ^(NSString *tag){
            [weekSelf.tagsViewDeleage removeSelectTag:tag];

        };
        button.ButtonDidClick = ^(NSString *tag){
            [weekSelf.tagsViewDeleage addSelectTag:tag];
        };
        [self.buttons addObject:button];
        [self.view addSubview:button];
        index ++;
    }
    if (x+150>ViewW) {
        x = 8;
        y+= 34;
    }
    JZTabButton *button = [[JZTabButton alloc]initWithFrame:CGRectMake(x, y,150, 30)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"添加新标签" forState:UIControlStateNormal];
    [self.buttons addObject:button];
    
    

}
- (NSMutableArray<JZTabButton *> *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return  _buttons;
}
- (void)setTags:(NSMutableArray<tag *> *)tags{
    _tags = tags;
    [self setDataWithTags];
}
- (NSMutableSet *)Selecttags{
    if (!_Selecttags) {
        _Selecttags = [NSMutableSet set];
    }
    return _Selecttags;
}

- (void)addTag{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"+添加标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *srt       = ac.textFields.firstObject.text;
        CGRect rect         = self.buttons[self.buttons.count-2].frame;
        CGFloat width         = [srt boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width+25;
       

        if (CGRectGetMaxX(rect)+width> self.view.bounds.size.width) {
            rect.origin.x = 8;
            rect.origin.y += 34;
        }else{
            rect.origin.x = CGRectGetMaxX(rect)+8;
        }
         rect.size.width = width;
        JZTabButton *button = [[JZTabButton alloc]initWithFrame:rect title:srt];
        __weak typeof(self)weekSelf = self;
        button.ButtonCanCelClick = ^(NSString *tag){
            [weekSelf.tagsViewDeleage removeSelectTag:tag];
            
        };
        button.ButtonDidClick = ^(NSString *tag){
            [weekSelf.tagsViewDeleage addSelectTag:tag];
        };
        [self.view addSubview:button];
        [button ChangeBackgroudColor];
        [self.buttons insertObject:button atIndex:self.buttons.count-1];
        CGFloat x = CGRectGetMaxX(rect)+8;
        CGFloat y = rect.origin.y;
        if (CGRectGetMaxX(rect)+150>self.view.bounds.size.width) {
            x = 8;
            y+= 34;
        }
        self.buttons.lastObject.frame = CGRectMake(x, y, 150, 30);
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
