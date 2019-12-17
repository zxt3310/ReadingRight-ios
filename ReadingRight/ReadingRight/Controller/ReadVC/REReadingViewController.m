//
//  REReadingViewController.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/17.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#define FONT_SIZE 22

#define Height 50

#import "REReadingViewController.h"
#import <CoreText/CoreText.h>
#import "RETestViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface REReadingViewController ()

@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) NSURL *savePath;

@end

@implementation REReadingViewController
{
    FlexScrollView *_contentView;
    UIView *containorView;
    UILabel *titleLb;
    UILabel *countLb;
    UILabel *speedLb;
    UIImageView *rulerView;
    UIView *maskView;
    
    //总时间
    CGFloat totalTime;
    //滑动时间
    CGFloat maskTime;
    //文章分行
    NSArray *finalAry;
    //单页行数
    int pageLines;
    //总行数
    int totalLines;
    //总页数
    int pageCount;
    
    BOOL isLayout;
    
    FlexTextView *testBtn;
    UIView *countDownView;
    UILabel *timerLb;
    NSTimer *timer;
    float time;
    
    BOOL _isPause;
    BOOL _isStart;
    
    UIImageView *pauseImg;
    UILabel *pauseLb;
    UILabel *bgmLb;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLimited = NO;
        _isPause = _isStart = NO;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.speed == 0) {
        self.speed = self.book.grade;
    }
    
    titleLb.text = self.book.title;
    countLb.text = [NSString stringWithFormat:@"%ld字",(long)self.book.content.length];
    speedLb.text = [NSString stringWithFormat:@"%ld字/分钟",(long)self.speed];
    
    if (self.isLimited) {
        testBtn.hidden = NO;
        countDownView.hidden = NO;
    }
    _contentView.pagingEnabled = YES;
    isLayout = NO;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadingBook];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}


- (void)loadingBook{
    if (isLayout) {
        return;
    }
    __weak FlexScrollView *weakView = _contentView;
    
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(0, 0, _contentView.bounds.size.width/2, CGFLOAT_MAX);
    lable.numberOfLines = 0;
    lable.font = [UIFont systemFontOfSize:FONT_SIZE];
    lable.text = self.book.content;
    lable.lineBreakMode = kCTLineBreakByCharWrapping;
    
    finalAry = [self getSeparatedLinesFromLabel:lable];
    
    //finalAry = [self separateStr:self.book.content ToAryByContainorWith:_contentView.bounds.size.width - 120];
    
    [finalAry enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop){
        UIView *view = [[UIView alloc] init];
        [weakView.contentView addSubview:view];
        [view enableFlexLayout:YES];
        [view setLayoutAttr:@"height" Value:@"50"];
        [view setLayoutAttr:@"width" Value:@"100%"];
        [view setLayoutAttr:@"alignItems" Value:@"center"];
        
        UILabel *contentLb = [[UILabel alloc] init];
        [contentLb enableFlexLayout:YES];
        [contentLb setLayoutAttrStrings:@[@"width",@"60%",@"height",stringOfNumber(Height)]];
        [contentLb setViewAttrStrings:@[@"fontSize",stringOfNumber(FONT_SIZE),
                                          @"color",@"#333333"]];
        contentLb.text = string;
        [view addSubview:contentLb];
        
        UIView *line = [[UIView alloc] init];
        [line enableFlexLayout:YES];
        [line setLayoutAttr:@"height" Value:@"1"];
        [line setLayoutAttr:@"width" Value:@"100%"];
        [line setViewAttr:@"bgColor" Value:@"black"];
        [view addSubview:line];
        
        [weakView.contentView markDirty];
    }];
    
    //灰色蒙版尺寸重新绘制
    [maskView setLayoutAttr:@"height" Value:stringOfFloat(CGRectGetWidth(_contentView.frame))];
    [maskView markDirty];
    
    totalTime = (float)self.book.content.length/(float)self.speed * 60;
    pageLines = _contentView.frame.size.height/Height;
    totalLines = (int)finalAry.count;
    pageCount = ceilf((float)totalLines/(float)pageLines);
    
    [self.view layoutIfNeeded];
    //调整scroll的内容尺寸 让其高度正好是可视范围的整数  方式动画过后 scroll回弹
    CGSize contSize = _contentView.contentView.frame.size;
    CGFloat pageHeight = _contentView.frame.size.height;
    if (fmodf(contSize.height, pageHeight) != 0) {
        CGFloat a = contSize.height;
        int b = a/pageHeight;
        contSize.height = (b+1)*pageHeight;
    }
    _contentView.contentSize = contSize;
    
    isLayout = YES;
    
    [self startCountDown];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reading];
    });
    
}

