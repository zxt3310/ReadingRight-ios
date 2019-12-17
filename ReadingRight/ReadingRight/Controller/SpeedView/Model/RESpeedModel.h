//
//  RESpeedModel.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/11.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface gradeModel : NSObject
@property NSString *title;
@property NSArray <NSNumber *> *spd;
@property NSInteger min;
@property NSInteger max;
@end

@interface RESpeedModel : NSObject <YYModel>

@property NSArray <gradeModel *> *lower;
@property NSArray <gradeModel *> *higher;

@end

@interface REQuestion : NSObject
@property NSString *title;
@property NSString *answer;
@property NSString *erroranswer;
@property NSString *erroranswers;
@end

@interface REBook : NSObject <YYModel>
@property NSInteger id_assoc;
@property NSString *title;
@property NSString *content;
@property (nonatomic) NSString *path;
@property NSInteger grade;
@property NSArray <REQuestion *> *questions;
@end

NS_ASSUME_NONNULL_END
