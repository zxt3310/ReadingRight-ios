//
//  REQuestionView.h
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/25.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol REQuestViewDelegate <NSObject>

@optional

- (void)viewDidAnswer:(BOOL)right;

@end

@interface REQuestionView : FlexCustomBaseView

@property (nonatomic) REQuestion *question;

@property (weak) id<REQuestViewDelegate> questDelegate;

@end


