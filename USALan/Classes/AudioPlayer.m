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
	NSLog(@"interruptionListenerCallback");
}



- (id)init {
    self = [super init];
    [self initializeAudio];
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
    if (![_path isEqualToString:p]) {
        _path = p;
        
       if (self.player.isPlaying) {
            [self.player pause];
        }
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:p] error:nil];
        [self.player prepareToPlay];
    }
}

- (void)pause {
    if (self.path == nil) {
        return;
    }
    if (self.player.isPlaying) {
        [self.player pause];
    }

}

- (void)stop {
    if (self.path == nil) {
        return;
    }
    
    if (self.player.isPlaying) {
        [self.player pause];
    }
    self.player = nil;
}

- (NSTimeInterval)getTimeInterval {
    return self.player.duration;
}
@end
