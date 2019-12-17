//
//  RETestViewController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/25.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "RETestViewController.h"
#import "REQuestionView.h"
#import "RELevelEvaluateVC.h"

@interface RETestViewController() <REQuestViewDelegate>

@end

@implementation RETestViewController
{
    UILabel *titleLb;
    UILabel *countLb;
    FlexScrollView *questionView;
    NSInteger numberOfWrong;
    NSInteger numerOfTotalCount;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadQuest];
    
    titleLb.text = self.book.title;
    countLb.text = [NSString stringWithFormat:@"%ld字",(long)self.book.content.length];
}


- (void)loadQuest{
    NSArray *questAry = self.book.questions;
    
    for (int i=0; i<questAry.count; i++) {
        REQuestion *question = questAry[i];
        REQuestionView *view = [[REQuestionView alloc] init];
        view.question = question;
        view.questDelegate = self;
        [questionView.contentView addSubview:view];
    }
}

- (void)viewDidAnswer:(BOOL)right{
    numerOfTotalCount += 1;
    if (!right) {
        numberOfWrong += 1;
    }
    
    if (numerOfTotalCount == self.book.questions.count) {
        if (self.needLevel) {
            NSInteger total = self.book.content.length;
            NSInteger level = total/self.seconds*60;
            
            RELevelEvaluateVC *levelVC = [[RELevelEvaluateVC alloc] init];
            levelVC.level = level;
            [self.navigationController pushViewController:levelVC animated:YES];
        }else{
            //错太多
            if (numberOfWrong > 1) {
                
            }else{
                
            }
        }
    }
}

- (void)naviBack{
    NSArray *contrs = self.navigationController.viewControllers;
    UIViewController *target = contrs[contrs.count - 3];
    [self.navigationController popToViewController:target animated:YES];
}

@end
