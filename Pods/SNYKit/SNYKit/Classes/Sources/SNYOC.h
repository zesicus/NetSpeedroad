//
//  SNY.h
//  NU
//
//  Created by Sunny on 15/05/2018.
//  Copyright © 2018 Juejin-Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//16进制的颜色
#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
#define WEAKSELF  __weak typeof(self) weakSelf = self;

typedef enum{
    CornerLeftTop = 0x1,
    CornerRightTop = 0x1 << 1,
    CornerLeftBottom = 0x1 << 2,
    CornerRightBottom = 0x1 << 3,
    CornerAll = (0x1 << 4) - 1,
}Corner;

@interface SNYOC : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

//把你想变颜色的字列出来，当然你只能传单个字符的数组进去
+ (NSAttributedString *)returnColorfulString:(NSString *)content which:(NSArray *)chars color:(UIColor *)color;

//把你的keyword变成有颜色的字体～
+ (NSAttributedString *)returnColorfulString:(NSString *)content keyword:(NSString *)str color:(UIColor *)color;

//给你的Layer加一个过渡效果，方法里面有详细说明
+ (void)addAnimation:(CALayer *)layer Type:(NSString *)type;

//生成整个View截图，当然如果想截长图传个ScrollView就好了
+ (UIImage *)generateImageFromView:(UIView *)view size:(CGSize)size;

//输入日期显示星期几
+ (NSString*)getWeek:(NSDate *)weekData;

//便利的，加载经纬度方法，只是对公有变量赋值而已
- (id)initWithLatitude:(double)latitude andLongitude:(double)longitude;

/*
 坐标系：
 WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）
 GCJ-02：中国坐标偏移标准，Google Map、高德、腾讯使用
 BD-09 ：百度坐标偏移标准，Baidu Map使用
 */

#pragma mark - 从GPS坐标转化到高德坐标
- (SNYOC *)transformFromGPSToGD;

#pragma mark - 从高德坐标转化到百度坐标
- (SNYOC *)transformFromGDToBD;

#pragma mark - 从百度坐标到高德坐标
- (SNYOC *)transformFromBDToGD;

#pragma mark - 从高德坐标到GPS坐标
- (SNYOC *)transformFromGDToGPS;

#pragma mark - 从百度坐标到GPS坐标
- (SNYOC *)transformFromBDToGPS;

//取得Label里文字数组
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;

//跳动View，类似于蚂蚁森林的感觉
+ (void)jumpAnimationView:(UIView *)sender;
    
//检查手机号到底是不是手机号
+ (BOOL)checkTel:(NSString *)str;

@end
