//
//  ViewController.m
//  ProgressBarView
//
//  Created by xdf on 4/19/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "ViewController.h"
#import "ProgressBarView.h"

@interface ViewController ()
@property (nonatomic) ProgressBarView *progressBarView;
@property (nonatomic) UILabel *processLabel;
@property (nonatomic) UIButton *startButton;
@property (nonatomic) UIButton *pauseButton;
@property (nonatomic) UIButton *resetButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor];
    [self initProcessBarView];
    [self initProcessLabel];
    [self initControlPanel];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColor {
    UIColor *color = [UIColor colorWithRed:220.0f / 255.0f green:220.0f / 255.0f blue:220.0f / 255.0f alpha:1];
    self.view.backgroundColor = color;
}

- (void)initProcessBarView {
    self.progressBarView = [[ProgressBarView alloc]initWithFrame:CGRectMake(100, 200, self.view.frame.size.width / 2, self.view.frame.size.width / 2)];
    [self.progressBarView setBackgroundColor:[UIColor clearColor]];
    self.progressBarView.delegate = self;
    self.progressBarView.progressBarColor = [UIColor whiteColor];
    self.progressBarView.progressBarShadowOpacity = .1f;
    self.progressBarView.progressBarArcWidth = 2.0f;
    self.progressBarView.wrapperColor = [UIColor colorWithRed: 240.0 / 255.0 green:240.0 / 255.0 blue: 240.0 / 255.0 alpha: .5];
    self.progressBarView.duration = 1.0f;
    [self.view addSubview: self.progressBarView];
    [self.progressBarView run: 0.0f];
}

- (void)animationDidStop:(CAAnimation *)processAnimation finished:(BOOL)flag {

    NSString *stringFloat = [NSString stringWithFormat:@"%f", round(self.progressBarView.currentProgress * 100)];
    NSInteger stringInt=[stringFloat intValue];
    NSLog(@"current at %ld", (long)stringInt);
    
    if (self.progressBarView.currentProgress < 1.0) {
        self.processLabel.text = [NSString stringWithFormat:@"%ld%@", stringInt, @"%"];
        [self.progressBarView run:self.progressBarView.currentProgress];
    } else {
        [self.progressBarView run: 0.0f];
    }
}

- (void)initProcessLabel {
    NSInteger labelWidth = 40;
    NSInteger labelHeight = 20;
    self.processLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.progressBarView.frame.size.width - labelWidth) / 2, (self.progressBarView.frame.size.height - labelHeight) / 2, labelWidth, labelHeight)];
    self.processLabel.text = @"0%";
    self.processLabel.numberOfLines = 1;
    self.processLabel.textAlignment = NSTextAlignmentRight;
    self.processLabel.font = [self.processLabel.font fontWithSize:14];
    self.processLabel.textColor = [UIColor colorWithRed:25.0 / 255.0 green:25.0 / 255.0 blue:25.0 / 255.0 alpha:.6];
    self.progressBarView.duration = .1f;
    [self.progressBarView addSubview: self.processLabel];
}

- (void)initControlPanel {
    NSInteger buttonHeight = self.progressBarView.frame.origin.y + self.progressBarView.frame.size.height + 30;
    self.startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.startButton.frame = CGRectMake((self.view.frame.size.width - 70) / 2 - 80, buttonHeight, 70, 35);
    self.startButton.backgroundColor = [UIColor clearColor];
    [self.startButton setTitle:@"start" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startProgress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.startButton];
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.pauseButton.frame = CGRectMake((self.view.frame.size.width - 70) / 2, buttonHeight, 70, 35);
    self.pauseButton.backgroundColor = [UIColor clearColor];
    [self.pauseButton setTitle:@"pause" forState:UIControlStateNormal];
    [self.pauseButton addTarget:self action:@selector(pauseProgress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.pauseButton];
    self.resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.resetButton.frame = CGRectMake((self.view.frame.size.width - 70) / 2 + 80, buttonHeight, 70, 35);
    self.resetButton.backgroundColor = [UIColor clearColor];
    [self.resetButton setTitle:@"reset" forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetProgress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.resetButton];
}

- (void)startProgress {
    NSLog(@"start progress");
    [self.progressBarView run: 0.0f];
}

- (void)pauseProgress {
    NSLog(@"pause progress");
    [self.progressBarView pause];
}

- (void)resetProgress {
    NSLog(@"reset progress");
    [self.progressBarView reset];
}

@end
