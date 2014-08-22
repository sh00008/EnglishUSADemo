//
//  LessonView.m
//  USALan
//
//  Created by JiaLi on 14-2-5.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "LessonView.h"
#import "SentenceBreaker.h"
@implementation LessonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, frame.size.width / 2 - 20, frame.size.height - 20)];
        [self addSubview:self.imageView];
        self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.imageView.layer.borderWidth = 5.0;
        self.imageView.layer.cornerRadius = 5.0;
        self.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.imageView.layer.shadowOpacity = 0.6;
        self.imageView.layer.shadowOffset = CGSizeMake(5.0, 3.0);
        self.imageView.clipsToBounds = NO;
        
        _textView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width , 20, frame.size.width / 2, frame.size.height - 40)];
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
        _srcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , SIZEOFBUTTON, _textView.frame.size.width, _textView.frame.size.height - SIZEOFBUTTON)];
        _srcLabel.numberOfLines = 0;
        [_srcLabel setFont:[UIFont fontWithName:@"Helvetica" size:IS_IPAD ? 32 : 14]];
        _srcLabel.textAlignment = NSTextAlignmentCenter;
        _srcLabel.backgroundColor = [UIColor clearColor];
        [_textView addSubview:_srcLabel];
        self.currentPos = 0;
        
    }
    return self;
}

- (void)setTimeInterval:(NSTimeInterval)time {
    _timeInterval = time;
    self.dxInter = (CGFloat)_timeInterval / (CGFloat)([_rangeArray count]);
}

- (void)setLessonImage:(UIImage*)image {
    if (image == nil) {
        return;
    }
    CGSize sz = image.size;
    if (sz.width > sz.height) {
        CGFloat flactor = sz.height / sz.width;
        CGFloat he = flactor * self.imageView.frame.size.width;
        CGFloat wi = self.imageView.frame.size.width;
        he = MIN(he, self.frame.size.height/2 - 40);
        wi = MIN(wi, self.frame.size.width/2 - 40);
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, (self.frame.size.height - he) / 2, wi, he);
    } else {
        CGFloat flactor = sz.width / sz.height;
        CGFloat wi = flactor * self.imageView.frame.size.height;
        CGFloat he = self.imageView.frame.size.height;
        he = MIN(he, self.frame.size.height/2 - 40);
        wi = MIN(wi, self.frame.size.width/2 - 40);
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, (self.frame.size.height - he) / 2, wi, he);
    }
    self.imageView.image = image;
}

- (void)setLessonText:(NSString*)text {
    self.srcLabel.text = text;
    [self.srcLabel sizeToFit];
    self.srcLabel.frame = CGRectMake((self.textView.frame.size.width - self.srcLabel.frame.size.width ) / 2, (self.textView.frame.size.height - self.srcLabel.frame.size.height ) / 2, self.srcLabel.frame.size.width, self.srcLabel.frame.size.height);
    _rangeArray = [[NSMutableArray alloc] init];
    NSInteger posFrom = 0;
    BOOL bhasPunct = NO;
    for (NSInteger i = 0; i < text.length; i++) {
        unichar ch = [text characterAtIndex:i];
       if ([SentenceBreaker isPunct:ch]) {
           bhasPunct = YES;
           NSInteger location = posFrom == 0 ? posFrom : (posFrom+1);
            NSInteger length = i - location ;
            if (length > 1) {
                NSMutableDictionary* posDic = [[NSMutableDictionary alloc] init];
                [posDic setObject:[NSNumber numberWithInt:location] forKey:@"location"];
                [posDic setObject:[NSNumber numberWithInt:length] forKey:@"length"];
                [_rangeArray addObject:posDic];
            }
            posFrom = i;
         }
    }
    if (!bhasPunct && text.length > 0) {
        NSInteger location = 0;
        NSInteger length = text.length ;
        NSMutableDictionary* posDic = [[NSMutableDictionary alloc] init];
        [posDic setObject:[NSNumber numberWithInt:location] forKey:@"location"];
        [posDic setObject:[NSNumber numberWithInt:length] forKey:@"length"];
        [_rangeArray addObject:posDic];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)startAnimation {
    CGFloat x= 0;
    for (; self.currentPos < [_rangeArray count]; self.currentPos ++) {
       [self performSelector:@selector(highligthPos:) withObject:[NSNumber numberWithInt:self.currentPos] afterDelay:x];
        x = (self.currentPos + 1) * self.dxInter;
     }
 }

- (void)highligthPos:(NSNumber*)number{
    NSInteger index = [number intValue];
    self.currentPos = index;
    if (index < [_rangeArray count]) {
       NSMutableDictionary* posDic = [_rangeArray objectAtIndex:index];
        if (posDic) {
            NSInteger location = [[posDic objectForKey:@"location"] intValue];
            NSInteger length = [[posDic objectForKey:@"length"] intValue];
            CGFloat dx =self.timeInterval / ([_rangeArray count] * length);
             CGFloat x = 0;
            for (NSInteger i = 0; i <= length; i++) {
                NSMutableDictionary* singlePos = [[NSMutableDictionary alloc] initWithCapacity:2];
                [singlePos setObject:[NSNumber numberWithInt:location] forKey:@"location"];
                [singlePos setObject:[NSNumber numberWithInt:i] forKey:@"length"];
                [self performSelector:@selector(addAttributToRange:) withObject:singlePos afterDelay:x];
                x = dx- 0.5;
            }
            /*
            self.attributString =
            [[NSMutableAttributedString alloc] initWithString:self.srcLabel.text];
            if (length < self.attributString.length  && (location < self.attributString.length)) {
                [self.attributString addAttribute:NSBackgroundColorAttributeName
                                            value:[UIColor greenColor]
                                            range:NSMakeRange(location, length)];

            }
            [self.srcLabel setAttributedText:self.attributString];
            [self.srcLabel setNeedsDisplay];*/
            if (index == ([_rangeArray count] - 1)) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didPlayNotification" object:nil];
                self.currentPos = 0;
                //[self.attributString removeAttribute:NSBackgroundColorAttributeName
                 //                           range:NSMakeRange(location, length)];
                //[self.srcLabel setAttributedText:self.attributString];
             }
        }
    }
}

- (void)addAttributToRange:(NSMutableDictionary*)dic {
    NSInteger location = [[dic objectForKey:@"location"] intValue];
    NSInteger length = [[dic objectForKey:@"length"] intValue];
    if (self.srcLabel.text == nil) {
        return;
    }
    NSMutableAttributedString* newAttribute =
    [[NSMutableAttributedString alloc] initWithString:self.srcLabel.text];
    if (length < newAttribute.length  && (location < newAttribute.length)) {
        [newAttribute addAttribute:NSBackgroundColorAttributeName
                                    value:[UIColor colorWithRed:232.0/255.0 green:169.0/255.0 blue:221.0 alpha:1.0]
                                    range:NSMakeRange(location, length)];
        
    }
    CATransition *transition = [CATransition new];
    transition.delegate = self;
    transition.type = kCATransitionFromLeft;
    transition.duration = self.dxInter;
    [self.srcLabel setAttributedText:newAttribute];
    //self.attributString = newAttribute;
   [self.srcLabel.layer addAnimation:transition forKey:nil];
   // [self.srcLabel setNeedsDisplay];
 
}

- (void)pause {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.srcLabel.text == nil) {
        return;
    }
    self.attributString =
    [[NSMutableAttributedString alloc] initWithString:self.srcLabel.text];
    [self.srcLabel setAttributedText:self.attributString];
    
}

@end
