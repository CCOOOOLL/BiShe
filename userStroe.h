//
//  userStroe.h
//  BiShe
//
//  Created by Jz on 16/1/3.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JZBooksStore.h"

@interface book : NSObject
@property(nonatomic,assign)NSInteger average;/**<评分 */
//@property(nonatomic,copy)NSString *type;/**<类型 */
@property(nonatomic,copy)NSString *content;/**<内容 */
@property(nonatomic,assign)GradeType type;
@property(nonatomic,strong)NSArray *tags;;/**<<#text#> */
@end

@interface userStroe : NSObject
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *imageString;
@property (nonatomic,strong)NSMutableDictionary *books;



- (void)saveUser;
+ (instancetype)loadUser;
@end
