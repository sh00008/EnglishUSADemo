//

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDelegate;
@protocol CycleScrollViewDatasource;

@interface CycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    NSInteger _totalPages;
    NSInteger _currentPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign,setter = setDataource:) id<CycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<CycleScrollViewDelegate> delegate;

- (void)clearPage;
- (void)reloadData;
- (void)setViewContentAtIndex:(NSInteger)index animated:(BOOL)animated;
- (UIView*)getCurrentView;
- (void)scrollToPrevious;
- (void)scrollToNext;
@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol CycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;
- (void)didTurnPage:(NSInteger)page;
- (BOOL)firstPage;
- (BOOL)lastPage;
- (void)willDragging;
@end
