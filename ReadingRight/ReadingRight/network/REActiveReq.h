//
//  REActiveReq.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/30.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN


@interface REActiveReq : REBaseReq

- (instancetype)initWithCode:(NSString *)actCode IMEI:(NSString *)imei;

@end

NS_ASSUME_NONNULL_END
