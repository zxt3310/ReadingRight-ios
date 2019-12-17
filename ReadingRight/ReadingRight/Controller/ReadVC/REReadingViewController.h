//
//  REReadingViewController.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/17.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REReadingViewController : REBaseController <CAAnimationDelegate>

@property REBook *book;

@property NSInteger speed;

@property BOOL isLimited;

@end


