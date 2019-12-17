//
//  REActiveReq.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/30.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REActiveReq.h"

@implementation REActiveReq
{
    id param;
    NSString *activeCode;
    NSString *Imei;
}

- (instancetype)initWithCode:(NSString *)actCode IMEI:(NSString *)imei{
    self = [super init];
    if (self) {
        activeCode = actCode;
        Imei = imei;
        param = [NSDictionary dictionaryWithObjectsAndKeys:actCode,@"actcode",imei,@"imei",@"上海",@"prov",@"徐汇区",@"city", nil];
    }
    return self;
}

- (NSString *)requestUrl{
    return @"device-activation";
}

- (id)requestArgument{
    return param;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (void)startRequest{
    [self startWithCompletionBlockWithSuccess:^(REActiveReq *req){
        NSDictionary *returnDic = req.responseObject;
        NSInteger res = [[returnDic objectForKey:@"err"] integerValue];
        if (res !=0) {
            DLog(@"%@",req.responseString);
            return;
        }
        
        userInfo *info = [userInfo defalutUser];
        info.activeCode = self->activeCode;
        info.imei = self->Imei;
        info.exp = [returnDic objectForKey:@"exp"];
        [info save];
        
        [TYSaleCookieTool saveCookieWithName:@"expire3Days" Value:self->activeCode domain:RE_api_Domain expire:3600*24*3];
        
        
        if (self.res) {
            self.res(nil);
        }
        
    } failure:^(REActiveReq *req){
        DLog(@"%@",req.responseString);
    }];
}

@end
