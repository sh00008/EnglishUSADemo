//
//  AudioPlayer.h
//  USALan
//
//  Created by JiaLi on 14-2-8.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AudioPlayer : NSObject

- (void)initializeAudio;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, retain) NSString* path;

- (void)play;
- (void)pause;
- (void)stop;
- (NSTimeInterval)getTimeInterval;
@end
