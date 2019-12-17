//
//  REPreLuanchViewController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/30.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REPreLuanchViewController.h"
#import "REDownloadManager.h"
#import "REActiveReq.h"
#import <AdSupport/AdSupport.h>

@implementation REPreLuanchViewController
{
    UIView *_percentView;
    UILabel *_stateLb;
    UITextField *_activeTF;
    UIView *_downView;
    UILabel *_percentLb;
    FlexTouchView *_actBtn;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *act = [userInfo defalutUser].activeCode;
    
    if(!act){
        _downView.hidden = YES;
    }
    else{
        _activeTF.text = act;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)activeDevice{
    NSString *activeCode = _activeTF.text;
    NSString *imei = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    REDownloadManager *manager = [REDownloadManager sharedManager];
    
    REActiveReq *req = [[REActiveReq alloc] initWithCode:activeCode IMEI:imei];
    [req startRequest];
    
    req.res = ^(id obj){
        [manager startDownload];
    };
    
    manager.starting = ^{
        self->_downView.hidden = NO;
        self->_actBtn.userInteractionEnabled = NO;
    };
    
    manager.prograsBlock = ^(float prog){
        NSString *str = [stringOfPercent((int)(prog*100)) stringByAppendingString:@"%"];
        [self->_percentView setLayoutAttr:@"width" Value:str];
        self->_percentLb.text = str;
        [self->_percentView markDirty];
    };
    
    __weak UILabel *weakLb = _stateLb;
    manager.finish = ^(int state){
        if (state == 0) {
            [self->_percentView setLayoutAttr:@"width" Value:@"100%"];
            self->_percentLb.text = @"100%";
            [self->_percentView markDirty];
            weakLb.text = @"下载完成，正在解压...";
        }else{
            weakLb.text = @"解压成功，正在启动";
        }
    };
}

@end
