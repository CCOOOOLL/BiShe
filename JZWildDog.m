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



@interface JZWildDog ()
@property (nonatomic, strong)Wilddog *wilddog;
@end

@implementation JZWildDog
//- (void)createUserWith
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
        _wilddog = [[Wilddog alloc]initWithUrl:@"https://doubandushu.wilddogio.com/"];
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
    user.imageString = [self UIImageToBase64Str:image];
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/imageString",user.uid]]setValue:user.imageString withCompletionBlock:^(NSError *error, Wilddog *ref) {
        if (error) {

        }else{
            suceess();
        }
    }];
}
/**
 *  添加收藏
 */
- (void)addBookWithType:(GradeType)type bookId:(NSString *)bookId tags:(NSArray *)tags average:(NSInteger)average content:(NSString *)content withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail{
    NSDictionary *dict = @{
                           @"tags":tags,
                           @"star":@(average),
                           @"content":content,
                           @"type":@(type)
                           };
    
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/books/%@",[userStroe loadUser].uid,bookId]]setValue:dict withCompletionBlock:^(NSError *error, Wilddog *ref) {
        suceess();
    }];
}
- (void)addBook:(Book *)book withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail{
    NSMutableDictionary *dict =[book mj_keyValues];
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"Books/%@",book.ID]]setValue:dict withCompletionBlock:^(NSError *error, Wilddog *ref) {
        
    }];
}
/**
 *  获取图书数据
 *
 *  @param suceess <#suceess description#>
 *  @param fail    <#fail description#>
 */
- (void)getBookWithBookId:(NSString *)bookId withSuccess:(void (^)(Book* book))success fail:(void(^)(NSError *error)) fail{
    __block Book *book;
    __weak typeof(self) weakself = self;
    [[self.wilddog childByAppendingPath:@"Books"] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
         if (![snapshot hasChild:bookId]) {
             [[JZNewWorkTool workTool]dataWithBookid:bookId success:^(id obj) {
                 book = obj;
                 success(book);
                 [weakself addBook:book withSuccess:nil fail:nil];
             }];
         }else{
             book = [Book mj_objectWithKeyValues:[snapshot childSnapshotForPath:bookId].value];
             success(book);
         }
     }];



}

- (void)updeBookShortCommentWithBookId:(NSString *)bookId page:(NSInteger)page withSuccess:(void (^)(JZShortCommentsStore *store))suceess fail:(void(^)(NSError *error)) fail{
    __weak typeof(self) weakself = self;
    [[self.wilddog childByAppendingPath:@"ShortComments"] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        if (![snapshot hasChild:bookId]) {
            [[JZNewWorkTool workTool]datawithshortComments:bookId page:1 success:^(id obj) {
                JZShortCommentsStore *store = obj;
                 suceess(store);
                for (JZShortComment *comment in store.shortComments) {
                    NSDictionary *dict = [comment mj_keyValues];
                      [[weakself.wilddog childByAppendingPath:[NSString stringWithFormat:@"ShortComments/%@/%@",bookId,comment.ID]]setValue:dict];
                }

            }];
        }else{
            WQuery *query = [self.wilddog childByAppendingPath:[NSString stringWithFormat:@"ShortComments/%@",bookId]];
            [query observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {

                    [[JZNewWorkTool workTool]datawithshortComments:bookId page:page success:^(id obj) {
                        JZShortCommentsStore *store = obj;
                        suceess(store);
                        for (JZShortComment *comment in store.shortComments) {
                            NSDictionary *dict = [comment mj_keyValues];
                            [[weakself.wilddog childByAppendingPath:[NSString stringWithFormat:@"ShortComments/%@/%@",bookId,comment.ID]]updateChildValues:dict];
                        }
                        
                    }];


//                JZShortCommentsStore *store =[[JZShortCommentsStore alloc]init];
//                store.shortComments = [NSMutableArray array];
//                for (WDataSnapshot *data in snapshot.children) {
//                    NSLog(@"%@",snapshot.value);
//                    JZShortComment *comment =[JZShortComment mj_objectWithKeyValues:data.value];
//                    [store.shortComments addObject:comment];
//                }
//                suceess(store);
            }];

        }
    }];

}

- (void)getGradeWihtBookId:(NSString *)bookId withSuccess:(void (^)(JZShortComment *Comment))suceess fail:(void(^)()) fail{
    userStroe *user = [userStroe loadUser];
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/books/%@",user.uid,bookId]] observeSingleEventOfType:WEventTypeValue withBlock:^(WDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null]) {
            fail();
        }else{
            JZShortComment *comment = [JZShortComment mj_objectWithKeyValues:snapshot.value];
            suceess(comment);
        }
    }];
}

- (void)WirteBookGradeWihtBookId:(NSString *)bookId range:(NSInteger)range tags:(NSArray *)tags content:(NSString *)content withSuccess:(void (^)())suceess fail:(void(^)(NSError *error)) fail{
    userStroe *user = [userStroe loadUser];
    NSDictionary *dict =@{
                          @"star":@(range),
                          @"tag":tags,
                          @"content":content
                          };
    [[self.wilddog childByAppendingPath:[NSString stringWithFormat:@"users/%@/shortComments/%@",user.uid,bookId]]setValue:dict];
    suceess();
}



-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc]initWithBase64EncodedString:_encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}


@end
