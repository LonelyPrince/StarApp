

#import "YLSlideView.h"
#import "YLSlideTitleView.h"
//#import "YGPCache.h"

@interface YLSlideView()<UIScrollViewDelegate>
{
    CGPoint      _beginScrollOffset;
    NSInteger    _totaiPageNumber;   //内容总数
    NSMutableSet *_visibleCells;     //可见
    NSMutableSet *_recycledCells;    //循环
    //    NSArray      *_titles;
    NSMutableArray      *_titles;
    NSUInteger   _prePageIndex;
    TVTable * tableViewForSliderView;
}

//
- (void)slideViewRecycle;
- (BOOL)isVisibleCellForIndex:(NSUInteger)index;
//- (void)configCellWithCell:(YLSlideCell*)cell forIndex:(NSUInteger)index;
- (void)configCellWithCell:(TVTable*)cell forIndex:(NSUInteger)index;
//
- (void)configSlideView;

@end

@implementation YLSlideView

- (instancetype)initWithFrame:(CGRect)frame forTitles:(NSMutableArray *)titles{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        tableViewForSliderView = [[UITableView alloc]init];
        //        _titles  = [titles copy];
        _titles = [[NSMutableArray alloc]init];
        self.triangleView = [[UIImageView alloc] init];
        
        _titles = [self titleArrReplace:titles];
        NSLog(@"_titles_titles %@",_titles);
        _prePageIndex = 1000;
        [self configSlideView];
        
        
        //监听Delegate值改变以刷新数据，不想使用者做太多无谓的方法调用
        [self addObserver:self
               forKeyPath:@"delegate"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        
        
        [self setSliderViewAlphaConfig];
    }
    
    return self;
}
-(void)setSliderViewAlphaConfig
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setSliderViewAlphaConfig" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSliderViewAlpha) name:@"setSliderViewAlphaConfig" object:nil];
}
-(void)setSliderViewAlpha
{
    NSLog(@"执行操作--隐藏");
    self.alpha = 0;
    
    double delayInSeconds = 0.25;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        NSLog(@"执行操作--显示4");
        self.alpha = 1;
    });
}
-(NSMutableArray *)titleArrReplace:(NSMutableArray*)titles
{
    NSMutableArray * tempTitlesArr = [[NSMutableArray alloc]init];
    /*
     1.先判断是那种类型，录制和直播节目是否同时存在
     2.根部不同的类别进行数据组合和最后的赋值
     **/
    //#define   RecAndLiveNotHave  @"0"      //录制和直播都不存在
    //#define   RecExit            @"1"      //录制存在直播不存在
    //#define   LiveExit           @"2"      //录制不存在直播存在
    //#define   RecAndLiveAllHave  @"3"      //录制直播都存在
    NSString * RECAndLiveType = [USER_DEFAULT objectForKey:@"RECAndLiveType"];
    NSLog(@"RECAndLiveType %@",RECAndLiveType);
    
    if ([RECAndLiveType isEqualToString:@"RecAndLiveNotHave"]) {  //都不存在
        _titles = tempTitlesArr;
    }else if ([RECAndLiveType isEqualToString:@"RecExit"]){ //录制存在直播不存在
        NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
        [_titles addObject:MLRecording];
    }else if ([RECAndLiveType isEqualToString:@"LiveExit"]){ //录制不存在直播存在
        if(titles.count > 0){
            tempTitlesArr =titles[0];
            for (int i = 0 ; i < tempTitlesArr.count; i++) {
                NSDictionary *item = tempTitlesArr[i];
                NSString * tempArray;
                tempArray =item[@"category_name"];
                
                [_titles addObject:tempArray];
                
            }
        }
        
    }else if([RECAndLiveType isEqualToString:@"RecAndLiveAllHave"]){//都存在
        if (titles.count == 2 ) {   //正常情况
            tempTitlesArr =titles[0];
            for (int i = 0 ; i < tempTitlesArr.count; i++) {
                NSLog(@"tempTitlesArr %@",tempTitlesArr);
                NSDictionary *item = tempTitlesArr[i];
                NSString * tempArray;
                tempArray =item[@"category_name"];
                
                [_titles addObject:tempArray];
                
            }
            NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
            [_titles insertObject:MLRecording atIndex:1];
            NSLog(@"_titles %@",_titles);
        }else if(titles.count == 1 )  //异常刷新，数组中只有一个元素
        {
            tempTitlesArr =titles[0];
            for (int i = 0 ; i < tempTitlesArr.count; i++) {
                
            }
        }
        
    }
    
    return _titles;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"delegate"]) {
        [self reloadData];
    }
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"delegate"];
    
}
#pragma mark RecycledCell

