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

#define kDefLineColor [UIColor redColor]
#define kDefLineBgColor [UIColor cyanColor]

@interface SoundWaver()

@property (nonatomic) NSMutableArray *soundMeters;

@end

@implementation SoundWaver

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        _lineSpace = kDefLineSpace;
        _lineWidth = kDefLineWidth;
        
        _lineColor = kDefLineColor;
        _lineBgColor = kDefLineBgColor;
        
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
    
    CGContextSetLineWidth(ctx, _lineWidth);
    
    [self.soundMeters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // draw bg
        CGContextSetStrokeColorWithColor(ctx, _lineBgColor.CGColor);
        CGContextMoveToPoint(ctx, idx * (_lineWidth + _lineSpace) + _lineWidth / 2, _lineWidth / 2);
        CGContextAddLineToPoint(ctx, idx * (_lineWidth + _lineSpace) + _lineWidth / 2, ctn_h - _lineWidth / 2);
        CGContextStrokePath(ctx);
        // draw line
        CGFloat lineStart = (self.maxAmplitude - [obj floatValue]) * (ctn_h - _lineWidth) / (self.maxAmplitude - self.minAmplitude) + _lineWidth / 2;
        if (lineStart != ctn_h - _lineWidth / 2) {
            CGContextSetStrokeColorWithColor(ctx, _lineColor.CGColor);
            CGContextMoveToPoint(ctx, idx * (_lineWidth + _lineSpace) + _lineWidth / 2, lineStart);
            CGContextAddLineToPoint(ctx, idx * (_lineWidth + _lineSpace) + _lineWidth / 2, ctn_h - _lineWidth / 2);
        }
        CGContextStrokePath(ctx);
    }];
    
    UIGraphicsEndImageContext();
}

- (void)updateMeter:(float)power {
    CGFloat ctn_w = self.frame.size.width;
    int lineCount = ctn_w / (_lineWidth + _lineSpace);
    if ((int)ctn_w % (int)(_lineWidth + _lineSpace) >= _lineWidth) {
        lineCount++;
    }
    
    if (lineCount > 0) {
        [self.soundMeters addObject:@([self formula:power])];
        if (self.soundMeters.count > lineCount) {
            NSRange expiredRange = NSMakeRange(0, self.soundMeters.count - lineCount);
            [self.soundMeters removeObjectsInRange:expiredRange];
        }
        [self setNeedsDisplay];
    }
}

- (void)resetWaver {
    CGFloat ctn_w = self.frame.size.width;
    int lineCount = ctn_w / (_lineWidth + _lineSpace);
    if ((int)ctn_w % (int)(_lineWidth + _lineSpace) >= _lineWidth) {
        lineCount++;
    }
    
    if (lineCount > 0) {
        [self.soundMeters removeAllObjects];
        for (int i = 0; i < lineCount; i++) {
            [self.soundMeters addObject:@(self.minAmplitude)];
        }
        [self setNeedsDisplay];
    }
}

- (void)setMaxAmplitude:(float)maxAmplitude {
    _maxAmplitude = [self formula:maxAmplitude];
}

- (void)setMinAmplitude:(float)minAmplitude {
    _minAmplitude = [self formula:minAmplitude];
}

- (NSMutableArray *)soundMeters {
    if (_soundMeters == nil) {
        _soundMeters = [NSMutableArray array];
        [self resetWaver];
    }
    return _soundMeters;
}

- (float)formula:(float)power {
    return _translationFormula ? _translationFormula(power) : powf(10, power / 40);
}

@end
