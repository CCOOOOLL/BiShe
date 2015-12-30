//
//  JZShortCommentsStore.m
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZShortCommentsStore.h"


@implementation JZShortComment

- (void)setStar:(NSString *)star{
    NSInteger number = [star intValue] *2;
    _star =  [NSString stringWithFormat:@"%ld",number];
}

- (NSString *)commentImageUrl{
    return [self.imageUrl copy];
}
- (NSString *)commentname{
    return [self.name copy];
}
- (NSString *)commenttitle{
    return [self.title copy];
}
- (NSString *)commentcontent{
    return [self.content copy];
}
- (NSString *)commenttime{
    return [self.time copy];
}
- (NSString *)commentstar{
    return [self.star copy];
}
- (NSString *)commentassist{
    return [self.assist copy];
}

@end

@implementation JZShortCommentsStore



- (instancetype)initWithHtml:(NSString *)html{
    self = [super init];
    if (self) {
        _shortComments = [NSMutableArray array];
        [self findDataInHTML:html];
    }
    
    return self;
}

- (void)findDataInHTML:(NSString *)html {

//    格式
//    <li class="comment-item">
//    <div class="avatar">
//    <a title="今天小熊不吃糖" href="http://www.douban.com/people/2018008/">
//    <img src="http://img3.doubanio.com/icon/u2018008-399.jpg">
//    </a>
//    </div>
//    <h3>
//    <span class="comment-vote">
//    <span id="c-54006670" class="vote-count">3</span>
//    <a href="javascript:;" id="btn-54006670" class="j vote-comment" data-cid="54006670">有用</a>
//    </span>
//    <span class="comment-info">
//    <a href="http://www.douban.com/people/2018008/">今天小熊不吃糖</a>
//    <span class="user-stars allstar50 rating" title="力荐"></span>
//    <span>2008-08-12</span>
//    </span>
//    </h3>
//    <p class="comment-content">还记得那天晚上陪他加班，这本书让我泪流满面……怀念那个夜晚</p>
//    </li>
    //将需要取出的用(.*?)代替. 大空格换行等用.*?代替,表示忽略.
    NSString *pattern = @"<li class=\"comment-item\">.*?<a title=\"(.*?)\" href=.*?<img src=\"(.*?)\">.*?class=\"vote-count\">(.*?)</span>.*?user-stars allstar(.*?)0 rating.*?<span>(.*?)</span>.*?comment-content\">(.*?)</p>.*?";
    
    //实例化正则表达式，需要指定两个选项
    //NSRegularExpressionCaseInsensitive  忽略大小写
    //NSRegularExpressionDotMatchesLineSeparators 让.能够匹配换行
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];

    NSArray<NSTextCheckingResult *> * array = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    for (NSTextCheckingResult *obj in array) {
        JZShortComment *comment = [[JZShortComment alloc]init];
        comment.name = [html substringWithRange:[obj rangeAtIndex:1]];
        comment.imageUrl =[html substringWithRange:[obj rangeAtIndex:2]];
        comment.assist = [html substringWithRange:[obj rangeAtIndex:3]];
        comment.star = [html substringWithRange:[obj rangeAtIndex:4]];
        comment.time = [html substringWithRange:[obj rangeAtIndex:5]];
        comment.content = [html substringWithRange:[obj rangeAtIndex:6]];
        [self.shortComments addObject:comment];
    }



}

@end
