//
//  JZShortCommentsStore.h
//  BiShe
//
//  Created by Jz on 15/12/30.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommentProtocol <NSObject>

- (NSString *)commentImageUrl;
- (NSString *)commentname;
- (NSString *)commenttitle;
- (NSString *)commentcontent;
- (NSString *)commenttime;
- (NSString *)commentstar;
- (NSString *)commentassist;
- (NSString *)commenCOntentUrl;


@end

@interface JZShortComment : NSObject<CommentProtocol>

-(instancetype)initWithContent:(NSString *)html;

@property(nonatomic,copy)NSString *imageUrl;/**<头像地址 */
@property(nonatomic,copy)NSString *contentUrl;/**<详细内容地址 */
@property(nonatomic,copy)NSString *name;/**<评价人 */
@property(nonatomic,copy)NSString *title;/**<标题 */
@property(nonatomic,copy)NSString *ID;/**<ID */
@property(nonatomic,copy)NSString *content;/**<内容 */
@property(nonatomic,copy)NSString *time;/**<时间 */
@property(nonatomic,copy)NSString *star;/**<评价 */
@property(nonatomic,copy)NSString *assist;/**<点赞数 */


@end


@interface JZShortCommentsStore : NSObject
@property(nonatomic,strong)NSMutableArray<JZShortComment *> *shortComments;/**<<#text#> */


- (instancetype)initShortCommentWithHtml:(NSString *)html;

- (instancetype)initCommentWithHtml:(NSString *)html;

@end
