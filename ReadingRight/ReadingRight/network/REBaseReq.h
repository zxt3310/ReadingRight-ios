//
//  REBaseReq.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/30.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^resback)(_Nullable id obj);

@interface REBaseReq : YTKRequest
@property resback res;
- (void)startRequest;
@end

NS_ASSUME_NONNULL_END
