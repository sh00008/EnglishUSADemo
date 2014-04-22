//
//  ThumbViewController.m
//  USALan
//
//  Created by JiaLi on 14-3-17.
//  Copyright (c) 2014年 JiaLi. All rights reserved.
//

#import "ThumbViewController.h"
#import "ViewController.h"
NSString *const MJCollectionViewCellIdentifier = @"Cell";

#import "MJRefresh.h"
#define COUNTPERPAGE IS_IPAD ? 20 : 15
#define SIZEPERPAGE IS_IPAD ? 160 :(IS_IPHONE5 ? 80 : 70)
#define EDGEPERPAGE IS_IPAD ? UIEdgeInsetsMake(50, 40, 40,40) :UIEdgeInsetsMake(30, 20, 20,20)

@interface ThumbViewController () <MJRefreshBaseViewDelegate>
{
    NSMutableArray *_fakeColor;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSMutableArray* _dataArray;
}

@end

@implementation ThumbViewController

- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
 
    layout.itemSize = CGSizeMake(SIZEPERPAGE, SIZEPERPAGE);
    layout.sectionInset = EDGEPERPAGE;
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    return [self initWithCollectionViewLayout:layout];
}

- (void)loadThumImage {
    NSString* imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"%@", @"/Data/Image/"];
    
	_dataArray = [[NSMutableArray alloc] init];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:imagePath];
	NSString* file = nil;
	while (file = [dirEnum nextObject]) {
		if ([[[file pathExtension] lowercaseString] isEqualToString:@"jpg"]) {
            NSRange r = [file rangeOfString:@"." options:NSBackwardsSearch];
            if (r.location != NSNotFound) {
                NSString* pathWithOutsuffix = [file substringToIndex:r.location];
                [_dataArray addObject:[imagePath stringByAppendingFormat:@"/%@",pathWithOutsuffix]];
            }
        }
			
	}

}
- (void)viewDidLoad
{
    [super viewDidLoad];
   self.title = MAINVIEWTITLESTRING;
   
    // 1.注册
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor colorWithRed:152.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:0.8];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
    [self loadThumImage];
    // 2.假数据
    _fakeColor = [NSMutableArray array];
    if (_dataArray.count > 0) {
        NSInteger count = MIN([_dataArray count], COUNTPERPAGE);
        [_fakeColor addObjectsFromArray:[_dataArray subarrayWithRange:NSMakeRange(0, count)]];
    }

    
    // 3.集成刷新控件
    // 3.1.下拉刷新
//    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//    header.scrollView = self.collectionView;
//    header.delegate = self;
//    // 自动刷新
//    [header beginRefreshing];
//    _header = header;
    
    // 3.2.上拉加载更多
    if (_fakeColor.count < _dataArray.count) {
        MJRefreshFooterView *footer = [MJRefreshFooterView footer];
        footer.scrollView = self.collectionView;
        footer.delegate = self;
        _footer = footer;
    }
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectionView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    // 1.添加假数据
    if ([_fakeColor count] < [_dataArray count] && _fakeColor.count > 0) {
        NSInteger subCount = _dataArray.count - _fakeColor.count;
        subCount = MIN(subCount, COUNTPERPAGE);
        [_fakeColor addObjectsFromArray:[_dataArray subarrayWithRange:NSMakeRange((_fakeColor.count - 1), subCount)]];
    }
    
    // 2.2秒后刷新表格UI
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            break;
            
        case MJRefreshStatePulling:
            break;
            
        case MJRefreshStateRefreshing:
            break;
        default:
            break;
    }
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _fakeColor.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
    NSString* path = _fakeColor[indexPath.row];
    path = [path stringByAppendingFormat:@"%@", @".jpg"];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    UIImageView* subView = (UIImageView*)[cell.contentView viewWithTag:102];
    UILabel* lab = (UILabel*)[cell.contentView viewWithTag:103];
    if (subView == nil) {
        subView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZEPERPAGE, SIZEPERPAGE)];
        [cell.contentView addSubview:subView];
        subView.tag = 102;
        subView.layer.borderColor = [[UIColor whiteColor] CGColor];
        subView.layer.borderWidth = 3.0;
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, subView.frame.size.height , SIZEPERPAGE, 20)];
        [cell.contentView addSubview:lab];
        lab.tag = 103;
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor darkGrayColor];
        
    }
    
    subView.image = image;
    lab.text = [NSString stringWithFormat:@"第%d课", indexPath.row + 1];
    lab.font = [UIFont systemFontOfSize:IS_IPAD? 14:10];
   return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ViewController* nextViewController = [[ViewController alloc] initWithNibName:IS_IPAD? @"VewControlleriPad" : @"VewController" bundle:nil];
    nextViewController.totalCount = [_dataArray count];
    nextViewController.currentNumber = indexPath.row+1;
    nextViewController.pagePath = [_dataArray objectAtIndex:indexPath.row];
    nextViewController.delegate = (id)self;
    [nextViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:nextViewController animated:YES completion:^{}];
}
/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */

- (NSString*)getDataPathWithOutSuffix:(NSInteger)fromPage {
    NSInteger page = fromPage - 1;
    if (page < _dataArray.count && page >= 0) {
        return [_dataArray objectAtIndex:page];
    }
    return nil;
}


- (void)dealloc
{
    NSLog(@"MJCollectionViewController--dealloc---");
    [_header free];
    [_footer free];
}
@end