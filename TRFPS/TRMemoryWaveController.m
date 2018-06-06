//
//  TRMemoryWaveController.m
//  MemoryProgress
//
//  Created by wangluyuan on 2017/11/15.
//  Copyright © 2017年 wangluyuan. All rights reserved.
//

#import "TRMemoryWaveController.h"
#import "TRWaveView.h"
#import "UIApplication+Memory.h"

@protocol WeakTargetDelegate <NSObject>

- (void)tick:(id)obj;
@end

@interface WeakTarget1 : NSObject<WeakTargetDelegate>

@property (weak,nonatomic)id <WeakTargetDelegate> delegate;

@end



@implementation WeakTarget1

- (void)tick:(id)obj {
    [self.delegate tick:obj];
}

@end

@interface TRMemoryWaveController ()<WeakTargetDelegate>

@property (nonatomic,strong)TRWaveView *waveView;

@end

@implementation TRMemoryWaveController
{
    CADisplayLink *_link;
    NSUInteger _count;
    NSUInteger _duration;
    NSTimeInterval _lastTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TRWaveView *waveView = [[TRWaveView alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
    waveView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:waveView];
    self.waveView = waveView;
    self.waveView.waveHeight = 5;
    self.waveView.speed = 0.8;
    WeakTarget1 *target = [[WeakTarget1 alloc]init];
    target.delegate = self;
    _duration = 3;
    _link = [CADisplayLink displayLinkWithTarget:target selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)dealloc {
    [_link invalidate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.waveView startWaveAnimation];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    //每秒屏幕刷新的次数（帧数）
    float fps = _count / delta;
    _count = 0;
    CGFloat fprogress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (fprogress - 0.2) saturation:1 brightness:0.9 alpha:1];
    CGFloat free = [UIApplication sharedApplication].availableMemory;
    CGFloat used = [UIApplication sharedApplication].memoryUsed;
    CGFloat mprogress = used / (used + free);
    UIColor *firstWaveColor = [UIColor colorWithHue:0.27 * (1-mprogress) saturation:1 brightness:0.9 alpha:1];
    UIColor *secondWaveColor = [UIColor colorWithHue:0.27 * (1-mprogress) saturation:1 brightness:0.9 alpha:0.5];
    self.waveView.firstWaveColor = firstWaveColor;
    self.waveView.secondWaveColor = secondWaveColor;
    self.waveView.progress = mprogress;
    if (_duration % 4 == 0) {
        self.waveView.fpsLabel.text = [NSString stringWithFormat:@"占用:%dMB",(int)used];
    }else if (_duration % 4 == 1){
        self.waveView.fpsLabel.text = [NSString stringWithFormat:@"空闲:%dMB",(int)free];
    }else if (_duration % 4 == 2){
        CGFloat cpu = [UIApplication sharedApplication].cpuUsed;
        self.waveView.fpsLabel.text = [NSString stringWithFormat:@"CPU:%.1f%%",cpu];
    }else {
        self.waveView.fpsLabel.text = [NSString stringWithFormat:@"%dfps",(int)round(fps)];
    }
    self.waveView.fpsLabel.textColor = color;
    
}

- (void)tap {
    _duration ++;
    if (_duration == 4) {
        _duration = 0;
    }
}

@end