- (void)slideViewRecycle{
    
#warning 此处是重新的写法，默认是加载两个view。如果想加载一个view 可在次修改
    CGRect mainScrollViewBounds = _mainScrollview.bounds;
    
    NSUInteger currentPage = CGRectGetMinX(mainScrollViewBounds)/SCREEN_WIDTH_YLSLIDE;
    
    NSUInteger nextPage    = CGRectGetMaxX(mainScrollViewBounds)/SCREEN_WIDTH_YLSLIDE;
    
    currentPage            = MAX(currentPage, 0);
    nextPage               = MIN(nextPage, _totaiPageNumber-1);
    
    //回收 unvisible cell
    //        for (TVTable * cell  in _visibleCells) {
    //
    //            if (cell.index < currentPage || cell.index > nextPage) {
    //
    //                //保存偏移量
    //                [[YGPCache sharedCache]setDataToMemoryWithData:[NSStringFromCGPoint(cell.contentOffset) dataUsingEncoding:NSUTF8StringEncoding] forKey:[@(cell.index) stringValue]];
    //
    //
    //                [_recycledCells addObject:cell];
    //                [cell removeFromSuperview];
    //
    //            }
    //        }
    
    [_visibleCells minusSet:_recycledCells];
    
    // 添加重用Cell
    for (NSUInteger index = currentPage ; index <= nextPage; index++) {
        
        if (![self isVisibleCellForIndex:index]) {
            
            TVTable *cell = [_delegate slideView:self cellForRowAtIndex:index];
            [self configCellWithCell:cell forIndex:index];
            
            [_visibleCells addObject:cell];
            
        }
    }
}

- (TVTable*)dequeueReusableCell{
    
    TVTable * cell = [_recycledCells anyObject];
    
    if (cell) {
        [_recycledCells removeObject:cell];
    }
    
    return cell;
}

- (BOOL)isVisibleCellForIndex:(NSUInteger)index{
    
    BOOL isVisibleCell = NO;
    
    for (TVTable * cell in _visibleCells) {
        
        if (cell.index == index) {
            isVisibleCell = YES;
            break;
        }
        
    }
    return isVisibleCell;
}

- (TVTable*)visibleCellForIndex:(NSUInteger)index{
    
    TVTable * visibleCell = nil;
    
    visibleCell.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    for (TVTable * cell in _visibleCells) {
        
        if (cell.index == index) {
            visibleCell = cell;
            break;
        }
    }
    return visibleCell;
}

- (void)configCellWithCell:(TVTable*)cell forIndex:(NSUInteger)index{
    
    cell.index            = index;
    CGRect cellFrame      = self.bounds;
    cellFrame.origin.x    = CGRectGetWidth(self.frame)*index;
    cellFrame.size.height = cellFrame.size.height - YLSildeTitleViewHeight;
    
    [cell setFrame:cellFrame];
    [_mainScrollview addSubview:cell];
    
    if ([_delegate respondsToSelector:@selector(slideViewInitiatedComplete:forIndex:)]) {
        [_delegate slideViewInitiatedComplete:cell forIndex:index];
    }
    
    //获取偏移量
    __block TVTable *newCell = cell;
    [[YGPCache sharedCache] dataForKey:[@(cell.index) stringValue] block:^(NSData *data, NSString *key) {
        
        if (data) {
            CGPoint offset = CGPointFromString([[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            [newCell setContentOffset:offset];
        }
    }];
    
    tableViewForSliderView = cell;
    
    //    此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tableViewChangeBlue" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewChangeBlue:) name:@"tableViewChangeBlue" object:nil];
}
-(void)tableViewChangeBlue : (NSNotification *)text
{
    
    
    NSLog(@"====================");
    NSInteger row = [text.userInfo[@"textOne"]integerValue];
    NSInteger row2 = [text.userInfo[@"textTwo"]integerValue];
    NSInteger row3 = [text.userInfo[@"textThree"]integerValue];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"此处记录跳转到那个页面 %ld",(long)row);
        tableViewForSliderView =   [self visibleCellForIndex:row];
        
    });
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row2 inSection:0];
    
    
    
    if ([tableViewForSliderView numberOfSections] > 0) {
        
        if ([tableViewForSliderView numberOfRowsInSection:0] > row2) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([tableViewForSliderView numberOfRowsInSection:0] > row2) {
                    [tableViewForSliderView selectRowAtIndexPath:scrollIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                }else
                {
                    return ;
                }
                
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //                self.tableForSliderView.alpha = 0;
                
                [tableViewForSliderView reloadData];
                
                double delayInSeconds = 0.13;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSLog(@"执行操作--显示1");
                    self.alpha = 1;
                });
                double delayInSeconds1 = 0.18;
                dispatch_queue_t mainQueue1 = dispatch_get_main_queue();
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds1 * NSEC_PER_SEC);
                dispatch_after(popTime1, mainQueue1, ^{
                    NSLog(@"执行操作--显示2");
                    self.alpha = 1;
                });
                
            });
        }else
            
        {
            NSLog(@"总行数小于要跳转的函数，会报错");
        }
    }
    
    double delayInSeconds = 0.18;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        NSLog(@"执行操作--显示3");
        self.alpha = 1;
    });
    
    
}


