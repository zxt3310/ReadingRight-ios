//
//  ReadSpeedCell.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/12.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "ReadSpeedCell.h"

@implementation ReadSpeedCell
{
    UIView *cellView;
    UILabel *titleLb;
}

@synthesize choosed = _choosed;
@synthesize title = _title;

- (instancetype)initWithFlex:(NSString *)flexName reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithFlex:flexName reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)onInit{
    [self enableFlexLayout:YES];
}

- (void)setChoosed:(BOOL)choosed{
    _choosed = choosed;
    if (choosed) {
        cellView.backgroundColor = [UIColor whiteColor];
        titleLb.textColor = colorFromString(@"#f99a2f", nil);
    }else{
        cellView.backgroundColor = colorFromString(@"#f99a2f", nil); ;
        titleLb.textColor = [UIColor whiteColor];
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    titleLb.text = title;
}

@end
