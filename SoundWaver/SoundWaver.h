//
//  SoundWaver.h
//  Mijian
//
//  Created by linkzr on 2020/6/29.
//  Copyright © 2020 bhrw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SoundWaver : UIView {
    float lineSpace;
    float lineWidth;
}

@property (nonatomic, assign) float maxAmplitude;
@property (nonatomic, assign) float minAmplitude;

- (void)updateMeter:(float)power;
- (void)resetWaver;

@end

NS_ASSUME_NONNULL_END
