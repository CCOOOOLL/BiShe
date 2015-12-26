//
//  JZTopBookTableViewCell.h
//  BiShe
//
//  Created by Jz on 15/12/22.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBooksStore.h"
#import "JZBookView.h"
@interface JZTopBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *category;
@property(nonatomic,strong)NSArray<JZBookView*> *bookViews;
@property(nonatomic,strong)NSArray<BookData *> *bookViewModels;
@property(nonatomic,assign)NSInteger tagWithButton;/**< 内容的查询id */
@end
