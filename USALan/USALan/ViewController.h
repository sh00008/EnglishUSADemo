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

@interface ViewController : UIViewController<CycleScrollViewDatasource,CycleScrollViewDelegate> {

}
@property (nonatomic, strong) IBOutlet UIButton* playButton;
@property (nonatomic, strong) IBOutlet UIButton* previousButton;
@property (nonatomic, strong) IBOutlet UIButton* nextButton;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger currentNumber;
@property (nonatomic, retain) NSString* pagePath;
@property (nonatomic) id<ViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UILabel* pageNumberLabel;
@property (nonatomic, strong) IBOutlet UISlider  *slider;
@property (nonatomic, strong) IBOutlet UIView* sliderView;
@property (nonatomic, strong) IBOutlet UIView* toolBarView;
@end
