//
//  TRFPSWindow.m
//  Coffee
//
//  Created by wangluyuan on 16/8/3.
//  Copyright © 2016年 承道科技. All rights reserved.
//

#import "TRFPSWindow.h"

@implementation TRFPSWindow

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100;
    }
    return self;
}

@end
