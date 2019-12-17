//
//  RELimitedViewController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/24.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "RELimitedViewController.h"
#import "ReadSpeedUtily.h"
#import "REBookCell.h"
#import "REReadingViewController.h"
#import "REBookLayout.h"

@interface RELimitedViewController() <speedUtilyDelegate>

@end

@implementation RELimitedViewController
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
    layout.sectionInset = UIEdgeInsetsMake(50*kScreenWidth/667, 50, 50*kScreenWidth/667, 50);
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
    REReadingViewController *readVC = [[REReadingViewController alloc] init];
    REBook *book = source[indexPath.item];
    NSInteger bookId = book.id_assoc;
    NSString *path = [NSString stringWithFormat:@"%ld.txt",(long)bookId];
    readVC.book = [REBook yy_modelWithJSON:jsonFromFile(path, @"txt")];
    readVC.isLimited = YES;
    [self.navigationController pushViewController:readVC animated:YES];
}

- (NSArray *)booksOfGrade:(NSInteger) min :(NSInteger) max{
    NSArray *source = [NSArray yy_modelArrayWithClass:[REBook class] json:jsonFromFile(File_Read_Limit, @"txt")];
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
