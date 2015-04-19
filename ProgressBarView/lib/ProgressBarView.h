//
//  ProgressBarView.h
//  ProgressBarView
//
//  Created by xdf on 3/1/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProgressBarView : UIView
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) UIColor *progressBarColor;
@property (strong, nonatomic) UIColor *wrapperColor;
@property (assign, nonatomic) CGFloat progressBarShadowOpacity;
@property (assign, nonatomic) CGFloat progressBarArcWidth;
@property (assign, nonatomic) CGFloat wrapperArcWidth;
@property (assign, nonatomic) CFTimeInterval duration;
@property (assign, nonatomic) CGFloat currentProgress;

- (void)run:(CGFloat)progress;
- (void)pause;
- (void)reset;
@end