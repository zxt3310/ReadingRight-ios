//
//  ZWYTouchView.h
//  QuHaiYoo
//
//  Created by 赵五一 on 2019/9/1.
//  Copyright © 2019 陈恒均. All rights reserved.
//

#import <FlexLib/FlexLib.h>

@interface UIView (ZWYFlexTouch)

// 子 View 的选中状态
@property (nonatomic, assign) BOOL selected;

- (void)zwy_flexTouchFits;
@end

@interface ZWYTouchView : FlexTouchView

// 重新调用 selectd flexset 的方法
- (void)checkFlex;
@end

