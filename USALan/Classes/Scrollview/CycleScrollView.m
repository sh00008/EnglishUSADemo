
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
        
        _currentPage = 0;
    }
    return self;
}

- (void)clearPage
{
    NSArray* array = _scrollView.subviews;
    NSInteger count = array.count;
    while (count != 0) {
        UIView* v = [array objectAtIndex:count - 1];
        [v removeFromSuperview];
        count--;
    }
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
    BOOL bFirst = [_datasource firstPage];
    BOOL bLast = [_datasource lastPage];
    if (bFirst) {
        nSize = 2;
        UIView* v = [_datasource pageAtIndex:1];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * nSize, self.bounds.size.height);
       v.frame = CGRectMake(0, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:v];
        v.tag = KCURRENT;
        v = [_datasource pageAtIndex:2];
        v.frame = CGRectMake(_scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:v];
        v.tag = KNEXT;
        [self setViewContentAtIndex:0 animated:NO];
    } else if (bLast) {
        nSize = 2;
       UIView* v = [_datasource pageAtIndex:0];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * nSize, self.bounds.size.height);
        [_scrollView addSubview:v];
        v.tag = KPREVIOUS;
        
        v = [_datasource pageAtIndex:1];
        v.frame = CGRectMake(_scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:v];
        v.tag = KCURRENT;
        [self setViewContentAtIndex:1 animated:NO];
     
    } else {
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
            [self setViewContentAtIndex:1 animated:NO];
        } else {
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 2, self.bounds.size.height);
            v = [_datasource pageAtIndex:1];
            [_scrollView addSubview:v];
            v.tag = KCURRENT;
            v = [_datasource pageAtIndex:2];
            v.frame = CGRectMake(_scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
            [_scrollView addSubview:v];
            v.tag = KNEXT;
            [self setViewContentAtIndex:0 animated:NO];
        }

    }
}

- (void)setViewContentAtIndex:(NSInteger)index animated:(BOOL)animated{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*index, 0) animated:animated];

}

- (UIView*)getCurrentView {
    int x = _scrollView.contentOffset.x;
    _currentPage = x / _scrollView.frame.size.width;
    UIView* pre = [_scrollView viewWithTag:KPREVIOUS];
    if (pre != nil) {
        switch (_currentPage) {
            case 0:
                return [_scrollView viewWithTag:KPREVIOUS];
                break;
            case 1:
                return [_scrollView viewWithTag:KCURRENT];
                break;
            case 2:
                return [_scrollView viewWithTag:KNEXT];
                
            default:
                break;
        }
    } else {
        switch (_currentPage) {
            case 0:
                return [_scrollView viewWithTag:KCURRENT];
                break;
            case 1:
                return [_scrollView viewWithTag:KNEXT];
               
                break;
                
            default:
                break;
        }
    }
    
    UIView* next = [_scrollView viewWithTag:KNEXT];
    if (next != nil) {
        switch (_currentPage) {
            case 0:
                return [_scrollView viewWithTag:KPREVIOUS];
                break;
            case 1:
                return [_scrollView viewWithTag:KCURRENT];
                break;
            case 2:
                return [_scrollView viewWithTag:KNEXT];
                
            default:
                break;
        }
    } else {
        switch (_currentPage) {
            case 1:
                return [_scrollView viewWithTag:KCURRENT];
                break;
            case 2:
                return [_scrollView viewWithTag:KNEXT];
                
                break;
                
            default:
                break;
        }
    }
    
    return nil;
}

- (void)scrollToPrevious{
    if ([_datasource firstPage]) {
        return;
    }
    
    [UIView animateWithDuration:0.6f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Do your animations here.
                         [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
                    }
                     completion:^(BOOL finished){
                         if (finished) {
                             // Do your method here after your animation.
                             _currentPage = 0;
                             [_datasource didTurnPage:_currentPage];
                             [self setPreviousPage];
                         }
                     }];
    
 }

