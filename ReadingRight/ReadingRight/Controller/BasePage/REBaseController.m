//
//  REBaseController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/9/27.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REBaseController.h"

@implementation REBaseController
{
    UIImageView *bgView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.image = [UIImage imageNamed:[userInfo defalutUser].bgiId==0?@"main_bg":@"wood"]; //[UIImage imageNamed:@"main_bg"];
    bgView.userInteractionEnabled= YES;
    [self.view addSubview:bgView];
    
    self.avoidKeyboard = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews{
    bgView.frame = self.view.bounds;
    [self.view sendSubviewToBack:bgView];
}

- (void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
