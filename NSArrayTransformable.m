//
//  NSArrayTransformable.m
//  BiShe
//
//  Created by Jz on 16/1/9.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "NSArrayTransformable.h"

@implementation NSArrayTransformable

+(BOOL)allowsReverseTransformation{
    return YES;
}
+ (Class)transformedValueClass{
    return [NSArray class];
}
- (id)transformedValue:(id)value{
   return [NSKeyedArchiver archivedDataWithRootObject:value];
}
- (id)reverseTransformedValue:(id)value{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}
@end