#pragma make reloadData

- (void)reloadData{
    
    [_visibleCells  removeAllObjects];
    [_recycledCells removeAllObjects];
    
    [[YGPCache sharedCache]removeMemoryAllData];
    
    __WEAK_SELF_YLSLIDE
    
    if ([_delegate respondsToSelector:@selector(columnNumber)]) {
        
        if (weakSelf) {
            
            __STRONG_SELF_YLSLIDE
            
            _totaiPageNumber = [strongSelf->_delegate columnNumber];
            
            [strongSelf.mainScrollview setContentSize:CGSizeMake(CGRectGetWidth(strongSelf.frame)*_totaiPageNumber, CGRectGetHeight(strongSelf.frame)-YLSildeTitleViewHeight)];
            
        }
    }
    
    [self slideViewRecycle];
    
    [self visibleViewDelegateForIndex:0];
    
    
}

- (void)visibleViewDelegateForIndex:(NSUInteger)index{
    
    if (_prePageIndex != index) {
        if ([_delegate respondsToSelector:@selector(slideVisibleView:forIndex:)]) {
            [_delegate slideVisibleView:[self visibleCellForIndex:index] forIndex:index];
            //            [_delegate slideVisibleView:[self visibleCellForIndex:index] forIndex:2];
        }
    }
    
    _prePageIndex = index;
    
}

#pragma mark UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _slideTitleView.isClickTitleButton = NO;
    
    NSLog(@"==- scrollViewWillBeginDragging 开始拖拽");
    
    
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self visibleViewDelegateForIndex:currentPage+ 1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self slideViewRecycle];
    
    if (!_slideTitleView.isClickTitleButton) {
        if (_slideTitleView.slideTitleViewScrollBlock) {
            _slideTitleView.slideTitleViewScrollBlock(scrollView.contentOffset.x);
        }
    }
    
    //    CGFloat pageWidth = scrollView.frame.size.width;
    //    // 根据当前的x坐标和页宽度计算出当前页数
    //    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //    NSLog(@"==- 当scrollView滚动的时候，不停调用 ");
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self visibleViewDelegateForIndex:currentPage];
    
    if (_slideTitleView.slideViewWillScrollEndBlock) {
        _slideTitleView.slideViewWillScrollEndBlock(scrollView.contentOffset.x);
    }
    
    NSLog(@"==- 减速完成（停止） ");
}

#pragma mark configSlideView

