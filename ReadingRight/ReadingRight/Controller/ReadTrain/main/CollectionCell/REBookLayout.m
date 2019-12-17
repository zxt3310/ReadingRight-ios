//
//  REBookLayout.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/23.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REBookLayout.h"

@implementation REBookLayout

- (void)prepareLayout{
    [super prepareLayout];
    [self registerClass:[REBookDecorationView class] forDecorationViewOfKind:@"cellBGI"];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    CGRect temp = rect;
    temp.size = self.collectionViewContentSize;
    NSArray *ary = [super layoutAttributesForElementsInRect:temp];
    NSMutableArray *arry = [NSMutableArray arrayWithArray:ary];
    
    for (int y=0; y<ary.count; y+=3) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:y inSection:0];
        [arry addObject:[self layoutAttributesForDecorationViewOfKind:@"cellBGI" atIndexPath:path]];
    }

    return arry;
}

- (CGSize)itemSize{
    return CGSizeMake(131,161);
}

- (CGFloat)minimumLineSpacing{
    return 26.0*kScreenWidth/667;
}

- (CGFloat)minimumInteritemSpacing{
    return 65.0;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    
    CGSize containSize = self.collectionViewContentSize;
    UIEdgeInsets inset = self.sectionInset;
    

    NSInteger itemIdx = indexPath.item;
    
    float y = (itemIdx/3 + 1) * (self.itemSize.height + self.minimumLineSpacing);
    
   // attrs.frame = CGRectMake(inset.left - 20, inset.top + y - self.minimumLineSpacing/2, containSize.width - inset.left - inset.right + 40, self.itemSize.height + self.minimumLineSpacing);
    attrs.frame = CGRectMake(inset.left-20, inset.top + y - 40, containSize.width - inset.left - inset.right + 40, 10);
    attrs.zIndex = -1;
    return attrs;
}

@end


@implementation REBookDecorationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
//        view.image = [UIImage imageNamed:@"shelf"];
//        [self addSubview:view];
        if ([userInfo defalutUser].bgiId == 0) {
            self.backgroundColor = colorFromString(@"#496264", nil);
        }else{
            self.backgroundColor = colorFromString(@"#c37b24", nil);
        }
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 10);
        self.layer.shadowOpacity = 0.6;
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

@end
