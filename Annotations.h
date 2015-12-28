//
//  Annotations.h
//  BiShe
//
//  Created by Jz on 15/12/28.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Annotation:NSObject

@property(nonatomic,copy)NSString *abstract;/**<<#text#> */


@end

@interface Annotations : NSObject
@property(nonatomic,strong)NSMutableArray *annotations;/**<<#text#> */
@end
