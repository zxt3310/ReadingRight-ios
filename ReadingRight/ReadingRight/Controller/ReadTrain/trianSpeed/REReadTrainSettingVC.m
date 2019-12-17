//
//  REReadTrainSettingVC.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/16.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REReadTrainSettingVC.h"
#import "ReadSpeedUtily.h"
#import "REReadingViewController.h"

@interface REReadTrainSettingVC () <speedUtilyDelegate>

@end

@implementation REReadTrainSettingVC
{
    UIImageView *faceImgView;
    UIView *chooseView;
    
    UILabel *titleLb;
    UILabel *speedLb;
    UILabel *abstractLb;
    NSInteger selSpeed;
    UIView *decorationView;
}

@synthesize book = _book;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    ReadSpeedUtily *speedView = [[ReadSpeedUtily alloc] init];
    [speedView enableFlexLayout:YES];
    [speedView setLayoutAttr:@"height" Value:@"58%"];
    speedView.subIndex = self.superIdx;
    speedView.childIndex = self.childIdx;
    speedView.speedDelegate = self;
    
    [chooseView addSubview:speedView];
    speedView.isSubSpeed = NO;
    
    if ([userInfo defalutUser].bgiId == 0) {
        decorationView.backgroundColor = colorFromString(@"#496264", nil);
    }else{
        decorationView.backgroundColor = colorFromString(@"#c37b24", nil);
    }
    
    [self utilyDidChooseSpped:[speedView getFirstSpeed]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setBook:(REBook *)book{
    NSInteger bookId = book.id_assoc;
    NSString *path = [NSString stringWithFormat:@"%ld.txt",(long)bookId];
    _book = [REBook yy_modelWithJSON:jsonFromFile(path, @"txt")];
    
    [self.view layoutIfNeeded];
    
    faceImgView.image = [[UIImage alloc] initWithData:jsonFromFile(book.path, @"image")];
    
    titleLb.text = [NSString stringWithFormat:@"《%@》",_book.title];
    
    abstractLb.text = [NSString stringWithFormat:@"本文共计%ld个字",(long)_book.content.length];
}

- (void)utilyDidChooseSpped:(NSInteger)speed{
    selSpeed = speed;
    speedLb.text = [NSString stringWithFormat:@"当前速读：%ld字数/分钟",(long)speed];
}


- (void)startRead{
    REReadingViewController *readVC = [[REReadingViewController alloc] init];
    readVC.book = self.book;
    readVC.speed = selSpeed;
    [self.navigationController pushViewController:readVC animated:YES];
}

- (void)dealloc
{
    NSLog(@"速读测评 setting dealloc");
}

@end
