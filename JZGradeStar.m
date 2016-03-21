//
//  JZGradeStar.m
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZGradeStar.h"
#define imageW  self.bounds.size.width/5

IB_DESIGNABLE
@interface JZGradeStar ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation JZGradeStar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star{
    
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.starBackgroundView = [self buidlStarViewWithImageName:Empty];
        self.starForegroundView = [self buidlStarViewWithImageName:Star];
        [self addSubview:self.starBackgroundView];
        
        self.userInteractionEnabled = YES;
        
        /**点击手势*/
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:tapGR];
        
        /**滑动手势*/
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:panGR];
        
        
        
    }
    return self;
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.starBackgroundView = [self buidlStarViewWithImageName:@"strokeStar"];
    self.starForegroundView = [self buidlStarViewWithImageName:@"fillStar"];
    [self addSubview:self.starBackgroundView];
    
    self.userInteractionEnabled = YES;
    
    /**点击手势*/
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
    [self addGestureRecognizer:tapGR];
    
    /**滑动手势*/
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
    [self addGestureRecognizer:panGR];
}



- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    
    
    for (int j = 0; j < 5; j ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(j*imageW, 0, imageW, imageW);
        [view addSubview:imageView];
    }
    
    return view;
}

-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint point =[tapGR locationInView:self];
    if (point.x<0) {
        point.x = 0;
    }
    
    int X = (int) point.x/(imageW);
    self.grade = X+1;

    
    
}

- (void)setGrade:(NSInteger)grade{
    _grade = grade;
    self.starForegroundView.frame = CGRectMake(0, 0, (grade)*imageW, imageW);
    [self addSubview:self.starForegroundView];
}

@end
