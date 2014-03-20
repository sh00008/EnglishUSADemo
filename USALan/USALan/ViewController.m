//
//  ViewController.m
//  USALan
//
//  Created by JiaLi on 14-2-3.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "ViewController.h"
#import "LessonView.h"
#import "AudioPlayer.h"

@interface ViewController ()
@property CycleScrollView* csView;
@property NSMutableArray* dataArray;
@property NSInteger buttonStatus;
@property (nonatomic, strong) AudioPlayer* player;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonStatus = 0;
    _player = [[AudioPlayer alloc] init];
        // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.csView == nil) {
        UIInterfaceOrientation or = [self interfaceOrientation];// [[UIDevice currentDevice] orientation];
        CGRect f = [[UIScreen mainScreen] bounds];
        CGRect rc =  UIInterfaceOrientationIsPortrait(or)? CGRectMake(0, 0, f.size.width, f.size.height) :  CGRectMake(0, 0, f.size.height, f.size.width);
        _csView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, rc.size.width, rc.size.height)];
        _csView.delegate = self;
        _csView.datasource = self;
        [self.view addSubview:_csView];
        self.csView = _csView;
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(rc.size.width - 72, rc.size.height - 72, 64, 64)];
        [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];
        self.view.backgroundColor = [UIColor colorWithRed:152.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayNotification:) name:@"didPlayNotification" object:nil];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfPages
{
    return 4;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    LessonView* lessonView = [[LessonView alloc] initWithFrame:CGRectMake(0, 0, self.csView.frame.size.width, self.csView.frame.size.height)];
    NSString* imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Data/Text/0%d", index+3];
    UIImage* lessonImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingString:@".jpg"]];
    [lessonView setLessonImage:lessonImage];
    NSString* lessonContent =  [NSString stringWithContentsOfFile:[imagePath stringByAppendingString:@".txt"] encoding: NSASCIIStringEncoding error:nil];
    [lessonView setLessonText:lessonContent];
    return lessonView;
}

- (void)clickButton {
    NSInteger nindex = [self.csView getCurrentPageIndex] + 3;
    NSLog(@"click %d ", nindex);
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Data/Voice/0%d.mp3", nindex];
    self.player.path = path;
    NSTimeInterval inter = [self.player getTimeInterval];
    LessonView* lessonView = (LessonView*)[self.csView getCurrentView];
    if (lessonView != nil) {
        lessonView.timeInterval = inter;
    }
    NSLog(@"%@", lessonView.srcLabel.text);
    if (self.buttonStatus ==
        0) {
        // PLAY
        self.buttonStatus = 1;
        [self.playButton setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
        [self.player play];
        [lessonView startAnimation];
    } else {
        // PAUSE
        self.buttonStatus = 0;
        [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateHighlighted];
        [self.player pause];
        [lessonView pause];
    }
}

- (void)doNextPlay {
    if (self.csView.currentPage < ([self.csView pageCount] - 1) ) {
        [self.csView scrollToNext];
        [self performSelector:@selector(clickButton) withObject:nil afterDelay:0.5];
    }
}

- (void)didPlayNotification:(NSNotification*)object {
    self.buttonStatus = 0;
    [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateSelected];
    [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateHighlighted];
    [self performSelector:@selector(doNextPlay) withObject:nil afterDelay:1.0];

 }

@end
