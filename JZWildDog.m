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
    NSDictionary *coreDict = @{
                               @"average":@(average),
                               @"shortContent":content,
                               @"gradeType":@(type),
                               @"bookid":bookId,
                               @"tags":tags
                               };
    [self.helper removeCommentWithBookId:bookId];
    JZComment *comment = [JZComment mj_objectWithKeyValues:coreDict context:self.helper.context];
    [self.helper addComment:comment];
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment/%@",[userStroe loadUser].uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        __weak typeof(self) weekSelf = self;
        if (snapshot.value != NULL) {
        [[weekSelf.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/ShortComment/%@/%@",bookId,snapshot.value[@"key"]]] setValue:nil];
        }
        Wilddog *dog = [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/ShortComment/%@",bookId]]childByAutoId];
        NSString *key = dog.key;
        
        [dog setValue:dict withCompletionBlock:^(NSError *error, Wilddog *ref) {
            JZBook *obj = [self.helper searchDataWihtBookId:bookId];
            NSDictionary *userDict = @{@"title":[obj bookViewtitle],
                                       @"key":key,
                                       @"gradeType":@(type),
                                       @"image":[obj bookViewImageUrl],
                                       @"bookID":[obj bookViewId]
                                       };
            [[weekSelf.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment/%@",[userStroe loadUser].uid,bookId]]setValue:userDict withCompletionBlock:^(NSError *error, Wilddog *ref) {
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
            [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment/%@/key",user.uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                __weak typeof(self) weekself = self;
                if (snapshot.value == NULL) {

                    fail();
                }else{
//                    网上加载
                    [[weekself.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/ShortComment/%@/%@",bookId,snapshot.value]]observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
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
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment",user.uid]]
     observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        for (WDataSnapshot *data in snapshot.children) {
            JZBook *book = [self.helper searchDataWihtBookId:data.value[@"bookID"]];
            if (book) {
                [book mj_setKeyValues:data.value];
            }else{
               [JZBook mj_objectWithKeyValues:data.value context:self.helper.context];
            }

        }
    }];
}

- (void)getUserBookWithSuccess:(void (^)(NSMutableArray *array)) success andFail:(void(^)(NSError *error))fail{
    
    NSArray<JZBook *> *array = [self.helper getuserBooks];
    NSMutableArray<JZBook*> *XiangDu = [NSMutableArray array];
    NSMutableArray<JZBook *> *ZaiDu = [NSMutableArray array];
    NSMutableArray<JZBook *> *YiDu = [NSMutableArray array];
    for (JZBook *book in array) {
        switch ((GradeType)[book.gradeType intValue]) {
            case GradeTypeXiangDu:
                [XiangDu addObject:book];
                break;
            case GradeTypeZaiDu:
                [ZaiDu addObject:book];
                break;
            case GradeTypeYiDu:
                [YiDu addObject:book];
            default:
                break;
        }
        [self.helper addBook:book];
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
    [[self.userBooksWilDog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment",[userStroe loadUser].uid]]observeEventType:WEventTypeChildChanged andPreviousSiblingKeyWithBlock:^(WDataSnapshot *snapshot, NSString *prevKey) {
        JZBook *book = [self.helper searchDataWihtBookId:snapshot.value[@"bookID"]];
        if (book) {
            [book mj_setKeyValues:snapshot.value];
        }else{
            book = [JZBook mj_objectWithKeyValues:snapshot.value context:self.helper.context];
        }
    }];
    [[self.userBooksWilDog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment",[userStroe loadUser].uid]]observeEventType:WEventTypeChildAdded andPreviousSiblingKeyWithBlock:^(WDataSnapshot *snapshot, NSString *prevKey) {
        JZBook *book = [self.helper searchDataWihtBookId:snapshot.value[@"bookID"]];
        if (book) {
            [book mj_setKeyValues:snapshot.value];
        }else{
            book = [JZBook mj_objectWithKeyValues:snapshot.value context:self.helper.context];
        }
    }];
}


@end
