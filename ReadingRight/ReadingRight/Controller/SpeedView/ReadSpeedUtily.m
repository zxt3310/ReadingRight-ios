//
//  ReadSpeedUtily.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/11.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "ReadSpeedUtily.h"
#import "RESpeedModel.h"
#import "ZWYTouchView.h"
#import "ReadSpeedCell.h"

@interface ReadSpeedUtily ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ReadSpeedUtily
{
    ZWYTouchView *lowBtn;
    ZWYTouchView *highBtn;
    UILabel *lowLb;
    UILabel *highLb;
    UIView *_speedSwitchView;
    UIView *gradeView;
    RESpeedModel *speed;
    UITableView *speedTable;
    UILabel *titleLb;
}
@synthesize isSubSpeed = _isSubSpeed;

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"speed" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        speed = [RESpeedModel yy_modelWithJSON:obj];
        _isSubSpeed = YES;
    }
    return self;
}

- (void)onInit{
    self.subIndex = @(0);
    [gradeView zwy_flexTouchFits];
    [self setupChildSpeed];
}

- (void)setIsSubSpeed:(BOOL)isSubSpeed{
    _isSubSpeed = isSubSpeed;
    gradeView.hidden = !isSubSpeed;
    titleLb.hidden = isSubSpeed;
}

- (void)subSwitch:(UITapGestureRecognizer *)sender{
    ZWYTouchView *view = (ZWYTouchView *)sender.view;
    self.subIndex = @([gradeView.subviews indexOfObject:view]);
    [gradeView zwy_flexTouchFits];
    [speedTable reloadData];
    [self callBackToFresh];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (ZWYTouchView *subView in gradeView.subviews){
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

- (void)setupChildSpeed{
    speedTable.delegate = self;
    speedTable.dataSource = self;
    speedTable.rowHeight = UITableViewAutomaticDimension;
    speedTable.tableFooterView = [UIView new];
    speedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    speedTable.backgroundColor = [UIColor clearColor];
    speedTable.estimatedRowHeight = 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.isSubSpeed) {
        if (self.subIndex.integerValue == 0) {
            count = speed.lower.count;
        }else{
            count = speed.higher.count;
        }
    }else{
        if (self.subIndex.integerValue == 0) {
            count = speed.lower[self.childIndex.integerValue].spd.count;
        }else{
            count = speed.lower[self.childIndex.integerValue].spd.count;
        }
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadSpeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ReadSpeedCell alloc] initWithFlex:nil reuseIdentifier:@"cell"];
    }
    cell.choosed = (indexPath.item == self.selectIdx);
    
    NSString *title;
    
    if (self.isSubSpeed) {
        if (self.subIndex.integerValue == 0) {
            title = speed.lower[indexPath.item].title;
        }else{
            title = speed.higher[indexPath.item].title;
        }
    }else{
        if (self.subIndex.integerValue == 0) {
            NSNumber *num = speed.lower[self.childIndex.integerValue].spd[indexPath.item];
            title = [NSString stringWithFormat:@"%ld字/分钟",(long)num.integerValue];
        }else{
            NSNumber *num = speed.higher[self.childIndex.integerValue].spd[indexPath.item];
            title = [NSString stringWithFormat:@"%ld字/分钟",(long)num.integerValue];
        }
    }
    cell.title = title;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (ReadSpeedCell *cell in tableView.visibleCells) {
        cell.choosed = NO;
    }
    ReadSpeedCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.choosed = YES;
    self.selectIdx = indexPath.item;
    
    if (self.isSubSpeed) {
        self.childIndex = @(indexPath.item);
        [self callBackToFresh];
    }else{
        if (self.speedDelegate) {
            if (self.subIndex.integerValue == 0) {
                NSNumber *spd = speed.lower[self.childIndex.integerValue].spd[indexPath.item];
                [self.speedDelegate utilyDidChooseSpped:spd.integerValue];
            }else{
                NSNumber *spd = speed.higher[self.childIndex.integerValue].spd[indexPath.item];
                [self.speedDelegate utilyDidChooseSpped:spd.integerValue];
            }
        }
    }
}

- (void)callBackToFresh{
    gradeModel *grade = nil;
    if (self.subIndex.integerValue == 0) {
        grade = speed.lower[self.childIndex.integerValue];
    }else{
        grade = speed.higher[self.childIndex.integerValue];
    }
    
    if (self.speedDelegate) {
        [self.speedDelegate utilyDidChooseSpeedWithMin:grade.min Max:grade.max];
    }
}

- (NSInteger)getFirstSpeed{
    if (self.isSubSpeed) {
        return 0;
    }
    NSNumber *spd = nil;
    if (self.subIndex.integerValue == 0) {
        spd = speed.lower[self.childIndex.integerValue].spd[0];
    }else{
         spd = speed.higher[self.childIndex.integerValue].spd[0];
    }
    
    return spd.integerValue;
}

- (void)dealloc
{
    NSLog(@"速读选择器 dealloc");
}

@end