- (void)scrollToNext {
    if ([_datasource lastPage]) {
        return;
    }
    [UIView animateWithDuration:0.6f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Do your animations here.
                         if ([_datasource firstPage]) {
                             [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
                         } else {
                             [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*2, 0) animated:NO];
                             
                         }
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             // Do your method here after your animation.
                             _currentPage = 2;
                             [_datasource didTurnPage:_currentPage];
                             [self setNextPage];
                         }
                     }];
    

}

- (void)setNextPage {
    if ([_datasource lastPage]) {
        return;
    }
    UIView* p = [_scrollView viewWithTag:KPREVIOUS];
    [p removeFromSuperview];
    
    UIView* current = [_scrollView viewWithTag:KCURRENT];
    current.tag = KPREVIOUS;
    current.frame = CGRectMake(0, 0, current.frame.size.width, current.frame.size.height);
    
    UIView* v = [_scrollView viewWithTag:KNEXT];
    v.tag = KCURRENT;
    v.frame = CGRectMake(current.frame.origin.x + current.frame.size.width, 0, v.frame.size.width, v.frame.size.height);
    
    UIView* newView = [_datasource pageAtIndex:2];
    if (newView != nil) {
        [_scrollView addSubview:newView];
        newView.frame = CGRectMake(current.frame.origin.x + 2*current.frame.size.width, 0, newView.frame.size.width, newView.frame.size.height);
        newView.tag = KNEXT;
        _scrollView.contentSize = CGSizeMake(current.frame.size.width * 3, current.frame.size.height);
        [_scrollView setContentOffset:CGPointMake(current.frame.size.width, 0)];
    
    } else {
        _scrollView.contentSize = CGSizeMake(current.frame.size.width * 2, current.frame.size.height);
        [_scrollView setContentOffset:CGPointMake(current.frame.size.width, 0)];
        
    }
    
  
}

- (void)setPreviousPage {
    //if ([_datasource firstPage]) {
    //    return;
    //}
    UIView* p = [_scrollView viewWithTag:KNEXT];
    [p removeFromSuperview];
    
    UIView* newView = [_datasource pageAtIndex:0];
   UIView* current = [_scrollView viewWithTag:KCURRENT];
    current.tag = KNEXT;
    if (newView != nil) {
        current.frame = CGRectMake(2*current.frame.size.width, 0, current.frame.size.width, current.frame.size.height);
        _scrollView.contentSize = CGSizeMake(3*current.frame.size.width, current.frame.size.height);
    } else {
        current.frame = CGRectMake(current.frame.size.width, 0, current.frame.size.width, current.frame.size.height);
        _scrollView.contentSize = CGSizeMake(2*current.frame.size.width, current.frame.size.height);
    }
    
    UIView* v = [_scrollView viewWithTag:KPREVIOUS];
    v.tag = KCURRENT;
    if (newView != nil) {
        v.frame = CGRectMake(current.frame.size.width, 0, current.frame.size.width, current.frame.size.height);
        _scrollView.contentSize = CGSizeMake(3*current.frame.size.width, current.frame.size.height);
    } else {
        v.frame = CGRectMake(0, 0, current.frame.size.width, current.frame.size.height);
        _scrollView.contentSize = CGSizeMake(2*current.frame.size.width, current.frame.size.height);
    }
  
     if (newView != nil) {
        [_scrollView addSubview:newView];
        newView.frame = CGRectMake(0, 0, newView.frame.size.width, newView.frame.size.height);
        newView.tag = KPREVIOUS;
         [_scrollView setContentOffset:CGPointMake(current.frame.size.width, 0)];
     } else {
         [_scrollView setContentOffset:CGPointMake(0, 0)];
        
     }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_datasource willDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
   // int x = aScrollView.contentOffset.x;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    _currentPage = x / _scrollView.frame.size.width;
    BOOL bFirstPage = [_datasource firstPage];
    BOOL bLastPage = [_datasource lastPage];
    if (bFirstPage && _currentPage == 1) {
        _currentPage = 2;
    }
    
    if (bLastPage && _currentPage == 1) {
        _currentPage = 0;
    }
    
    [_datasource didTurnPage:_currentPage];
    if (_currentPage == 2) {
        [self setNextPage];
    } else if (_currentPage == 0) {
        [self setPreviousPage];
    }     //[_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

@end
