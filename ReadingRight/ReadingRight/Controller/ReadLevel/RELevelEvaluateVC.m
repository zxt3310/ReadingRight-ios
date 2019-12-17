//
//  RELevelEvaluateVC.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/29.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "RELevelEvaluateVC.h"

@implementation RELevelEvaluateVC
{
    NSArray *levelAry;
    UIView *levelView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"level" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    levelAry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSInteger level = self.level;
    
    level = level<=1000?1000:level;
    
    level = level>=16000?16000:level;
    
    for (int i=0; i<levelAry.count;i++) {
        NSInteger cur = [levelAry[i] integerValue];
        if (level <= cur) {
            level = cur;
            break;
        }
    }
    
    UIView *view = [levelView viewWithTag:level];
    if (view) {
        for (id obj in view.subviews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel *lb = (UILabel *)obj;
                lb.textColor = [UIColor redColor];
            }
        }
    }
}

- (void)naviBack{
    NSArray *contrs = self.navigationController.viewControllers;
    UIViewController *target = contrs[contrs.count - 4];
    [self.navigationController popToViewController:target animated:YES];
}

@end
