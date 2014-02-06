//
//  ViewController.h
//  USALan
//
//  Created by JiaLi on 14-2-3.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
@interface ViewController : UIViewController<CycleScrollViewDatasource,CycleScrollViewDelegate>
@property (nonatomic, strong) UIButton* playButton;
@end
