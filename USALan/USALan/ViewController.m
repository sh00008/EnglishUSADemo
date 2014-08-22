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
#import "FilePathGet.h"
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
        [self.view bringSubviewToFront:self.toolBarView];
        self.csView = _csView;
        [self.csView reloadData];
        //_backButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 20, SIZEOFBUTTON, SIZEOFBUTTON)];
        //UIImage* im = [UIImage imageNamed:@"back.png"];
        //[_backButton setImage:im forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToThumb) forControlEvents:UIControlEventTouchUpInside];
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake((rc.size.width - (SIZEOFBUTTON + BUTTONOFFSET))/2, rc.size.height - (SIZEOFBUTTON + BUTTONOFFSET), SIZEOFBUTTON, SIZEOFBUTTON)];
        [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];
  
        _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(_playButton.frame.origin.x - 2*SIZEOFBUTTON, rc.size.height - (SIZEOFBUTTON + BUTTONOFFSET), SIZEOFBUTTON, SIZEOFBUTTON)];
        [_previousButton setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(clickPreviousButon) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.previousButton];
  
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(_playButton.frame.origin.x + 2*SIZEOFBUTTON, rc.size.height - (SIZEOFBUTTON + BUTTONOFFSET), SIZEOFBUTTON, SIZEOFBUTTON)];
        [_nextButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.nextButton];
        
        /*_pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rc.size.height - 44, rc.size.width, 44)];
        _pageNumberLabel.backgroundColor = [UIColor clearColor];
        _pageNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.currentNumber, self.totalCount];
        _pageNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.pageNumberLabel];*/
        
        self.view.backgroundColor = [UIColor colorWithRed:152.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayNotification:) name:@"didPlayNotification" object:nil];
        [self initSliderView];
    }
}

- (void)initSliderView {
    
    [self.slider addTarget:self action:@selector(didChangedSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(didChangedSlider:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(changingSlider:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"BookView_Bottom.png"]
                                stretchableImageWithLeftCapWidth:2.0
                                topCapHeight:10.0];
    
    UIImageView *sliderBackgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    sliderBackgroundView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.sliderView.frame.size.height);
    
    [self.sliderView addSubview:sliderBackgroundView];
    [self.sliderView sendSubviewToBack:sliderBackgroundView];
    
    //For iOS7
    if (IS_IOS7) {
        [self.slider setMinimumTrackTintColor:[UIColor colorWithRed:0.91f green:0.48f blue:0.14f alpha:1.00f]];
        [self.slider setMaximumTrackTintColor:[UIColor colorWithRed:0.85f green:0.80f blue:0.76f alpha:1.00f]];
    }
    
    //[self.slider setThumbImage:[UIImage imageNamed:@"BookView_SliderThumbImage@2x.png"] forState:UIControlStateNormal];
    //[self.slider setThumbImage:[UIImage imageNamed:@"BookView_SliderThumbImage2x.png"] forState:UIControlStateHighlighted];
    
    if (IS_IPAD) {
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    } else {
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    
        
     //[self.view bringSubviewToFront:self.sliderView];
    //self.sliderView.exclusiveTouch = YES;
    self.slider.maximumValue = self.totalCount;
    self.slider.minimumValue = 1;
    //self.slider.continuous = NO;
    self.slider.userInteractionEnabled = YES;
    [self showPageNumber];
}

- (IBAction)didChangedSlider:(id)sender {
    [self stop];
    self.currentNumber = self.slider.value;
    [self showPageNumber];
    [self.csView clearPage];
    [self.csView reloadData];
    [self.view bringSubviewToFront:self.toolBarView];
}

- (IBAction)changingSlider:(id)sender {
    self.currentNumber = self.slider.value;
    [self showPageNumber];
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
        if (self.currentNumber - 1 <= 0) {
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
            imagePath = [self.delegate getDataPathWithOutSuffix:i];
        }
            break;
        case 1:
            imagePath = [self.delegate getDataPathWithOutSuffix:self.currentNumber];
            break;
        case 2:
        {
            NSInteger i = self.currentNumber +1;
            imagePath = [self.delegate getDataPathWithOutSuffix:i];
        }
            break;
            
        default:
            break;
    }
    UIImage* lessonImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingString:@".jpg"]];
    [lessonView setLessonImage:lessonImage];
    NSString* lessonContent = [FilePathGet getTextFileContent:imagePath];
    [lessonView setLessonText:lessonContent];
    return lessonView;
}

- (void)showPageNumber {
    _pageNumberLabel.text = [NSString stringWithFormat:@"%ld / %ld", self.currentNumber, (long)self.totalCount];
    self.slider.value = self.currentNumber;
}

- (void)didTurnPage:(NSInteger)page {
    if (page == 0 && self.currentNumber != 1) {
        self.currentNumber--;
        [self showPageNumber];
    }
    if (page == 2 && self.currentNumber != self.totalCount) {
        self.currentNumber++;
        [self showPageNumber];

    }
}

- (BOOL)firstPage {
    return self.currentNumber == 1;
}

- (BOOL)lastPage {
    return self.currentNumber == self.totalCount;
}

- (void)willDragging {
    [self stop];
}

- (void)backToThumb {
    [self stop];
    [self dismissViewControllerAnimated:YES completion:^(void ) {}];
}

- (void)clickPreviousButon {
    [self stop];
    [self.csView scrollToPrevious];
}

- (void)clickNextButton {
    [self stop];
    [self.csView scrollToNext];

}
- (void)clickButton {
    self.pagePath = [self.delegate getDataPathWithOutSuffix:self.currentNumber];
    self.player.path = [FilePathGet getmp3FilePath:self.pagePath];
    if (self.player.path == nil) {
        return;
    }
        NSTimeInterval inter = [self.player getTimeInterval];
        LessonView* lessonView = (LessonView*)[self.csView getCurrentView];
        if (lessonView != nil) {
            lessonView.timeInterval = inter;
        }
        if (self.buttonStatus ==
            0) {
            // PLAY
            self.buttonStatus = 1;
            [self.playButton setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
            [lessonView startAnimation];
            [self.player play];
        } else {
            // PAUSE
            self.buttonStatus = 0;
            [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
             [self.player pause];
            [lessonView pause];
        }
   
}

- (void)doNextPlay {
    if (self.currentNumber != self.totalCount) {
        [self.csView scrollToNext];
        [self performSelector:@selector(clickButton) withObject:nil afterDelay:2.0];
    }

}

- (void)didPlayNotification:(NSNotification*)object {
    self.buttonStatus = 0;
    [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    [self performSelector:@selector(doNextPlay) withObject:nil afterDelay:2.0];

 }

- (void)stop {
    self.buttonStatus = 0;
    [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    [self.player stop];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    LessonView* lessonView = (LessonView*)[self.csView getCurrentView];
    [lessonView stop];
}

@end
