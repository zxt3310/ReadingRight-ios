//
//  ZWYTouchView.m
//  QuHaiYoo
//
//  Created by 赵五一 on 2019/9/1.
//  Copyright © 2019 陈恒均. All rights reserved.
//

#import "ZWYTouchView.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <JavaScriptCore/JavaScriptCore.h>

@implementation UIView (ZWYFlexTouch)

FLEXSETBOOL(selected)
- (void)setSelected:(BOOL)selected {
    objc_setAssociatedObject(self, @selector(selected), @(selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)selected {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (void)zwy_flexTouchFits {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:ZWYTouchView.class]) {
            [(ZWYTouchView *)obj checkFlex];
        }
    }];
}

@end

@interface ZWYTouchView ()

@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, strong) NSMutableArray *unselectedArr;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) NSObject *owner;
@end

@implementation ZWYTouchView

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    // 当子 view 的状态为 true 的时候隐藏, 因为 ZWYTouchView 默认为不选中
    if (view.selected) {
        view.hidden = YES;
        [self.selectedArr addObject:view];
    } else {
        [self.unselectedArr addObject:view];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    // 修改子 View 状态
    for (UIView *view in self.selectedArr) {
        view.hidden = !selected;
    }
    for (UIView *view in self.unselectedArr) {
        view.hidden = selected;
    }
}

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}
- (NSMutableArray *)unselectedArr {
    if (!_unselectedArr) {
        _unselectedArr = [NSMutableArray array];
    }
    return _unselectedArr;
}

- (NSArray *)_cal:(NSString *)sValue owner:(NSObject *)owner {
    NSString *componentsText = nil;
    NSMutableArray <NSString *> * flagArr = [NSMutableArray array];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(==)|(!=)|=|>|<|\\+|-|\\*|\\/|\\|\\||&&|<=|>=" options:0 error:&error];
    NSArray <NSTextCheckingResult *> *results = [regex matchesInString:sValue options:0 range:NSMakeRange(0, sValue.length)];
    
    if (results.count == 0) {
        return @[];
    }
    
    for (NSTextCheckingResult *match in results) {
        NSString *flag = [sValue substringWithRange:match.range];
        
        if (!componentsText) {
            componentsText = sValue;
        }
        NSArray *array = [componentsText componentsSeparatedByString:flag];
        componentsText = array.lastObject;
        [flagArr addObject:array.firstObject];
        [flagArr addObject:flag];
    }
    if (componentsText) {
        [flagArr addObject:componentsText];
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    [flagArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((idx + 1) % 2 != 0) {
            // 表达式数字
            NSMethodSignature  *signature = [owner.class instanceMethodSignatureForSelector:NSSelectorFromString(obj)];
            if (signature) {
                // NSInvocation中保存了方法所属的对象/方法名称/参数/返回值
                //其实NSInvocation就是将一个方法变成一个对象
                //2、创建NSInvocation对象
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                //设置方法调用者
                invocation.target = owner;
                //注意：这里的方法名一定要与方法签名类中的方法一致
                invocation.selector = NSSelectorFromString(obj);
                //3、调用invoke方法
                [invocation invoke];
                id value;
                [invocation getReturnValue:&value];
                
                [resultArr addObject:value];
            } else {
                [resultArr addObject:obj];
            }
        } else {
            // 符号
            [resultArr addObject:obj];
        }
        
        if (resultArr.count == flagArr.count) {
            *stop = YES;
        }
    }];
    
    return [NSArray arrayWithArray:resultArr];
}
// 必须为 NSNumber 类
FLEXSET(selected) {
    self.value = sValue;
    self.owner = owner;
    if ([sValue isEqualToString:@"true"]) {
        self.selected = true;
    } else if ([sValue isEqualToString:@"false"]) {
        self.selected = false;
    } else {
        @try {
            sValue = [sValue stringByReplacingOccurrencesOfString:@" " withString:@""];
            sValue = [sValue stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            sValue = [sValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSArray *resArr = [self _cal:sValue owner:owner];
            if (resArr.count > 0) {
                NSString *text = [resArr componentsJoinedByString:@""];
                NSString *func = [NSString stringWithFormat:@"function cal(){ return %@ }", text];
                JSContext *context = [JSContext new];
                [context evaluateScript:func];
                JSValue *cal = context[@"cal"];
                JSValue *value = [cal callWithArguments:nil];
                NSNumber *num = [value toNumber];
                self.selected = num.boolValue;
            } else {
                NSMethodSignature  *signature = [owner.class instanceMethodSignatureForSelector:NSSelectorFromString(sValue)];
                id value = nil;
                if (signature) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    invocation.target = owner;
                    invocation.selector = NSSelectorFromString(sValue);
                    [invocation invoke];
                    [invocation getReturnValue:&value];
                }
                self.selected = [value isKindOfClass:NSNumber.class] ? [value boolValue] : false;
            }
        } @catch (NSException *exception) {
            self.selected = false;
        }
    }
}

- (void)checkFlex {
    [self setFlexselected:self.value Owner:self.owner];
}
@end
