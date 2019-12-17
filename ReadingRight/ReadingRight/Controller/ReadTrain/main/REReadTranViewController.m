//
//  REReadTranViewController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/10.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REReadTranViewController.h"
#import "ReadSpeedUtily.h"
#import "REBookCell.h"
#import "REReadTrainSettingVC.h"

#import "REBookLayout.h"
@interface REReadTranViewController() <speedUtilyDelegate>
@end

@implementation REReadTranViewController
{
    FlexCollectionView *bookCollection;
    ReadSpeedUtily *speedView;
    NSArray <REBook *> *source;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self oninit];
    
    bookCollection.delegate = self;
    bookCollection.dataSource = self;
    [bookCollection registerClass:[REBookCell class] forCellWithReuseIdentifier:@"cell"];
    
    REBookLayout *layout = [[REBookLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(50, 50*kScreenWidth/667, 50,50*kScreenWidth/667);
    [bookCollection setCollectionViewLayout:layout];
}

//初始化
- (void)oninit{
    speedView.speedDelegate = self;
    source = [self booksOfGrade:0 :1000];
    [bookCollection reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)utilyDidChooseSpeedWithMin:(NSInteger)min Max:(NSInteger)max{
    source = [self booksOfGrade:min :max];
    [bookCollection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return source.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    REBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.book = source[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    REReadTrainSettingVC *setting = [[REReadTrainSettingVC alloc] init];
    setting.superIdx = speedView.subIndex;
    setting.childIdx = speedView.childIndex;
    setting.book = source[indexPath.item];
    [self.navigationController pushViewController:setting animated:YES];
}

- (NSArray *)booksOfGrade:(NSInteger) min :(NSInteger) max{
    NSArray *source = [NSArray yy_modelArrayWithClass:[REBook class] json:jsonFromFile(File_Read_Train, @"txt")];
    NSMutableArray *array = [NSMutableArray array];
    [source enumerateObjectsUsingBlock:^(REBook *book, NSUInteger idx,BOOL *stop){
        if (book.grade >= min && book.grade <= max) {
            [array addObject:book];
        }
    }];
    return array;
}

- (void)dealloc
{
    NSLog(@"速读训练主页 dealloc");
}

@end
