//
//  TRPFS.m
//  Coffee
//
//  Created by wangluyuan on 16/8/3.
//  Copyright © 2016年 wangluyuan. All rights reserved.
//

#import "TRFPS.h"
#import "TRFPSLabel.h"
#import "TRFPSWindow.h"
#import <UIKit/UIKit.h>

@interface TRFPS ()

@end

@implementation TRFPS
{
    UIViewController *_vc;
     TRFPSWindow *_window;
}

+ (instancetype)sharedFPS {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TRFPS alloc]init];
        
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.frame = CGRectMake(0,0 , 300, 40);
        TRFPSLabel *fpsLabel = [TRFPSLabel new];
        [fpsLabel sizeToFit];
        fpsLabel.frame = CGRectMake(1024 - 400, 1, 300, 18);
        [vc.view addSubview:fpsLabel];
        TRFPSWindow *window = [[TRFPSWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = vc;
        window.userInteractionEnabled = NO;
        window.hidden = NO;
        _vc = vc;
        _window = window;

    }
    return self;
}
@end
