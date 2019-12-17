
//
//  RESpeedModel.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/11.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "RESpeedModel.h"

@implementation gradeModel


@end


@implementation RESpeedModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
             @"lower":[gradeModel class],
             @"higher":[gradeModel class]
             };
}

@end

@implementation REBook

@synthesize path = _path;

- (void)setPath:(NSString *)path{
    _path = path;
    
    if ([path containsString:@"images"]) {
        _path = [path stringByReplacingOccurrencesOfString:@"images/" withString:@""];
    }
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
             @"questions":[REQuestion class],
             };
}

@end


@implementation REQuestion



@end
