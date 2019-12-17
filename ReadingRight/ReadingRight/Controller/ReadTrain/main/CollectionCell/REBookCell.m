//
//  REBookCell.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/14.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REBookCell.h"

@implementation REBookCell
{
    UIImageView *faceImgView;
    UILabel *titleLb;
}
@synthesize book = _book;

- (void)onInit{
    
}

- (void)setBook:(REBook *)book{
    _book = book;
    
    UIImage *img = [[UIImage alloc] initWithData:jsonFromFile(book.path, @"image")];
    faceImgView.image = img;
    titleLb.text = book.title;
}

@end
