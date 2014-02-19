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
        _textView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width , 20, frame.size.width / 2, frame.size.height - 40)];
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
        _srcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, _textView.frame.size.width, _textView.frame.size.height)];
        _srcLabel.numberOfLines = 0;
        [_srcLabel setFont:[UIFont systemFontOfSize:26]];
        _srcLabel.textAlignment = NSTextAlignmentCenter;
        _srcLabel.backgroundColor = [UIColor clearColor];
        [_textView addSubview:_srcLabel];
        
    }
    return self;
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
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, (self.frame.size.height - he) / 2, wi, he);
    } else {
        CGFloat flactor = sz.width / sz.height;
        CGFloat wi = flactor * self.imageView.frame.size.height;
        CGFloat he = self.imageView.frame.size.height;
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
    for (NSInteger i = 0; i < text.length; i++) {
        unichar ch = [text characterAtIndex:i];
       if ([SentenceBreaker isPunct:ch]) {
           NSInteger location = posFrom == 0 ? posFrom : (posFrom+1);
            NSInteger length = i - posFrom ;
            NSLog(@"%@", [text substringWithRange:NSMakeRange(location, length)]);
            if (length > 1) {
                NSMutableDictionary* posDic = [[NSMutableDictionary alloc] init];
                [posDic setObject:[NSNumber numberWithInt:location] forKey:@"location"];
                [posDic setObject:[NSNumber numberWithInt:length] forKey:@"length"];
                [_rangeArray addObject:posDic];
            }
            posFrom = i;
         }
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
    CGFloat dx =self.timeInterval / [_rangeArray count];
    CGFloat x = 0;
    for (NSInteger i = 0; i < [_rangeArray count]; i ++) {
       [self performSelector:@selector(highligthPos:) withObject:[NSNumber numberWithInt:i] afterDelay:x];
        x = x + dx;
     }
 }

- (void)highligthPos:(NSNumber*)number{
    if ([number intValue] < [_rangeArray count]) {
        NSMutableDictionary* posDic = [_rangeArray objectAtIndex:[number intValue]];
        if (posDic) {
            NSInteger location = [[posDic objectForKey:@"location"] intValue];
            NSInteger length = [[posDic objectForKey:@"length"] intValue];
            self.attributString =
            [[NSMutableAttributedString alloc] initWithString:self.srcLabel.text];
            if (length < self.attributString.length  && (location < self.attributString.length)) {
                [self.attributString addAttribute:NSBackgroundColorAttributeName
                                            value:[UIColor greenColor]
                                            range:NSMakeRange(location, length)];
                if (length < self.srcLabel.text.length) {
                    NSLog(@"highlight %@", [self.srcLabel.text substringWithRange:NSMakeRange(location, length)]);
                }

            }
            [self.srcLabel setAttributedText:self.attributString];
            [self.srcLabel setNeedsDisplay];

        }
    }
}

- (void)pause {
    [self.srcLabel setAttributedText:nil];
   
}

@end
