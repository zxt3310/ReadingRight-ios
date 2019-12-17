//
//  REDownloadSourceReq.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/27.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REDownloadSourceReq.h"

@implementation REDownloadSourceReq
{
    id param;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        userInfo *info = [userInfo defalutUser];
        NSString *imei = info.imei;
        NSInteger time = [[NSDate date] timeIntervalSince1970];
        NSString *str = [NSString stringWithFormat:@"ranknow%ld%@",(long)time,imei];
        NSString *md5 = md5HexDigest(str);
        param = [NSDictionary dictionaryWithObjectsAndKeys:imei,@"imei",stringOfNumber(time),@"time",md5,@"md5", nil];
    }
    return self;
}

- (id)requestArgument{
    return param;
}

- (NSString *)resumableDownloadPath{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cache = [cache stringByAppendingPathComponent:LocalSource];
    
    return cache;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"download-docs";
}


- (void)startRequest{
    
}

@end
