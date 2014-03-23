
#import "CycleScrollView.h"
#define KCURRENT 2014
#define KPREVIOUS 2013
#define KNEXT 2015
@implementation CycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _curViews = [[NSMutableArray alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        _curPage = 0;
    }
    return self;
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    [self loadData];
}

- (void)loadData
{
    if (_curViews.count != 0) {
        return;
    }
    NSInteger nSize = 3;
    UIView* v = [_datasource pageAtIndex:0];
    if (v != nil) {
        // previous not nil
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * nSize, self.bounds.size.height);
        [_scrollView addSubview:v];
        v.tag = KPREVIOUS;
        
        v = [_datasource pageAtIndex:1];
        v.frame = CGRectMake(_scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:v];
        v.tag = KCURRENT;
        v = [_datasource pageAtIndex:2];
        v.frame = CGRectMake(_scrollView.frame.size.width * 2, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:v];
        v.tag = KNEXT;
        
    } else {
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 2, self.bounds.size.height);
        v = [_datasource pageAtIndex:1];
        [_scrollView addSubview:v];
        v.tag = KCURRENT;
        v = [_datasource pageAtIndex:2];
        v.frame = CGRectMake(_scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:v];
        v.tag = KNEXT;
      
    }
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index {
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*index, 0) animated:YES];

}

- (UIView*)getCurrentView {
    if (_currentPage < [_curViews count]) {
        return [_curViews objectAtIndex:_currentPage];
    }
    
    return nil;
}

- (void)scrollToNext {
    _currentPage++;
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*_currentPage, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
   // int x = aScrollView.contentOffset.x;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    _currentPage = x / _scrollView.frame.size.width;
    [_datasource didTurnPage:_currentPage];
    _currentPage = 1;
    //[_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

@end
