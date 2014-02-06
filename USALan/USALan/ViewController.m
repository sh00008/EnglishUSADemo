//
//  ViewController.m
//  USALan
//
//  Created by JiaLi on 14-2-3.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "ViewController.h"
#import "LessonView.h"
@interface ViewController ()
@property CycleScrollView* csView;
@property NSMutableArray* dataArray;
@property NSInteger buttonStatus;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonStatus = 0;
        // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.csView == nil) {
        UIInterfaceOrientation or = [self interfaceOrientation];// [[UIDevice currentDevice] orientation];
        CGRect f = [[UIScreen mainScreen] bounds];
        CGRect rc =  UIInterfaceOrientationIsPortrait(or)? CGRectMake(0, 0, f.size.width, f.size.height) :  CGRectMake(0, 0, f.size.height, f.size.width);
        _csView = [[CycleScrollView alloc] initWithFrame:rc];
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
    LessonView* lessonView = [[LessonView alloc] initWithFrame:self.csView.frame];
    NSString* imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Data/Text/0%d", index+3];
    UIImage* lessonImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingString:@".jpg"]];
    [lessonView setLessonImage:lessonImage];
    NSString* lessonContent =  [NSString stringWithContentsOfFile:[imagePath stringByAppendingString:@".txt"] encoding: NSASCIIStringEncoding error:nil];
    lessonView.srcLabel.text = lessonContent;
    return lessonView;
}

- (void)clickButton {
    if (self.buttonStatus == 0) {
        self.buttonStatus = 1;
        [self.playButton setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
    } else {
        self.buttonStatus = 0;
        [_playButton setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"PlayHot.png"] forState:UIControlStateHighlighted];
    }
}


@end
