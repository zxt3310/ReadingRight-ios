//
//  RECoverpageVC.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/11/6.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "RECoverpageVC.h"
#import "REBgiSelView.h"
#import "REMainPageViewController.h"

@implementation RECoverpageVC
{
    REBgiSelView *bgiView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.view addGestureRecognizer:tap];
}

- (void)goToStart{
    bgiView.hidden = YES;
    [self.navigationController pushViewController:[[REMainPageViewController alloc] init] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)selectBgi{
    bgiView.hidden = !bgiView.hidden;
}

- (void)hideView{
    bgiView.hidden = YES;
}



- (UIEdgeInsets)getSafeArea:(BOOL)portrait{
    return UIEdgeInsetsZero;
}
@end
