//
//  REBgiSelView.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/11/6.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REBgiSelView.h"
#import "ZWYTouchView.h"

@interface REBgiSelView()

@property NSNumber *subIndex;

@end

@implementation REBgiSelView
{
    UIView *selView;
}

- (void)onInit{
    [self enableFlexLayout:YES];
    self.subIndex = [NSNumber numberWithInteger:[userInfo defalutUser].bgiId];
}

- (void)didMoveToWindow{
    [selView zwy_flexTouchFits];
}

- (void)subSwitch:(UITapGestureRecognizer *)sender{
    ZWYTouchView *view = (ZWYTouchView *)sender.view;
    self.subIndex = @([selView.subviews indexOfObject:view]);
    [selView zwy_flexTouchFits];
    
    //变更背景 保存
    [userInfo defalutUser].bgiId = self.subIndex.integerValue;
    [[userInfo defalutUser] save];
}

- (void)chooseBgi{
    self.hidden = YES;
}

@end
