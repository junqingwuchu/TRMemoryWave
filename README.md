
![Platform](https://img.shields.io/badge/Platform-iOS-ff69b4.svg)
![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen.svg)
![Author](https://img.shields.io/badge/Author-junqingwuchu-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

# TRMemoryWave
iOSDebug工具,实时监测fps/内存占用

## 0x00 效果
![](TRMemoryWave.gif)


## 0x01 使用
'''
- (void)applicationDidBecomeActive:(UIApplication *)application {
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[TRMemoryWave show];
});
}
'''
