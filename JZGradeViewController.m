//
//  JZGradeViewController.m
//  BiShe
//
//  Created by Jz on 16/1/1.
//  Copyright © 2016年 Jz. All rights reserved.
//

#import "JZGradeViewController.h"
#import "JZNewWorkTool.h"
#import "JZBooksStore.h"
#import "JZGradeStar.h"
#import "JZTabLabelCell.h"
#import "JZTagsViewCOntroller.h"
#import "JZWildDog.h"
#import "userStroe.h"
#import "JZShortCommentsStore.h"

static NSString *const identifier = @"tabCell";
static NSString *const addIdentifier = @"addCell";

@interface JZGradeViewController ()<JZTagsViewCOntrollerDeleage>
@property (weak, nonatomic) IBOutlet JZGradeStar *gradeStar;
@property (weak, nonatomic) IBOutlet UITextView *contextView;
@property(nonatomic,strong)NSMutableArray<tag *> *tags;/**<标签数组 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeight;
@property(nonatomic,strong)NSMutableSet *selectTags;/**< */
@end

@implementation JZGradeViewController

- (NSMutableSet *)selectTags{
    if (!_selectTags) {
        _selectTags = [NSMutableSet set];
    }
    return _selectTags;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(evaluateBook)];
    if (self.comment) {
        self.gradeStar.grade = [self.comment.average integerValue];
        self.contextView.text = self.comment.shortContent;
    }


}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.collectionViewHeight.constant = self.tagsCollectionView.contentSize.height;
    [self.view layoutIfNeeded];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"JZTagsViewCOntroller"]) {
        JZTagsViewCOntroller *vc = segue.destinationViewController;
        vc.tagsViewDeleage = self;
        vc.commentTags = self.comment.tags;
        [[JZNewWorkTool workTool]tagsDataWihtBookId:self.bookId success:^(id obj) {
            self.tags = obj;
            if(self.tags.count>15){
                NSArray *array = [self.tags subarrayWithRange:NSMakeRange(0, 15)];
                self.tags = [NSMutableArray arrayWithArray:array];
                vc.tags = self.tags;
                

            }
            
        }];
    }
}

- (void)tableViewWihtHegiht:(CGFloat )heght{
    self.tagsViewHeight.constant = heght;
    [self.view updateConstraints];
}

- (void)addtag:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"添加标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        tag *obj = [[tag alloc]init];
        obj.title = ac.textFields.firstObject.text;
        [self.tags insertObject:obj atIndex:self.tags.count-1];

    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"你想添加的标签";
        [textField becomeFirstResponder];
        textField.borderStyle = UITextBorderStyleNone;

    }];
    [ac addAction:aciton];
    [ac addAction:other];
    
    [self presentViewController:ac animated:YES completion:nil];
}
- (void)addSelectTag:(NSString *)tag{
    [self.selectTags addObject:tag];
}
- (void)removeSelectTag:(NSString *)tag{
    [self.selectTags removeObject:tag];
}
- (void)evaluateBook{
    NSArray *tags = [self.selectTags allObjects];
    [self.deleage evaluateBookData];
    [[JZWildDog WildDog]addBookWithType:self.gradeType bookId:self.bookId tags:tags average:self.gradeStar.grade content:self.contextView.text withSuccess:^{
        [self.navigationController popViewControllerAnimated:YES];
    } fail:nil];
}
@end
