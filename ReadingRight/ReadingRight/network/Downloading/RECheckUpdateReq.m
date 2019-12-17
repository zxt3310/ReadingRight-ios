//
//  RECheckUpdateReq.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/9.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "RECheckUpdateReq.h"

@implementation RECheckUpdateReq

- (NSString *)requestUrl{
    return @"last-modify";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

@end
