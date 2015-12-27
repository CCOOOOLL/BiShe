//
//  JZTopBookTableViewCell.h
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
@class JZBookView;



typedef void(^ViewDidClick)(NSInteger number);

@interface JZTopBookTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *category;/**< 榜单类别 */
@property(nonatomic,strong)NSArray<JZBookView*> *bookViews; /**< 图书界面数组 */
@property(nonatomic,strong)NSArray<id<BookViewProtocol>> *bookViewModels;/**< 拥有BookViewProtocol的对象 */
@property(nonatomic,assign)NSInteger tagWithButton;/**< 内容的查询id */
@property(nonatomic,copy)ViewDidClick clickBlock;
@end
