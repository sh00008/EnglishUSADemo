//
//  LessonView.h
//  USALan
//
//  Created by JiaLi on 14-2-5.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonView : UIView
@property UIImageView* imageView;
@property UILabel* srcLabel;
@property UILabel* tranLabel;

- (void)setLessonImage:(UIImage*)image;
@end
