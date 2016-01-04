//
//  JZShortCommentsStore.m
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZShortCommentsStore.h"


@implementation JZShortComment

-(instancetype)initWithContent:(NSString *)html{
    self = [super init];
    if (self) {
        [self findContentWithHtml:html];
    }
    return self;
}

-(void)findContentWithHtml:(NSString *)html{

    NSString *pattern = @"<span property=\"v:description\" class=\"\">(.*?)<div class=\"clear\"></div></span>";

   NSRegularExpression *regex   = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
   NSTextCheckingResult *result = [regex firstMatchInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
   self.content                 = [html substringWithRange:[result rangeAtIndex:1]];
    
}


- (void)setStar:(NSString *)star{
    NSInteger number = [star intValue] *2;
    _star =  [NSString stringWithFormat:@"%ld",number];
}
- (void)setContent:(NSString *)content{
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    content = [content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    _content =content;
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
- (NSString *)commenCOntentUrl{
    return [self.contentUrl copy];
}

@end

@implementation JZShortCommentsStore



- (instancetype)initShortCommentWithHtml:(NSString *)html{
    self = [super init];
    if (self) {
        _shortComments = [NSMutableArray array];
        [self findShotCommentInHTML:html];
    }
    
    return self;
}

- (instancetype)initCommentWithHtml:(NSString *)html{
    self = [super init];
    if (self) {
        _shortComments = [NSMutableArray array];
        [self findCommentInHTML:html];
    }
    
    return self;
}


- (void)findShotCommentInHTML:(NSString *)html {



    NSString *pattern = @"<li class=\"comment-item\">.*?<a title=\"(.*?)\" href=.*?<img src=\"(.*?)\">.*?class=\"vote-count\">(.*?)data-cid=\"(.*?)\".*?</span>.*?user-stars allstar(.*?)0 rating.*?<span>(.*?)</span>.*?comment-content\">(.*?)</p>.*?";
    
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
        comment.ID = [html substringWithRange:[obj rangeAtIndex:4]];

        comment.star = [html substringWithRange:[obj rangeAtIndex:5]];
        comment.time = [html substringWithRange:[obj rangeAtIndex:6]];
        comment.content = [html substringWithRange:[obj rangeAtIndex:7]];
        [self.shortComments addObject:comment];
    }



}

- (void)findCommentInHTML:(NSString *)html {


    NSString *pattern = @"<div class='ctsh'>.*?title=\"(.*?)\".*?<img class=\"pil\" src=\"(.*?)\" alt.*?href=\"(.*?)\".*?<a title=\"(.*?)\" class.*?<span class=\"allstar(.*?)0\" title.*?class=\"review-short\">.*?>(.*?)<div.*?class=\"fleft\">.*?class=\"\">(.*?) .*?<span class=\"\">(.*?)/.*?";
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> * array = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    if(!array){

    }
    for (NSTextCheckingResult *obj in array) {
        JZShortComment *comment = [[JZShortComment alloc]init];
        comment.name            = [html substringWithRange:[obj rangeAtIndex:1]];
        comment.imageUrl        = [html substringWithRange:[obj rangeAtIndex:2]];
        comment.contentUrl      = [html substringWithRange:[obj rangeAtIndex:3]];
        comment.title           = [html substringWithRange:[obj rangeAtIndex:4]];
        comment.star            = [html substringWithRange:[obj rangeAtIndex:5]];
        comment.content         = [html substringWithRange:[obj rangeAtIndex:6]];
        comment.time            = [html substringWithRange:[obj rangeAtIndex:7]];
        comment.assist          = [html substringWithRange:[obj rangeAtIndex:8]];

        [self.shortComments addObject:comment];
    }

}
@end
