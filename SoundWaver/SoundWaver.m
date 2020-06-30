//
//  SoundWaver.m
//  Mijian
//
//  Created by linkzr on 2020/6/29.
//  Copyright © 2020 bhrw. All rights reserved.
//

#import "SoundWaver.h"

#define kDefMaxAmplitude 0
#define kDefMinAmplitude -160

#define kDefLineSpace 9
#define kDefLineWidth 4

@interface SoundWaver()

@property (nonatomic) NSMutableArray *soundMeters;

@end

@implementation SoundWaver

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        lineSpace = kDefLineSpace;
        lineWidth = kDefLineWidth;
        
        self.maxAmplitude = kDefMaxAmplitude;
        self.minAmplitude = kDefMinAmplitude;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat ctn_h = rect.size.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextSetLineWidth(ctx, lineWidth);
    
    [self.soundMeters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // draw bg
        CGContextSetStrokeColorWithColor(ctx, [UIColor cyanColor].CGColor);
        CGContextMoveToPoint(ctx, idx * (lineWidth + lineSpace) + lineWidth / 2, lineWidth / 2);
        CGContextAddLineToPoint(ctx, idx * (lineWidth + lineSpace) + lineWidth / 2, ctn_h - lineWidth / 2);
        CGContextStrokePath(ctx);
        // draw line
        CGFloat lineStart = (self.maxAmplitude - [obj floatValue]) * (ctn_h - lineWidth) / (self.maxAmplitude - self.minAmplitude) + lineWidth / 2;
        if (lineStart != ctn_h - lineWidth / 2) {
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
            CGContextMoveToPoint(ctx, idx * (lineWidth + lineSpace) + lineWidth / 2, lineStart);
            CGContextAddLineToPoint(ctx, idx * (lineWidth + lineSpace) + lineWidth / 2, ctn_h - lineWidth / 2);
        }
        CGContextStrokePath(ctx);
    }];
    
    UIGraphicsEndImageContext();
}

- (void)updateMeter:(float)power {
    CGFloat ctn_w = self.frame.size.width;
    int lineCount = ctn_w / (lineWidth + lineSpace);
    if ((int)ctn_w % (int)(lineWidth + lineSpace) >= lineWidth) {
        lineCount++;
    }
    
    if (lineCount > 0) {
        [self.soundMeters addObject:@(powf(10, power / 40))];
        if (self.soundMeters.count > lineCount) {
            NSRange expiredRange = NSMakeRange(0, self.soundMeters.count - lineCount);
            [self.soundMeters removeObjectsInRange:expiredRange];
        }
        [self setNeedsDisplay];
    }
}

- (void)resetWaver {
    CGFloat ctn_w = self.frame.size.width;
    int lineCount = ctn_w / (lineWidth + lineSpace);
    if ((int)ctn_w % (int)(lineWidth + lineSpace) >= lineWidth) {
        lineCount++;
    }
    
    if (lineCount > 0) {
        for (int i = 0; i < lineCount; i++) {
            [self.soundMeters addObject:@(self.minAmplitude)];
        }
    }
}

- (void)setMaxAmplitude:(float)maxAmplitude {
    _maxAmplitude = powf(10, maxAmplitude / 40);
}

- (void)setMinAmplitude:(float)minAmplitude {
    _minAmplitude = powf(10, minAmplitude / 40);
}

- (NSMutableArray *)soundMeters {
    if (_soundMeters == nil) {
        _soundMeters = [NSMutableArray array];
        [self resetWaver];
    }
    return _soundMeters;
}

- (void)power2Amplitude:(float)power {
    
}

@end
