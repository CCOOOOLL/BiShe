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
           [self getUserBooks];
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
                [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"images/%@",user.name]]observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                    user.imageString = snapshot.value;
                    [user saveUser];
                    
                }];
                [user saveUser];
                block(error,authData);
                [self getUserBooks];
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
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"images/%@",user.name]]setValue:[user UIImageToBase64Str:image] withCompletionBlock:^(NSError *error, Wilddog *ref) {
        if (error) {
        }else{
            suceess();
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
    NSLog(@"%@",time);
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
            NSDictionary *userDict = @{@"title":[obj bookViewtitle],
                                       @"key":key,
                                       @"gradeType":@(type),
                                       @"image":[obj bookViewImageUrl],
                                       @"bookID":[obj bookViewId],
                                       @"tags":tag
                                       };
            JZComment *comment = [self.helper searchCommentWihtBookId:bookId].firstObject;
            if (comment) {
                [comment mj_setKeyValues:userDict];
            }else{
                comment = [JZComment mj_objectWithKeyValues:userDict context:self.helper.context];
            }
            comment.average = @(average);
            comment.shortContent = content;
            comment.book = obj;
            [[weekSelf.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment/%@",[userStroe loadUser].uid,bookId]]setValue:userDict withCompletionBlock:^(NSError *error, Wilddog *ref) {
                suceess();
                
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
            suceess(comments.firstObject);
            return;
        }else{
//            没有数据
            [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment/%@/key",user.uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                __weak typeof(self) weekself = self;
                if (snapshot.value == NULL) {

                    fail();
                }else{
//                    网上加载
                    [[weekself.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/Comment/%@/%@",bookId,snapshot.value]]observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                        NSLog(@"%@",snapshot.value);
                        [self.helper removeCommentWithBookId:bookId];
                        JZComment *data = [JZComment mj_objectWithKeyValues:snapshot.value context:weekself.helper.context];
                        [weekself.helper addComment:data];
                        suceess(data);
                    }];

                }
            }];
        }
    }else{

    }

}
- (void)getUserBooks{
    userStroe *user = [userStroe loadUser];
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment",user.uid]]
     observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        for (WDataSnapshot *data in snapshot.children) {
            JZComment *comment = [self.helper searchCommentWihtBookId:data.value[@"bookID"]].firstObject;
            if (comment) {
                [comment mj_setKeyValues:data.value];
            }else{
              comment = [JZComment mj_objectWithKeyValues:data.value context:self.helper.context];
            }
            
            [[JZNewWorkTool workTool]dataWithBookid:data.value[@"bookID"] success:^(id obj) {
                comment.book = obj;
            } fail:^(NSError *error) {
                
            }];
            NSLog(@"%@",comment.book.title);


        }
    }];
    
}

- (void)getUserBookWithSuccess:(void (^)(NSMutableArray *array)) success andFail:(void(^)(NSError *error))fail{
    
    NSArray<JZComment *> *array = [self.helper getuserBooks];
    NSMutableArray<JZComment*> *XiangDu = [NSMutableArray array];
    NSMutableArray<JZComment *> *ZaiDu = [NSMutableArray array];
    NSMutableArray<JZComment *> *YiDu = [NSMutableArray array];
    for (JZComment *comment in array) {
        
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
        NSLog(@"%@",comment.book.title);
    }
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


}

- (void)observeUserBook{
    [[self.userBooksWilDog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment",[userStroe loadUser].uid]]observeEventType:WEventTypeChildChanged andPreviousSiblingKeyWithBlock:^(WDataSnapshot *snapshot, NSString *prevKey) {
        JZComment *comment = [self.helper searchCommentWihtBookId:snapshot.value[@"bookID"]].firstObject;
        if (comment) {
            [comment mj_setKeyValues:snapshot.value];
        }else{
            
            comment = [JZComment mj_objectWithKeyValues:snapshot.value context:self.helper.context];
        }
        NSLog(@"%@",comment.book.title);

    }];
    [[self.userBooksWilDog childByAppendingPath:[NSString stringWithFormat:@"users/%@/Comment",[userStroe loadUser].uid]]observeEventType:WEventTypeChildAdded andPreviousSiblingKeyWithBlock:^(WDataSnapshot *snapshot, NSString *prevKey) {
        JZComment *comment = [self.helper searchCommentWihtBookId:snapshot.value[@"bookID"]].firstObject;
        if (comment) {
            [comment mj_setKeyValues:snapshot.value];
        }else{
            
            comment = [JZComment mj_objectWithKeyValues:snapshot.value context:self.helper.context];
        }
        NSLog(@"%@",comment.book.title);

    }];
}


@end
