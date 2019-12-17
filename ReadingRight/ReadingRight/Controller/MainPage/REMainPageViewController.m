//
//  REMainPageViewController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/10.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REMainPageViewController.h"
#import "REReadTranViewController.h"
#import "RELimitedViewController.h"
#import "REReadLevelViewController.h"
#import <Flutter/Flutter.h>

@implementation REMainPageViewController
{
    UIImageView *bgView;
    FlutterViewController *flutter;
}

- (void)viewDidLoad{
    //[super viewDidLoad];
    
    bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.image = [UIImage imageNamed:@"main_page_bg"];
    bgView.userInteractionEnabled= YES;
    [self.view addSubview:bgView];
    
    flutter = [[FlutterViewController alloc] init];
    NSString *channelName = @"Read_excellent";

    FlutterMethodChannel *msgChanel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:flutter.binaryMessenger];
    [msgChanel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult res){
        if ([call.method isEqualToString:@"popRoute"]) {
            [self->flutter.navigationController popViewControllerAnimated:YES];
        }

        if ([call.method isEqualToString:@"getBgi"]) {
            res(@([userInfo defalutUser].bgiId));
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    bgView.frame = self.view.bounds;
    [self.view sendSubviewToBack:bgView];
}

- (UIEdgeInsets)getSafeArea:(BOOL)portrait{
    return UIEdgeInsetsZero;
}

- (void)readTrain{
    REReadTranViewController *readVC = [[REReadTranViewController alloc] init];
    [self.navigationController pushViewController:readVC animated:YES];
}

- (void)readLimited{
    RELimitedViewController *limited = [[RELimitedViewController alloc] init];
    [self.navigationController pushViewController:limited animated:YES];
}

- (void)readLevel{
    REReadLevelViewController *levelVC = [[REReadLevelViewController alloc] init];
    [self.navigationController pushViewController:levelVC animated:YES];
}

- (void)giftTrain{
    [self.navigationController pushViewController:flutter animated:YES];
}

@end
