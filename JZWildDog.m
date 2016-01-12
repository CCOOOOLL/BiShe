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
@interface JZWildDog ()
@property (nonatomic, strong)Wilddog *wilddog;
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
/**
 *  注册
 *
 *  @param email    <#email description#>
 *  @param password <#password description#>
 *  @param name     <#name description#>
 *  @param block    <#block description#>
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
 *  @param email    <#email description#>
 *  @param password <#password description#>
 *  @param block    <#block description#>
 */
- (void)loginUser:(NSString *)email password:(NSString *)password WithBlock:(void(^)(NSError *error, WAuthData *authData) )block{
    [self.wilddog authUser:email password:password withCompletionBlock:^(NSError *error, WAuthData *authData) {
        if (error) {
        }else{
          __block  userStroe *user = [[userStroe alloc]init];
            NSString * uid =[authData.uid componentsSeparatedByString:@":"][1];
             user.uid = uid;
            [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/",uid]]observeEventType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                user.name = snapshot.value[@"name"];
                user.imageString = snapshot.value[@"imageString"];
                [user saveUser];
                block(error,authData);
            }];
            

        }
    }];
}
/**
 *  修改头像
 *
 *  @param image   <#image description#>
 *  @param suceess <#suceess description#>
 *  @param fail    <#fail description#>
 */
- (void)editUserIamge:(UIImage *)image withSuccess:(void (^)()) suceess fail:(void(^)(NSError *error)) fail{
    userStroe *user = [userStroe loadUser];
    NSLog(@"%@",user.uid);
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/imageString",user.uid]]setValue:[user UIImageToBase64Str:image] withCompletionBlock:^(NSError *error, Wilddog *ref) {
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
    NSDictionary *dict = @{
                           @"average":@(average),
                           @"shortContent":content,
                           @"gradeType":@(type),
                           @"bookid":bookId,
                           @"tags":tag
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
    NSLog(@"数据库添加评价啊数据");


//    Wilddog *dog = [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/ShortComment/%@",bookId]]childByAutoId];
//    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment/%@",[userStroe loadUser].uid,bookId]]updateChildValues:dict withCompletionBlock:^(NSError *error, Wilddog *ref) {
//
//    }];
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment/%@",[userStroe loadUser].uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        __weak typeof(self) weekSelf = self;
        if (snapshot.value == NULL) {
            Wilddog *dog = [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/ShortComment/%@",bookId]]childByAutoId];
            NSString *key = dog.key;
            [dog setValue:dict withCompletionBlock:^(NSError *error, Wilddog *ref) {
                [[weekSelf.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment/%@",[userStroe loadUser].uid,bookId]]setValue:key withCompletionBlock:^(NSError *error, Wilddog *ref) {
                        suceess();
                    
                }];;

            }];
        }else{
            Wilddog *dog = [weekSelf.wilddog childByAppendingPath:[NSString stringWithFormat:@"book/ShortComment/%@/%@",bookId,snapshot.value]];
            [dog setValue:dict withCompletionBlock:^(NSError *error, Wilddog *ref) {
                suceess();
            }];
            
        }
    }];
}



- (void)getGradeWihtBookId:(NSString *)bookId withSuccess:(void (^)(JZComment *data))suceess fail:(void(^)()) fail{
    
    userStroe *user = [userStroe loadUser];
    if (user) {
        NSArray *comments = [self.helper searchCommentWihtBookId:bookId];
        if (comments.count>0) {
            NSLog(@"数据库有评价啊数据");

            suceess(comments.firstObject);
            return;
        }else{
            [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/ShortComment/%@",user.uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
                __weak typeof(self) weekself = self;
                if (snapshot.value == NULL) {

                    NSLog(@"网上没有评价啊数据");

                    fail();
                }else{
                    NSLog(@"网上有评价啊数据");
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






@end
