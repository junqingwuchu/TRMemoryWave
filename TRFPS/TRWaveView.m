//
//  WaveView.m
//  MemoryProgress
//
//  Created by wangluyuan on 2017/11/15.
//  Copyright © 2017年 wangluyuan. All rights reserved.
//

#define LXDefaultFirstWaveColor [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:1]
#define LXDefaultSecondWaveColor [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:0.3]

#import "TRWaveView.h"

@interface TRWaveView ()
@property (nonatomic,assign)CGFloat yHeight;
@property (nonatomic,assign)CGFloat offset;
@property (nonatomic,assign)BOOL start;
@property (nonatomic,strong)CAShapeLayer *firstWaveLayer;
@property (nonatomic,strong)CAShapeLayer *secondWaveLayer;

@end
@implementation TRWaveView

-(void)dealloc {
    if (_firstWaveLayer) {
        [_firstWaveLayer removeFromSuperlayer];
        _firstWaveLayer = nil;
    }
    if (_secondWaveLayer) {
        [_secondWaveLayer removeFromSuperlayer];
        _secondWaveLayer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, MIN(frame.size.width, frame.size.height), MIN(frame.size.width, frame.size.height));
        self.layer.cornerRadius = MIN(frame.size.width, frame.size.height) * 0.5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:248/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 5.0f;
        
        self.waveHeight = 5.0;
        self.yHeight = self.bounds.size.height;
        self.speed=1.0;
        
        [self.layer addSublayer:self.firstWaveLayer];
        if (!self.isShowSingleWave) {
            [self.layer addSublayer:self.secondWaveLayer];
        }
        [self addSubview:self.progressLabel];
        [self addSubview:self.fpsLabel];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [self startWaveAnimation];
}

-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    _progressLabel.text = [NSString stringWithFormat:@"%ld%%",[[NSNumber numberWithFloat:progress * 100] integerValue]];
    _progressLabel.textColor=[UIColor colorWithWhite:progress*1.8 alpha:1];
    self.yHeight = self.bounds.size.height * (1 - progress);
    
    self.firstWaveLayer.fillColor = self.firstWaveColor.CGColor;
    self.secondWaveLayer.fillColor = self.secondWaveColor.CGColor;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [self.firstWaveLayer setValue:@(self.yHeight) forKeyPath:@"position.y"];
    [self.secondWaveLayer setValue:@(self.yHeight) forKeyPath:@"position.y"];
    [CATransaction commit];
    if (!self.start) {
        [self startWaveAnimation];
    }
}

#pragma mark -- 开始波动动画
- (void)startWaveAnimation {
    self.start = YES;
    [self waveAnimationForCoreAnimation];
}

- (void)waveAnimationForCoreAnimation {
    UIBezierPath *bezierFristWave = [UIBezierPath bezierPath];
    CGFloat waveHeight = self.waveHeight ;
    CGFloat startOffY = 0;
    CGFloat orignOffY = 0.0;
    
    [bezierFristWave moveToPoint:CGPointMake(0, startOffY)];
    for (CGFloat i = 0.f; i <= self.bounds.size.width * 3; i++) {
        orignOffY = waveHeight * sinf(2 * M_PI / self.bounds.size.width * i + self.offset * M_PI * 2 / self.bounds.size.width);
        [bezierFristWave addLineToPoint:CGPointMake(i, orignOffY)];
    }
    
    [bezierFristWave addLineToPoint:CGPointMake(self.bounds.size.width * 3, orignOffY)];
    [bezierFristWave addLineToPoint:CGPointMake(self.bounds.size.width * 3, self.bounds.size.height)];
    [bezierFristWave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [bezierFristWave addLineToPoint:CGPointMake(0, startOffY)];
    [bezierFristWave closePath];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.duration = 3;
    anim.fromValue = @(0);
    anim.toValue =@(-self.frame.size.width);
    anim.repeatCount = MAXFLOAT;
    anim.fillMode = kCAFillModeForwards;
    
    self.firstWaveLayer.path = bezierFristWave.CGPath;
    // 添加动画对象到图层上
    [self.firstWaveLayer removeAnimationForKey:@"translate"];
    [self.firstWaveLayer addAnimation:anim forKey:@"translate"];
    
    //第二个波纹
    if (!self.isShowSingleWave) {
        UIBezierPath *bezierSecondeWave = [UIBezierPath bezierPath];
        CGFloat startOffY1 = waveHeight * sinf(self.offset * M_PI * 2 / self.bounds.size.width);
        CGFloat orignOffY1 = 0.0;
        [bezierSecondeWave moveToPoint:CGPointMake( 0, startOffY1)];
        for (CGFloat i = 0.f; i <= self.bounds.size.width * 3; i++) {
            orignOffY1 = waveHeight * cosf(2 * M_PI / self.bounds.size.width * i + self.offset * M_PI * 2 / self.bounds.size.width);
            [bezierSecondeWave addLineToPoint:CGPointMake( i, orignOffY1)];
        }

        [bezierSecondeWave addLineToPoint:CGPointMake( self.bounds.size.width*3, orignOffY1)];
        [bezierSecondeWave addLineToPoint:CGPointMake( self.bounds.size.width*3, self.bounds.size.height)];
        [bezierSecondeWave addLineToPoint:CGPointMake( 0, self.bounds.size.height)];
        [bezierSecondeWave addLineToPoint:CGPointMake( 0, startOffY1)];
        [bezierSecondeWave closePath];
        self.secondWaveLayer.path = bezierSecondeWave.CGPath;
        [self.secondWaveLayer removeAnimationForKey:@"translate"];
        [self.secondWaveLayer addAnimation:anim forKey:@"translate"];
    }
}

#pragma mark ----- LazyingMethod ----
-(CAShapeLayer *)firstWaveLayer {
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.frame = self.bounds;
        _firstWaveLayer.anchorPoint = CGPointZero;
        _firstWaveLayer.fillColor = [UIColor clearColor].CGColor;
        _firstWaveLayer.position = CGPointMake(0, 0);
    }
    return _firstWaveLayer;
}

-(CAShapeLayer *)secondWaveLayer{
    if (!_secondWaveLayer) {
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.frame = self.bounds;
        _secondWaveLayer.position = CGPointMake(0, 0);
        _secondWaveLayer.fillColor = [UIColor clearColor].CGColor;
        _secondWaveLayer.anchorPoint = CGPointZero;
    }
    return _secondWaveLayer;
}

-(UILabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel=[[UILabel alloc] init];
        _fpsLabel.text=@"";
        _fpsLabel.frame=CGRectMake(0, 0, self.bounds.size.width, 30);
        _fpsLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-15);
        _fpsLabel.font=[UIFont systemFontOfSize:14];
        _fpsLabel.textColor=[UIColor colorWithWhite:0 alpha:1];
        _fpsLabel.textAlignment=1;
    }
    return _fpsLabel;
}
-(UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel=[[UILabel alloc] init];
        _progressLabel.text=@"";
        _progressLabel.frame=CGRectMake(0, 0, self.bounds.size.width, 30);
        _progressLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)+10);
        _progressLabel.font=[UIFont systemFontOfSize:18];
        _progressLabel.textColor=[UIColor colorWithWhite:0 alpha:1];
        _progressLabel.textAlignment=1;
    }
    return _progressLabel;
}

@end
