//
//  REDownloadManager.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/30.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REDownloadManager.h"
#import "REDownloadSourceReq.h"
#import "RECheckUpdateReq.h"
#import <SSZipArchive/SSZipArchive.h>

@implementation REDownloadManager

static REDownloadManager *manager = nil;

+ (id)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (void)startDownload{
    
    if (![userInfo defalutUser].activeCode) {
        NSLog(@"设备还未激活，请激活后再下载");
        return;
    }
    
    __weak typeof(self) WeakSelf = self;
    
    RECheckUpdateReq *checkReq = [[RECheckUpdateReq alloc] init];
    [checkReq startWithCompletionBlockWithSuccess:^(RECheckUpdateReq *request){
        NSString *update = [request.responseObject objectForKey:@"msg"];
        if ([update integerValue] != [userInfo defalutUser].lastUpdate || !DataExist()) {
            
            if (WeakSelf.starting) {
                WeakSelf.starting();
            }
            
            REDownloadSourceReq *req = [[REDownloadSourceReq alloc] init];
            
            req.resumableDownloadProgressBlock = ^(NSProgress *prog){
                dispatch_async(dispatch_get_main_queue(), ^{
                    float total = prog.totalUnitCount;
                    float fin = prog.completedUnitCount;
                    if (WeakSelf.prograsBlock) {
                        WeakSelf.prograsBlock(fin/total);
                    }
                });
            };
            
            [req startWithCompletionBlockWithSuccess:^(REDownloadSourceReq *request){
                if (WeakSelf.finish) {
                    WeakSelf.finish(0);
                    [WeakSelf unzip];
                    [userInfo defalutUser].lastUpdate = [update integerValue];
                    [[userInfo defalutUser] save];
                }
            } failure:^(REDownloadSourceReq *request){
                NSLog(@"%@  or Error:  %@",request.responseString,request.error.description);
            }];
        }else{
            if (WeakSelf.finish) {
                WeakSelf.finish(1);
                [[[UIApplication sharedApplication] keyWindow] setRootViewController:[REStaticObj sharedObj].coverVC];
            }
        }
    } failure:^(RECheckUpdateReq *request){
        DLog(@"%@  %@",request.responseString,request.error.description);
    }];
}

- (void)unzip{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *sourceCache = [cache stringByAppendingPathComponent:LocalSource];
    NSString *unzipCache = [cache stringByAppendingPathComponent:@"content"];
    
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:unzipCache isDirectory:&isDirectory];
    if (!(isExist && isDirectory)) {
        NSError *error = nil;
        BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:unzipCache withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            DLog(@"文件夹创建失败 %@",error.description);
            return;
        }
    }
    
    BOOL unzip = [SSZipArchive unzipFileAtPath:sourceCache toDestination:unzipCache overwrite:YES password:nil error:nil];
    if (unzip) {
        self.finish(1);
        NSLog(@"解压成功");
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:[REStaticObj sharedObj].coverVC];
    }
    
}

@end
