//
//  REQuestionView.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/25.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "REQuestionView.h"
#import <BEMCheckBox.h>
#import <objc/runtime.h>

@interface BEMCheckBox (extent)

@property NSString *answer;

@end

@implementation BEMCheckBox (extent)

static const char *pro_ans = "answer";

- (void)setAnswer:(NSString *)answer{
    objc_setAssociatedObject(self, pro_ans, answer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)answer{
    return objc_getAssociatedObject(self, pro_ans);
}

@end

@interface REQuestionView() <BEMCheckBoxDelegate>

@end

@implementation REQuestionView
{
    UILabel *questLb;
    UIView *optionView;
}
@synthesize question = _question;

- (void)onInit{
    [self enableFlexLayout:YES];
    self.flexibleHeight = YES;
}

- (void)setQuestion:(REQuestion *)question{
    _question = question;
    
    questLb.text = question.title;
    
    NSMutableArray *anAry = [NSMutableArray arrayWithObjects:question.erroranswer,question.erroranswers,question.answer, nil];
    anAry = [self aryOfRandomObject:anAry];
    
    for (int i=0; i<anAry.count; i++) {
        UIView *outView = [[UIView alloc] init];
        [outView enableFlexLayout:YES];
        [outView setLayoutAttrStrings:@[@"flexDirection",@"row",@"alignItems",@"center",@"width",@"30%"]];
        
        BEMCheckBox *box = [[BEMCheckBox alloc] init];
        box.onAnimationType = BEMAnimationTypeFill;
        box.offAnimationType = BEMAnimationTypeFill;
        box.tintColor = [UIColor blackColor];
        box.onTintColor = [UIColor blackColor];
        box.onFillColor = [UIColor blackColor];
        box.onCheckColor = [UIColor whiteColor];
        box.delegate = self;
        box.answer = anAry[i];
        
        [box enableFlexLayout:YES];
        [box setLayoutAttrStrings:@[@"width",@"20",@"height",@"18",@"marginRight",@"18"]];
        [outView addSubview:box];
        
        UILabel *lable = [[UILabel alloc] init];
        [lable enableFlexLayout:YES];
        [lable setViewAttrStrings:@[@"fontSize",@"18",@"color",@"#333333"]];
        lable.tag = 100;
        lable.text = anAry[i];
        [outView addSubview:lable];
        
        [optionView addSubview:outView];
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    if ([view isKindOfClass:[BEMCheckBox class]]) {
        return view;
    }
    
    BEMCheckBox *box = nil;
    for (id ojb in view.subviews) {
        if ([ojb isKindOfClass:[BEMCheckBox class]]) {
            box = (BEMCheckBox *)ojb;
        }
    }
    return box;
}

//数组乱序
- (NSMutableArray *)aryOfRandomObject:(NSMutableArray *)ary{
    NSInteger n = ary.count;
    for (int i=0; i<n;i++) {
        int r = arc4random_uniform((int)(n));
        [ary exchangeObjectAtIndex:n-i-1 withObjectAtIndex:r];
    }
    return ary;
}


- (void)didTapCheckBox:(BEMCheckBox *)checkBox{
    self.userInteractionEnabled = NO;
    
    for (UIView *obj in optionView.subviews) {
        UILabel *lable = (UILabel *)[obj viewWithTag:100];
        if ([lable.text isEqualToString:self.question.answer]) {
            lable.textColor = [UIColor greenColor];
        }
    }
    
    UIView *view = checkBox.superview;
    UILabel *rightLb = [view viewWithTag:100];
    if (![rightLb.text isEqualToString:self.question.answer]) {
        rightLb.textColor = [UIColor redColor];
        
        [self.questDelegate viewDidAnswer:NO];
    }else{
        [self.questDelegate viewDidAnswer:YES];
    }
}



@end