- (void)configSlideView{
    
    _visibleCells  = [[NSMutableSet alloc]init];
    _recycledCells = [[NSMutableSet alloc]init];
    
    self.mainScrollview = ({
        
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-5, YLSildeTitleViewHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-YLSildeTitleViewHeight)]; //此处修改了起始位置
        scrollView.bounces         = NO;
        scrollView.delegate        = self;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.pagingEnabled   = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        scrollView;
    });
    NSLog(@"_mainScrollview.f %@",_mainScrollview);
    [self addSubview:_mainScrollview];
    
    self.slideTitleView = ({
        
        CGRect slideTitleFrame;
        slideTitleFrame.origin = CGPointMake(10, 0);
        slideTitleFrame.size   = CGSizeMake(CGRectGetWidth(self.frame)-58, 48); //修改  xiugai  44 留出pt=48的空间放按钮
        
        YLSlideTitleView * slideTitleView = [[YLSlideTitleView alloc]initWithFrame:slideTitleFrame forTitles:_titles];
        
        slideTitleView;
    });
    [self addSubview:_slideTitleView];
    
    UIButton * allCateGoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    allCateGoryButton.frame = CGRectMake(SCREEN_WIDTH-(29+38)/2-13, 2, 44, 44);
    //    [allCateGoryButton setBackgroundImage:[UIImage imageNamed:@"categorys"] forState:UIControlStateNormal];
    [allCateGoryButton setImage:[UIImage imageNamed:@"categorys"] forState:UIControlStateNormal];
    
    [allCateGoryButton addTarget:self action:@selector(allCateGoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:allCateGoryButton];
    [self bringSubviewToFront:allCateGoryButton ];
    [_slideTitleView bringSubviewToFront:allCateGoryButton];
    
    //////////////////new
    
    
    self.lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 0.5)];
    self.lineview .backgroundColor = lineBlackColor;
    [self addSubview:self.lineview ];
    [self bringSubviewToFront:self.lineview ];
    [_slideTitleView bringSubviewToFront:self.lineview ];
    
    
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"portTriangleFrame" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTriangleFrame:) name:@"portTriangleFrame" object:nil];
    
    
    self.triangleView.frame = CGRectMake(25, 48-6, 14, 7);
    self.triangleView.image =  [UIImage imageNamed:@"Group 7"];
    [self addSubview:self.triangleView];
    [self bringSubviewToFront:self.triangleView];
    [_slideTitleView bringSubviewToFront:self.triangleView];
    [_lineview bringSubviewToFront:self.triangleView];
    
    __WEAK_SELF_YLSLIDE
    // slideTitleView 栏目button 点击的监听
    // 滚动到指定的栏目下
    _slideTitleView.slideTitleViewClickButtonBlock = ^(NSUInteger index){
        
        if (weakSelf) {
            
            __STRONG_SELF_YLSLIDE
            CGRect frame   = strongSelf.mainScrollview.bounds;
            frame.origin.x = CGRectGetWidth(strongSelf.frame) * index;
            
            [strongSelf.mainScrollview scrollRectToVisible:frame animated:NO];
            [strongSelf visibleViewDelegateForIndex:index];
        }
    };
}
//-(void)categorysTouchToViews:(NSNotification *)text
//{
//     NSInteger currentIndex = [text.userInfo[@"currentIndex"]integerValue];
//    [self slideViewRecycle];
//    [self visibleViewDelegateForIndex:currentIndex];
//
////    if (_prePageIndex != currentIndex) {
////        if ([_delegate respondsToSelector:@selector(slideVisibleView:forIndex:)]) {
////            [_delegate slideVisibleView:[self visibleCellForIndex:currentIndex] forIndex:currentIndex];
////
////        }
////    }
////
////    _prePageIndex = currentIndex;
//}
-(void)allCateGoryButtonClick
{
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"allCategorysBtnNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"点击分类了1");
    
}
-(void)setTriangleFrame : (NSNotification *)text
{
    NSLog(@"===---===---===---===---");
    [USER_DEFAULT setObject:@"YES" forKey:@"滑动了或者点击了"];
    float currentBtnX = [text.userInfo[@"currentBtnX"]floatValue];
    
    
    self.triangleView.frame = CGRectMake(currentBtnX, 48-6, 14, 7);
    self.triangleView.image =  [UIImage imageNamed:@"Group 7"];
    [self addSubview:self.triangleView];
    [self bringSubviewToFront:self.triangleView];
    [_slideTitleView bringSubviewToFront:self.triangleView];
    [self.lineview  bringSubviewToFront:self.triangleView];
    
}

#pragma mark Set Get
- (void)setShowsScrollViewHorizontalScrollIndicator:(BOOL)showsScrollViewHorizontalScrollIndicator{
    
    _mainScrollview.showsHorizontalScrollIndicator = showsScrollViewHorizontalScrollIndicator;
    
}

@end

