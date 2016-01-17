//
//  JZHUD.h
//  JZHUD
//
//  Created by Jz on 16/1/16.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZHUD : UIToolbar

+ (instancetype)shared;/**< 单例 */

+ (void)showHUDandTitle:(NSString *)title;
+ (void)showSuccessandTitle:(NSString *)title;
+ (void)showFailandTitle:(NSString *)title;
+(void)dismissHUD;
@end
