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
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UILabel* pageNumberLabel;
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
        self.csView.currentPage = self.currentNumber;
        [self.csView reloadData];
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 20, 64, 64)];
        UIImage* im = [UIImage imageNamed:@"Play.png"];
        im = [UIImage imageWithCGImage:[im CGImage] scale:im.scale orientation:UIImageOrientationDown];
        [_backButton setImage:im forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToThumb) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backButton];
        
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(rc.size.width - 72, rc.size.height - 72, 64, 64)];
        [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];
        
        _pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rc.size.height - 44, rc.size.width, 44)];
        _pageNumberLabel.backgroundColor = [UIColor clearColor];
        _pageNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.currentNumber, self.totalCount];
        _pageNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.pageNumberLabel];
        
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
    return self.totalCount;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    if (index == 0) {
        if (self.currentNumber - 2 < 0) {
            return nil;
        }
    }
    
    if (index == 2) {
        if (self.currentNumber + 1 > self.totalCount) {
            return nil;
        }

    }
    LessonView* lessonView = [[LessonView alloc] initWithFrame:CGRectMake(0, 0, self.csView.frame.size.width, self.csView.frame.size.height)];
    NSString* imagePath = nil;
    switch (index) {
        case 0:
        {
            NSInteger i = self.currentNumber - 1;
            imagePath = [self.delegate getPreviousDataPathWithOutSuffix:i];
        }
            break;
        case 1:
            imagePath = self.pagePath;
            break;
        case 2:
        {
            NSInteger i = self.currentNumber +1;
            imagePath = [self.delegate getNextDataPathWithOutSuffix:i];
        }
            break;
            
        default:
            break;
    }
    UIImage* lessonImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingString:@".jpg"]];
    [lessonView setLessonImage:lessonImage];
    NSString* lessonContent =  [NSString stringWithContentsOfFile:[imagePath stringByAppendingString:@".txt"] encoding: NSASCIIStringEncoding error:nil];
    [lessonView setLessonText:lessonContent];
    return lessonView;
}

- (void)didTurnPage:(NSInteger)page {
    if (page == 0 && self.currentNumber != 1) {
        self.currentNumber--;
       _pageNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.currentNumber, self.totalCount];    }
    
    if (page == 2 && self.currentNumber != self.totalCount) {
        self.currentNumber++;
        _pageNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.currentNumber, self.totalCount];   }
}

- (void)backToThumb {
    [self dismissViewControllerAnimated:YES completion:^(void ) {}];
}

- (void)clickButton {
    NSRange r = [self.pagePath rangeOfString:@"Text" options:NSBackwardsSearch];
    if (r.location != NSNotFound) {
        NSString* path = [self.pagePath substringToIndex:r.location];
        NSString* file = [self.pagePath substringFromIndex:(r.location + r.length)];
        path = [self.pagePath stringByAppendingFormat:@"%@/Voice/%@",file, @".mp3"];
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
   
}

- (void)doNextPlay {
    if (self.currentNumber != self.totalCount) {
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
