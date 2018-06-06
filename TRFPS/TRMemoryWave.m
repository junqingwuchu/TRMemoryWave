//
//  MemoryWave.m
//  MemoryProgress
//
//  Created by wangluyuan on 2017/11/15.
//  Copyright © 2017年 wangluyuan. All rights reserved.
//

#import "TRMemoryWave.h"
#import "TRMemoryWaveController.h"

@implementation TRMemoryWave

static TRMemoryWave *window;
static CGPoint touchBeganPoint;

+ (void)show {
    if (window) {
        window.hidden = NO;
        [window.rootViewController viewWillAppear:NO];
        return;
    }
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat randomX = arc4random() % 10 / 10.0;
        CGFloat randomY = arc4random() % 10 / 10.0;
        window = [[TRMemoryWave alloc]initWithFrame:CGRectMake((size.width-100)*randomX,(size.height - 100 )*randomY, 100, 100)];
        window.backgroundColor = [UIColor clearColor];
        window.hidden = NO;
        window.windowLevel = UIWindowLevelStatusBar + 1000;
        TRMemoryWaveController *vc = [[TRMemoryWaveController alloc]init];
        vc.view.frame = window.bounds;
        window.rootViewController = vc;

}

+ (void)hide {
    window.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    touchBeganPoint = point;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.center = CGPointMake(self.center.x - (touchBeganPoint.x - point.x), self.center.y - (touchBeganPoint.y - point.y));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    touchBeganPoint = CGPointZero;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    touchBeganPoint = CGPointZero;
}

@end
