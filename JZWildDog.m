//
//  JZWildDog.m
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZWildDog.h"
#import "userStroe.h"
#import "JZShortCommentsStore.h"
#import "MJExtension.h"
#import "JZNewWorkTool.h"
#import "CoreDataHelper.h"
#import "JZComment.h"
#import "JZBook.h"
#import "JZTag.h"
#import "JZHUD.h"
@interface JZWildDog ()
@property (nonatomic, strong)Wilddog *wilddog;
@property (nonatomic, strong)Wilddog *userBooksWilDog;
@property (nonatomic, strong)CoreDataHelper *helper;
@end

@implementation JZWildDog
//- (void)createUserWith

- (CoreDataHelper *)helper{
    if (!_helper) {
        _helper = [CoreDataHelper helper];
    }
    return _helper;
}

+(instancetype)WildDog{
    static id dog;
    static dispatch_once_t oneces;
    dispatch_once(&oneces, ^{
        dog = [[JZWildDog alloc]init];
    });
    return dog;
}

- (Wilddog *)wilddog{
    if (!_wilddog) {
        _wilddog = [[Wilddog alloc]initWithUrl:@"https://dushu.wilddogio.com/"];
    }
    return _wilddog;
}
- (Wilddog *)userBooksWilDog{
    if (!_userBooksWilDog) {
        _userBooksWilDog = [[Wilddog alloc]initWithUrl:@"https://dushu.wilddogio.com/"];
    }
    return _userBooksWilDog;
}
/**
 *  注册
 */
- (void)createUser:(NSString *)email password:(NSString *)password name:(NSString *)name withSuccess:(void (^)()) suceess fail:(void(^)(NSError *error)) fail{
   [self.wilddog createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
       if (error) {
           fail(error);
           NSLog(@"失败");
       }else{
           NSString * uid =[result[@"uid"] componentsSeparatedByString:@":"][1];
           NSDictionary *newUser = @{
                                     @"name": name
                                     };
           [[[self.wilddog childByAppendingPath:@"users"]childByAppendingPath:uid]setValue:newUser];
           suceess();
           NSLog(@"成功");
       }
       
   }];
    
}
/**
 *  邮箱登陆
 *
 */
- (void)loginUser:(NSString *)email password:(NSString *)password WithBlock:(void(^)(NSError *error, WAuthData *authData) )block fail:(void(^)(NSError *error)) fail{
    [self.wilddog authUser:email password:password withCompletionBlock:^(NSError *error, WAuthData *authData) {
        
        if (error) {
            fail(error);
        }else{
          __block  userStroe *user = [[userStroe alloc]init];
            NSString * uid =[authData.uid componentsSeparatedByString:@":"][1];
             user.uid = uid;
            [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/",uid]]observeEventType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                user.name = snapshot.value[@"name"];
//                user.imageString = snapshot.value[@"imageString"];
                [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"images/%@",user.uid]]observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                    user.imageString = snapshot.value;
                    [user saveUser];
                    
                }];
                [user saveUser];
                block(error,authData);

            }];
            

        }
    }];
}
/**
 *  修改头像
 *
 */
- (void)editUserIamge:(UIImage *)image withSuccess:(void (^)()) suceess fail:(void(^)(NSError *error)) fail{
    userStroe *user = [userStroe loadUser];
    NSLog(@"%@",user.uid);
    [JZHUD showHUDandTitle:nil];
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"images/%@",user.uid]]setValue:[user UIImageToBase64Str:image] withCompletionBlock:^(NSError *error, Wilddog *ref) {
        if (error) {
            [JZHUD showFailandTitle:nil];
        }else{
            suceess();
            [JZHUD showSuccessandTitle:nil];
            [user saveUser];
        }
    }];
}
/**
 *  添加修改收藏
 */
