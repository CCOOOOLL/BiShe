//
//  JZSearchBookTableViewCell.m
//  BiShe
//
//  Created by Jz on 15/12/26.
//  Copyright © 2015年 Jz. All rights reserved.
//

#import "JZSearchBookTableViewCell.h"
#import "JZBooksStore.h"
#import "starView.h"
#import "YYWebImage.h"


@interface JZSearchBookTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;/**< 图片 */
@property (weak, nonatomic) IBOutlet UILabel *bookName;/**< 书名 */
@property (weak, nonatomic) IBOutlet starView *star;/**< 星星 */
@property (weak, nonatomic) IBOutlet UILabel *average;
@property (weak, nonatomic) IBOutlet UILabel *otherData;


@end

@implementation JZSearchBookTableViewCell

- (void)setBookDataModel:(id<BookViewProtocol>)bookDataModel{
    self.bookName.text = [bookDataModel bookViewtitle];
    self.star.showStar =  (NSNumber*)[bookDataModel bookViewaverage];
    self.average.text = [NSString stringWithFormat:@"%@(%@人评价)",[bookDataModel bookViewaverage],[bookDataModel bookViewnumRaters]];
    NSURL *path = [NSURL URLWithString:[bookDataModel bookViewImageUrl]];
    [self.bookImage yy_setImageWithURL:path  options:YYWebImageOptionIgnoreDiskCache|YYWebImageOptionSetImageWithFadeAnimation];
    self.otherData.text = [bookDataModel bookViewAuthor];
}

@end
