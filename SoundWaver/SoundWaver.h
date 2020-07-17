//
//  SoundWaver.h
//  Mijian
//
//  Created by linkzr on 2020/6/29.
//  Copyright © 2020 bhrw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SoundWaver : UIView 

@property (nonatomic, assign) float lineSpace;
@property (nonatomic, assign) float lineWidth;

@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *lineBgColor;

// PS: 振幅受转换公式影响，设置振幅前先设置转换公式确保显示正常
@property (nonatomic, copy) float(^translationFormula)(float power); // 自定义转换公式

@property (nonatomic, assign) float maxAmplitude;   // 最大振幅
@property (nonatomic, assign) float minAmplitude;   // 最小振幅

- (void)updateMeter:(float)power;
- (void)resetWaver;

@end

NS_ASSUME_NONNULL_END
