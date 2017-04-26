

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
        for (int i = 0 ; i < titles.count; i++) {
            NSDictionary *item = titles[i];
            NSString * tempArray;
            tempArray =item[@"category_name"];
            
            [_titles addObject:tempArray];
          
        }
        _prePageIndex = 1000;
        [self configSlideView];
        
       
        //监听Delegate值改变以刷新数据，不想使用者做太多无谓的方法调用
        [self addObserver:self
               forKeyPath:@"delegate"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
       
        
    }

    return self;
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
//    for (TVTable * cell  in _visibleCells) {
//        
//        if (cell.index < currentPage || cell.index > nextPage) {
//
//            //保存偏移量
//            [[YGPCache sharedCache]setDataToMemoryWithData:[NSStringFromCGPoint(cell.contentOffset) dataUsingEncoding:NSUTF8StringEncoding] forKey:[@(cell.index) stringValue]];
//            
//            
//            [_recycledCells addObject:cell];
//            [cell removeFromSuperview];
//            
//        }
//    }
   
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
{    NSInteger row = [text.userInfo[@"textOne"]integerValue];
    NSInteger row2 = [text.userInfo[@"textTwo"]integerValue];
    NSInteger row3 = [text.userInfo[@"textThree"]integerValue];
    
//    NSArray * newArray = [array objectsAtIndexes:indexSet];
    tableViewForSliderView =   [self visibleCellForIndex:row];
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row2 inSection:0];
    //
//    [tableViewForSliderView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    [tableViewForSliderView selectRowAtIndexPath:scrollIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
      //先全部变黑
    for (NSInteger  i = 0; i<row3; i++) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
        
        TVCell *cell1 = [tableViewForSliderView cellForRowAtIndexPath:indexPath1];
        
        [cell1.event_nextNameLab setTextColor:CellGrayColor]; //CellGrayColor
        [cell1.event_nameLab setTextColor:CellBlackColor];  //CellBlackColor
        [cell1.event_nextTime setTextColor:CellGrayColor]; //CellGrayColor
//        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
//        cell1.selectedBackgroundView.backgroundColor = [UIColor blueColor]; //RGBA(
        cell1.backgroundView = [[UIView alloc] initWithFrame:cell1.frame];
        cell1.backgroundView.backgroundColor = [UIColor whiteColor];
        cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
        cell1.selectedBackgroundView.backgroundColor = [UIColor whiteColor]; //RGBA
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        if(i == row2)
        {
            [cell1.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)]; //CellGrayColor
            [cell1.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];  //CellBlackColor
            [cell1.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)]; //CellGrayColor
            cell1.backgroundView = [[UIView alloc] initWithFrame:cell1.frame];
            cell1.backgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1); //RGBA(0xf8, 0xf8, 0xf8, 1);//[UIColor whiteColor];//
            cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
            cell1.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1); //RGBA
            
            cell1.selected = YES;
        }
    }
    
    //附加==
    TVCell *cell1 = [tableViewForSliderView cellForRowAtIndexPath:scrollIndexPath];
    
    cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    cell1.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
    [cell1.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)]; //CellGrayColor
    [cell1.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];  //CellBlackColor
    [cell1.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    //            cell1.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);

    //==
    [tableViewForSliderView reloadData];
    [tableViewForSliderView reloadRowsAtIndexPaths:[NSArray arrayWithObject:scrollIndexPath
                                                    ] withRowAnimation:UITableViewRowAnimationNone];
    [tableViewForSliderView reloadData];
    
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
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self visibleViewDelegateForIndex:currentPage];

    if (_slideTitleView.slideViewWillScrollEndBlock) {
        _slideTitleView.slideViewWillScrollEndBlock(scrollView.contentOffset.x);
    }
    
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
    

    
//
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"categorysTouchToViews" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categorysTouchToViews:) name:@"categorysTouchToViews" object:nil];
    
    
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
