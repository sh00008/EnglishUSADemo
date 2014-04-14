//
//  ViewController.h
//  USALan
//
//  Created by JiaLi on 14-2-3.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"

@protocol ViewControllerDelegate <NSObject>

- (NSString*)getDataPathWithOutSuffix:(NSInteger)fromPage;

@end

@interface ViewController : UIViewController<CycleScrollViewDatasource,CycleScrollViewDelegate>
@property (nonatomic, strong) UIButton* playButton;
@property (nonatomic, strong) UIButton* previousButton;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger currentNumber;
@property (nonatomic, retain) NSString* pagePath;
@property (nonatomic) id<ViewControllerDelegate> delegate;
@end
