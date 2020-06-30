//
//  ViewController.m
//  SoundWaver
//
//  Created by linkzr on 2020/6/29.
//  Copyright © 2020 linkzr. All rights reserved.
//

#import "ViewController.h"
#import "SoundWaver.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController () {
    AVAudioPlayer *player;
    CADisplayLink *timer;
    SoundWaver *waver;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    waver = [[SoundWaver alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    waver.center = self.view.center;
    [self.view addSubview:waver];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(waver.center.x - 50, waver.frame.origin.y + 60, 100, 30)];
    [btn setTitle:@"play" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(playAudio) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)playAudio {
    if (player) {
        [player stop];
        player = nil;
        
        [timer removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [timer invalidate];
        timer = nil;
    } else {
        NSError *error;
        NSString *recordPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
        NSURL *url = [NSURL URLWithString:recordPath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        player.meteringEnabled = YES;
        if ([player prepareToPlay]) {
            [player play];
        }
        
        timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
        [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)updateMeters {
    if (!player) return;
    [player updateMeters];
    float power = [player averagePowerForChannel:0];
    [waver updateMeter:power];
}

@end
