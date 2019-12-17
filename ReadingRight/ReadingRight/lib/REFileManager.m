//
//  REFileManager.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/14.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REFileManager.h"

@implementation REFileManager

static REFileManager *manager = nil;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (id) jsonFromFile:(NSString *)fileName forType:(NSString *)type{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cacheDir = [cache stringByAppendingPathComponent:LocalDirectry];
    NSString *filePath = [cacheDir stringByAppendingPathComponent:[fileName stringByAppendingString:[NSString stringWithFormat:@".%@",type]]];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];

    return [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
}





@end
