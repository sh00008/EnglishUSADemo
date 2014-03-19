
#import "CycleScrollView.h"

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

- (void)setDataource:(id<CycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    [self loadData];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)loadData
{
    if (_curViews.count != 0) {
        return;
    }
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _totalPages, self.bounds.size.height);
    for (NSInteger i = 0; i < _totalPages; i++) {
        
        UIView* v = [_datasource pageAtIndex:i];
        [_curViews addObject:v];

        if (v != nil) {
            v.frame = CGRectMake(_scrollView.frame.size.width * i, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
            [_scrollView addSubview:v];
        }

    }
    /*
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        
        
        //[singleTap release];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];*/
}

/*- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource pageAtIndex:pre]];
    [_curViews addObject:[_datasource pageAtIndex:page]];
    [_curViews addObject:[_datasource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
   // if ([self.delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
   //     [self.delegate didClickPage:self atIndex:_curPage];
   // }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            //[singleTap release];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

- (UIView*)getCurrentView {
    if (_curPage < [_curViews count]) {
        return [_curViews objectAtIndex:_curPage];
    }
    return nil;
}

- (NSInteger)getCurrentPageIndex {
    return _curPage;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}
*/

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index {
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*index, 0) animated:YES];

}

- (UIView*)getCurrentView {
    if (_currentPage < [_curViews count]) {
        return [_curViews objectAtIndex:_currentPage];
    }
    
    return nil;
}

- (NSInteger)getCurrentPageIndex {
    return _currentPage;
}

- (NSInteger)pageCount {
    return [_curViews count];
}

- (void)scrollToNext {
    if (_curPage < [_curViews count]) {
        _currentPage++;
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*_currentPage, 0) animated:YES];

    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
   // int x = aScrollView.contentOffset.x;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    _currentPage = x / _scrollView.frame.size.width;
    //[_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

@end