- (NSArray *)separateStr:(NSString *)str ToAryByContainorWith:(CGFloat) width{
    NSMutableString *mu_str = [NSMutableString stringWithString:str];
    NSMutableArray *ary = [NSMutableArray array];
    
    do {
        CGFloat temp = 0;
        int length = 1;
        NSString *string = nil;
        do {
            if (mu_str.length < length) {
                break;
            }
            string = [mu_str substringToIndex:length];
            temp = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}
                                        context:nil].size.width;
            length ++;
        } while (width/2 - FONT_SIZE>temp);
        if (!KIsBlankString(string)) {
            [ary addObject:string];
            [mu_str replaceCharactersInRange:NSMakeRange(0, length-1) withString:@""];
        }else{
            break;
        }
       
    } while (mu_str.length>0);
    
    return ary;
}

- (void)reading{
    float during = 0;
    
    int remain = 0;
    if (pageCount>1) {
        during = totalTime/totalLines * pageLines;
    }else{
        remain = totalLines % pageLines;
        //不排除正好满页
        remain = remain==0?pageLines:remain;
        during = totalTime/totalLines *remain;
    }
    
    CABasicAnimation *transAnimi = [CABasicAnimation animationWithKeyPath:@"position"];
    transAnimi.delegate = self;
    transAnimi.fromValue = [NSValue valueWithCGPoint:rulerView.layer.position];
    if (pageCount > 1) {
        transAnimi.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(rulerView.frame), CGRectGetHeight(_contentView.frame) + CGRectGetHeight(rulerView.frame)/2)];
        transAnimi.fillMode = kCAFillModeBackwards;
        transAnimi.removedOnCompletion = YES;
    }else{
        transAnimi.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(rulerView.frame), remain*Height + CGRectGetHeight(rulerView.frame)/2)];
        transAnimi.fillMode = kCAFillModeForwards;
        transAnimi.removedOnCompletion = NO;
    }
    transAnimi.duration = during;
    
    [rulerView.layer addAnimation:transAnimi forKey:@"position"];
    
    pageCount -= 1;
}

- (void)animationDidStart:(CAAnimation *)anim{
    _isStart = YES;
    [timer setFireDate:[NSDate date]];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [timer setFireDate:[NSDate distantFuture]];
    if (pageCount > 0) {
        //翻页
        CGPoint point = _contentView.contentOffset;
        point.y += _contentView.frame.size.height;
        [_contentView setContentOffset:point animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reading];
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isLimited) {
                [self gotoTest];
            }else{
                [self->rulerView.layer removeAnimationForKey:@"position"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }
    _isStart = NO;
}

- (void)startCountDown{
    time = ceilf(totalTime);
    timerLb.text = [NSString stringWithFormat:@"%lds",(long)time];
    timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(freshLb) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer setFireDate:[NSDate distantFuture]];
}

- (void)freshLb{
    if (time == 0) {
        timerLb.text = @"0s";
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
    }else{
        time -= 0.1;
        timerLb.text = [NSString stringWithFormat:@"%ds",(int)time];
    }
}

//去答题
- (void)gotoTest{
    RETestViewController *testVC = [[RETestViewController alloc] init];
    testVC.book = self.book;
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    [rulerView.layer removeAllAnimations];
    rulerView = nil;
    [self.audioPlayer stop];
}

- (void)dealloc
{
    NSLog(@"文章页 dealloc");
}

- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label {
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label bounds];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,MAXFLOAT));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}

//暂停动画
- (void)nx_pauseAnimate
{
    if (!_isStart)
    {
        return;
    }
    
    if (!_isPause) {
        _isPause = YES;
        CFTimeInterval pauseTime = [rulerView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        // 设置layer的timeOffset, 在继续操作也会使用到
        rulerView.layer.timeOffset = pauseTime;
        // local time与parent time的比例为0, 意味着local time暂停了
        rulerView.layer.speed = 0;
        
        [timer setFireDate:[NSDate distantFuture]];
        
        pauseLb.text = @"继续阅读";
        pauseImg.image = [UIImage imageNamed:@"start_read"];
    }
    //继续动画
    else{
        _isPause = NO;
        // 时间转换
        CFTimeInterval pauseTime = rulerView.layer.timeOffset;
        // 计算暂停时间
        CFTimeInterval timeSincePause = CACurrentMediaTime() - pauseTime;
        // 取消
        rulerView.layer.timeOffset = 0;
        // local time相对于parent time世界的beginTime
        rulerView.layer.beginTime = timeSincePause;
        // 继续
        rulerView.layer.speed = 1;
        
        [timer setFireDate:[NSDate date]];
        
        pauseLb.text = @"暂停阅读";
        pauseImg.image = [UIImage imageNamed:@"stop_read"];
    }
    
}


- (NSURL *)savePath{
    if (!_savePath) {
       
        NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"focus" ofType:@"mp3"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        //判断目录是否存在
        BOOL exist = [manager fileExistsAtPath:pathStr];
        if (exist) {
            _savePath = [NSURL URLWithString:pathStr];
        }
    }
        
    return _savePath;
}

- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.savePath error:nil];
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}


- (void)playOn{
    if (self.audioPlayer && !_audioPlayer.isPlaying) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        [self.audioPlayer play];
        bgmLb.text = @"关闭背景音乐";
    }else{
        [self.audioPlayer pause];
        bgmLb.text = @"打开背景音乐";
    }
}

@end
