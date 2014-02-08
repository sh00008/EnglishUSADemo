//
//  AudioPlayer.m
//  USALan
//
//  Created by JiaLi on 14-2-8.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer
void interruptionListenerCallback (void *userData, UInt32 interruptionState)
{
	/*MDAudioPlayerController *vc = (MDAudioPlayerController *)userData;
	if (interruptionState == kAudioSessionBeginInterruption)
		vc.interrupted = YES;
	else if (interruptionState == kAudioSessionEndInterruption)
		vc.interrupted = NO;*/
}



- (id)init {
    self = [super init];
    return self;
}

- (void)initializeAudio {
    AudioSessionInitialize(NULL, NULL, interruptionListenerCallback, (__bridge void*)self);
	AudioSessionSetActive(true);
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);

}

- (void)play {
    if (self.path == nil) {
        return;
    }
    
    if (self.player.playing == YES)
	{
		[self.player pause];
	}
	else
	{
		if ([self.player play])
		{
			
		}
		else
		{
			NSLog(@"Could not play %@\n", self.player.url);
		}
	}

}

- (void)setPath:(NSString *)p {
    _path = p;
    if (self.player.isPlaying) {
        [self.player pause];
    }
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:p] error:nil];
    [self.player prepareToPlay];
}

- (void)pause {
    if (self.path == nil) {
        return;
    }

}

- (void)stop {
    if (self.path == nil) {
        return;
    }

}

- (NSTimeInterval)getTimeInterval {
    return self.player.duration;
}
@end
