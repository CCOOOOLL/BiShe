//
//  JZGradeViewController.h
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"


@protocol  JZGradeViewControllerDeleage<NSObject>;

- (void)evaluateBookData;

@end


@interface JZGradeViewController : UIViewController

@property(nonatomic,assign)GradeType gradeType;/**< <#shuoming#> */
@property(nonatomic,strong)NSString *bookId;/**<<#text#> */
@property(nonatomic,weak) id<JZGradeViewControllerDeleage> deleage;
@end
