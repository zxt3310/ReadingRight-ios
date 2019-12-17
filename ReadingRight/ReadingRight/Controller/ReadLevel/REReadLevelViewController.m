//
//  REReadLevelViewController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/28.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REReadLevelViewController.h"
#import "REBookCell.h"
#import "REBookLayout.h"
#import "RELevelTestReadingVC.h"

@interface REReadLevelViewController() <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation REReadLevelViewController
{
    FlexCollectionView *bookCollection;
    NSArray <REBook *> *source;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    source = [NSArray yy_modelArrayWithClass:[REBook class] json:jsonFromFile(File_Read_test, @"txt")];
    
    bookCollection.delegate = self;
    bookCollection.dataSource = self;
    [bookCollection registerClass:[REBookCell class] forCellWithReuseIdentifier:@"cell"];
    
    REBookLayout *layout = [[REBookLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(50, 50*kScreenWidth/667, 50,50*kScreenWidth/667);
    [bookCollection setCollectionViewLayout:layout];
    
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
    RELevelTestReadingVC *readVC = [[RELevelTestReadingVC alloc] init];
    REBook *book = source[indexPath.item];
    NSInteger bookId = book.id_assoc;
    NSString *path = [NSString stringWithFormat:@"%ld.txt",(long)bookId];
    readVC.book = [REBook yy_modelWithJSON:jsonFromFile(path, @"txt")];
    [self.navigationController pushViewController:readVC animated:YES];
}

@end
