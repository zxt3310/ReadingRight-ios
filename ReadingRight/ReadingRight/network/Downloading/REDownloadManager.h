//
//  REDownloadManager.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/30.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^prograssUpdateBlock)(float prog);
typedef void(^startDown)(void);
typedef void(^finishBlock)(int state);

@interface REDownloadManager : NSObject

@property prograssUpdateBlock prograsBlock;

@property finishBlock finish;

@property startDown starting;

+ (id) sharedManager;

- (void)startDownload;
@end

NS_ASSUME_NONNULL_END
