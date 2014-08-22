//
//  LessonView.h
//  USALan
//
//  Created by JiaLi on 14-2-5.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonView : UIView
@property (atomic, strong) UIImageView* imageView;
@property (atomic, strong) UILabel* srcLabel;
@property (atomic, strong) UILabel* tranLabel;
@property (atomic, strong) UIView* textView;
@property NSTimeInterval timeInterval;
@property (atomic, retain) NSMutableArray* rangeArray;
@property (atomic ,assign) CGFloat dxInter;
@property (atomic, assign) NSInteger currentPos;

@property NSMutableAttributedString *attributString;
- (void)setLessonImage:(UIImage*)image;
- (void)setLessonText:(NSString*)text;
- (void)startAnimation;
- (void)pause;
- (void)stop;
@end
