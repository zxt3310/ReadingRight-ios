//
//  ReadSpeedUtily.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/11.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol speedUtilyDelegate <NSObject>

@optional

- (void)utilyDidChooseSpeedWithMin:(NSInteger) min Max:(NSInteger)max;

- (void)utilyDidChooseSpped:(NSInteger) speed;

@end

@interface ReadSpeedUtily : FlexCustomBaseView

@property (weak)id <speedUtilyDelegate> speedDelegate;

@property (nonatomic) BOOL isSubSpeed;

@property NSNumber *subIndex;

@property NSNumber *childIndex;

@property NSInteger selectIdx;

- (NSInteger)getFirstSpeed;

@end


