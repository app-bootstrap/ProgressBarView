//
//  ProgressBarView.m
//  ProgressBarView
//
//  Created by xdf on 3/1/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "ProgressBarView.h"

@interface ProgressBarView()
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) CGFloat lastProgress;
@end

@implementation ProgressBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initProcessBar];
    }
    return self;
}

- (void)initProcessBar {
    self.delegate = nil;
    self.progressBarColor = [UIColor whiteColor];
    self.progressBarShadowOpacity = .1f;
    self.progressBarArcWidth = 2.0f;
    self.wrapperArcWidth = 1.0f;
    self.wrapperColor = [UIColor whiteColor];
    self.duration = 0.5f;
    self.currentProgress = 0.0f;
    self.lastProgress = 0.0f;
}

- (void)drawRect:(CGRect)rect {
    CGRect newRect = ({
        CGRect insetRect = CGRectInset(rect, self.wrapperArcWidth + 0.5f, self.wrapperArcWidth + 0.5f);
        CGRect newRect = insetRect;
        newRect.size.width = MIN(CGRectGetMaxX(insetRect), CGRectGetMaxY(insetRect));
        newRect.size.height = newRect.size.width;
        newRect.origin.x = insetRect.origin.x + (CGRectGetWidth(insetRect) - CGRectGetWidth(newRect)) / 2;
        newRect.origin.y = insetRect.origin.y + (CGRectGetHeight(insetRect) - CGRectGetHeight(newRect)) / 2;
        newRect;
    });
    UIBezierPath *outerCircle = [UIBezierPath bezierPathWithOvalInRect:newRect];
    [self.wrapperColor setStroke];
    outerCircle.lineWidth = self.wrapperArcWidth;
    [outerCircle stroke];
}

- (CGPathRef)progressPath {
    CGFloat offset = -M_PI_2;
    CGFloat endAngle = self.currentProgress * 2 * M_PI + offset;
    CGRect rect = self.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(center.x, center.y) - self.progressBarArcWidth / 2;
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:offset endAngle:endAngle clockwise:1];
    return arcPath.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshShapeLayer];
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = self.progressBarArcWidth;
        _shapeLayer.fillColor = nil;
        _shapeLayer.lineJoin = kCALineJoinBevel;
        _shapeLayer.speed = 1.0f;
        [self.layer addSublayer:_shapeLayer];
    }
    _shapeLayer.strokeColor = self.progressBarColor.CGColor;
    _shapeLayer.shadowOpacity = self.progressBarShadowOpacity;
    return _shapeLayer;
}

- (void)refreshShapeLayer {
    self.currentProgress += 0.01f;
    self.shapeLayer.path = [self progressPath];
    if (self.currentProgress != self.lastProgress) {
        CGFloat fromValue = self.lastProgress / self.currentProgress;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.delegate = self.delegate;
        pathAnimation.duration = self.duration;
        pathAnimation.fromValue = @(fromValue);
        pathAnimation.toValue = @(1.0f);
        [self.shapeLayer addAnimation:pathAnimation forKey:@"processAnimation"];
    }
    self.lastProgress = self.currentProgress;
}

- (void)run:(CGFloat)progress {
    if (self.shapeLayer.speed == 0.0f) {
        self.shapeLayer.speed = 1.0f;
    } else {
        self.currentProgress = MAX(MIN(progress, 1.0f), 0.0f);
        [self setNeedsLayout];
    }
}

- (void)pause {
    self.shapeLayer.speed = 0.0f;
}

- (void)reset {
    self.currentProgress = 0.0f;
}

@end