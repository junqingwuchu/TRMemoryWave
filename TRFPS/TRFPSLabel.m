//
//  TRFPSLabel.m
//  Coffee
//
//  Created by wangluyuan on 16/8/3.
//  Copyright © 2016年 wangluyuan. All rights reserved.
//

#import "TRFPSLabel.h"
#import "UIApplication+Memory.h"

#define kSize CGSizeMake(55, 20)

@implementation TRFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        
        _font = [UIFont fontWithName:@"Menlo" size:14];
        if (_font) {
            _subFont = [UIFont fontWithName:@"Menlo" size:4];
        } else {
            _font = [UIFont fontWithName:@"Courier" size:14];
            _subFont = [UIFont fontWithName:@"Courier" size:4];
        }
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }    

    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
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
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    [text addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(text.length - 4, 1)];
    CGFloat used = [UIApplication sharedApplication].memoryUsed;
    CGFloat free = [UIApplication sharedApplication].availableMemory;
    UIColor *color2 = [UIColor colorWithHue:0.27 * (1-(used/200.0)) saturation:1 brightness:0.9 alpha:1];
    NSMutableAttributedString *memory =[ [NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" 常驻：%.2f MB",used]];
    [memory addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(memory.length - 2, 2)];
    [memory addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, memory.length)];
    [memory addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(memory.length - 3, 0)];
    [memory addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0, memory.length - 3)];
    [text appendAttributedString:memory];
    
    NSMutableAttributedString *freeMemory =[ [NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" 空闲：%.2f MB",free]];
    [freeMemory addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(freeMemory.length - 2, 2)];
    [freeMemory addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, freeMemory.length)];
    [freeMemory addAttribute:NSFontAttributeName value:_subFont range:NSMakeRange(freeMemory.length - 3, 0)];
    [freeMemory addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0, freeMemory.length - 3)];
    [text appendAttributedString:freeMemory];
    
    self.attributedText = text;
}
@end

