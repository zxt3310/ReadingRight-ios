//
//  RELevelTestReadingVC.m
//  ReadingRight
//
//  Created by zhangxintao on 2019/10/28.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "RELevelTestReadingVC.h"

#define FONT_SIZE 22

#define Height 50
#import <CoreText/CoreText.h>
#import "RETestViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RELevelTestReadingVC ()

@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) NSURL *savePath;

@end

@implementation RELevelTestReadingVC
{
    FlexScrollView *_contentView;
    UIView *containorView;
    UILabel *titleLb;
    UILabel *countLb;
    //文章分行
    NSArray *finalAry;
    
    BOOL isLayout;
    
    FlexTextView *testBtn;
    UIView *countDownView;
    UILabel *timerLb;
    NSTimer *timer;
    int time;
    
    UILabel *bgmLb;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    time = 1;
    
    titleLb.text = self.book.title;
    countLb.text = [NSString stringWithFormat:@"%ld字",(long)self.book.content.length];
    
    _contentView.pagingEnabled = YES;
    isLayout = NO;
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
    
    isLayout = YES;
    
    [self startCountDown];
}


- (void)startCountDown{
    timerLb.text = [NSString stringWithFormat:@"%lds",(long)time];
    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(freshLb) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)freshLb{
    
    time++;
    timerLb.text = [NSString stringWithFormat:@"%lds",(long)time];
    
}

//去答题
- (void)gotoTest{
    RETestViewController *testVC = [[RETestViewController alloc] init];
    testVC.book = self.book;
    testVC.needLevel = YES;
    testVC.seconds = time;
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
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