- (void)addBookWithType:(GradeType)type bookId:(NSString *)bookId tags:(NSArray *)tags average:(NSInteger)average content:(NSString *)content withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail{
    NSMutableDictionary *tag = [NSMutableDictionary dictionary];
    for (int i=0; i<tags.count; i++) {
        tag[[NSString stringWithFormat:@"%d",i]] = tags[i];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * time=[dateformatter stringFromDate:date];
    NSDictionary *dict = @{
                           @"average":@(average),
                           @"shortContent":content,
                           @"gradeType":@(type),
                           @"bookid":bookId,
                           @"tags":tag,
                           @"userName":[userStroe loadUser].name,
                           @"time":time
                           };

    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment/%@",[userStroe loadUser].uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        __weak typeof(self) weekSelf = self;
        if (snapshot.value != NULL) {
        [[weekSelf.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/Comment/%@/%@",bookId,snapshot.value[@"key"]]] removeValue];
        }
        Wilddog *dog = [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/Comment/%@",bookId]]childByAutoId];
        NSString *key = dog.key;
        
        [dog setValue:dict withCompletionBlock:^(NSError *error, Wilddog *ref) {
            JZBook *obj = [self.helper searchDataWihtBookId:bookId];
            NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
            userDict[@"title"]=[obj bookViewtitle];
            userDict[@"key"]=key;
            userDict[@"gradeType"]=@(type);
            userDict[@"image"]=[obj bookViewImageUrl];
            userDict[@"bookID"]=[obj bookViewId];
            if (tags.count>0) {
                userDict[@"tags"] = tags;
            }
            JZComment *comment = [self.helper searchCommentWihtBookId:bookId].firstObject;
            if (comment) {
                [comment mj_setKeyValues:userDict];
            }else{
                comment = [JZComment mj_objectWithKeyValues:userDict context:self.helper.context];
            }
            NSLog(@"添加的图书数据comment%@",comment.bookID);
            comment.average = @(average);
            comment.shortContent = content;
            if (obj.bookID) {
                comment.book = obj;
            }
            [self.helper saveContext];
            [[weekSelf.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment/%@",[userStroe loadUser].uid,bookId]]setValue:userDict withCompletionBlock:^(NSError *error, Wilddog *ref) {
                if (error) {
                    NSLog(@"%@",error);
                }
                else{
                suceess();
                    
                }
            }];;
            
        }];
    }];
}



- (void)getGradeWihtBookId:(NSString *)bookId withSuccess:(void (^)(JZComment *data))suceess fail:(void(^)()) fail{
    
    userStroe *user = [userStroe loadUser];
    if (user) {
        NSArray *comments = [self.helper searchCommentWihtBookId:bookId];
        if (comments.count>0) {
            //从数据库加载
            NSLog(@"从数据库加载comment%@",comments.firstObject);
            suceess(comments.firstObject);
        }else{
        
            [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment/%@/key",user.uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                __weak typeof(self) weekself = self;
                if (snapshot.value == NULL) {

                    fail();
                }else{
//                    网上加载
                    [[weekself.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/Comment/%@/%@",bookId,snapshot.value]]observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                        [self.helper removeCommentWithBookId:bookId];
                        JZComment *data = [JZComment mj_objectWithKeyValues:snapshot.value context:weekself.helper.context];
                        suceess(data);
                    }];

                }
            }];
        }
    }
}

/**
 *  读取用户收藏图书数据
 */
- (void)getUserBookWithSuccess:(void (^)(NSMutableArray *array)) success andFail:(void(^)(NSError *error))fail{
    dispatch_group_t group = dispatch_group_create();

    //通过用户的评论数据获取评论对应的图书数据
    [self observeUserBook:^(NSMutableArray *array) {
        //分成三类 图书
        NSMutableArray<JZComment*> *XiangDu = [NSMutableArray array];
        NSMutableArray<JZComment *> *ZaiDu = [NSMutableArray array];
        NSMutableArray<JZComment *> *YiDu = [NSMutableArray array];
        for (JZComment *comment in array) {/**< 判断评论数据是否有图书数据 */
            NSLog(@"%@",comment.bookID);
            if (!comment.book.bookID) {/**< 没有数据则上网获取 */
                 dispatch_group_enter(group);
                [[JZNewWorkTool workTool]dataWithBookid:comment.bookID success:^(id obj) {
                    comment.book = obj;
                    dispatch_group_leave(group);
                } fail:^(NSError *error) {
                    NSLog(@"%@",error);
                    dispatch_group_leave(group);
                }];
            }
            //添加数据到对应的类别数组
            switch ((GradeType)[comment.gradeType intValue]) {
                case GradeTypeXiangDu:
                    [XiangDu addObject:comment];
                    break;
                case GradeTypeZaiDu:
                    [ZaiDu addObject:comment];
                    break;
                case GradeTypeYiDu:
                    [YiDu addObject:comment];
                    break;
                default:
                    break;
                    
            }
        }

        //网络请求全部完成后执行
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSMutableArray *books = [NSMutableArray array];
            if (XiangDu.count>0) {
                [books addObject:XiangDu];
            }
            if (ZaiDu.count>0) {
                [books addObject:ZaiDu];
            }
            if (YiDu.count>0) {
                [books addObject:YiDu];
            }
            success(books);
        });
        
        

    }];
    

}
/**
 *  读取用户收藏的评论数据
 *
 *  @param success 返回评论数组数据
 */
- (void)observeUserBook :(void (^)(NSMutableArray *array)) success{
   NSArray *array = [self.helper getuserBooks];
    if (array.count>0) {//本地数据库有数据直接读取本地评论数据
        success((NSMutableArray*)array);
    }else{//通过野狗数据库加载数据
        [[self.userBooksWilDog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment",[userStroe loadUser].uid]]observeEventType:WEventTypeValue andPreviousSiblingKeyWithBlock:^(WDataSnapshot *snapshot, NSString *prevKey) {
            NSMutableArray *array = [NSMutableArray array];
            for (WDataSnapshot* child in snapshot.children) {
                //搜索本地是否有数据
              __block  JZComment *comment = [self.helper searchCommentWihtBookId:child.value[@"bookId"]].firstObject;
                if (comment) {//修改数据
                    [comment mj_setKeyValues:child.value];
                }else{//添加数据
                    comment = [JZComment mj_objectWithKeyValues:child.value context:self.helper.context];
                }
                [array addObject:comment];

            }
            success(array);
            

        }];
    }
}


@end
