//
//  LessonView.m
//  USALan
//
//  Created by JiaLi on 14-2-5.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "LessonView.h"

@implementation LessonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, frame.size.width / 2 - 20, frame.size.height - 20)];
        [self addSubview:self.imageView];
        
        _srcLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width , 20, frame.size.width / 2, frame.size.height - 40)];
        _srcLabel.numberOfLines = 0;
        [_srcLabel setFont:[UIFont systemFontOfSize:26]];
        _srcLabel.textAlignment = NSTextAlignmentCenter;
        _srcLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_srcLabel];
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)startAnimation {
        self.attributString =
        [[NSMutableAttributedString alloc] initWithString:self.srcLabel.text];
    NSLog([self.attributString description]);
    [self.attributString addAttribute:NSBackgroundColorAttributeName
              value:[UIColor greenColor]
              range:NSMakeRange(0, self.attributString.length)];
    
    [self.srcLabel setAttributedText:self.attributString];
 }

- (void)pause {
    [self.srcLabel setAttributedText:nil];
   
}

@end
